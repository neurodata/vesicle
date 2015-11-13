function vesiclerf_object(prob, threshold, minSize2D, maxSize2D, minSize3D, minSlice, doEdgeCrop, dynamicFlag, outFile, padX, padY, padZ)
%
% vesiclerf_object:  this function takes in a probability cube and parameters and outputs objects (e.g. synapses)
%
% **Inputs**
%
% prob: (string)
%   - Location of mat file containing a RAMONVolume named cube. Each value corresponds to the probability that the voxel belongs to the synapse class
%
% threshold: (float)
%   - Threshold used in converting probability cube to a binary mask of potential synapse locations.
%
% minSize2D: (uint)
%   - Minimum size threshold for synapse objects in 2D.
%
% maxSize2D: (uint)
%   - Maximum size threshold for synapse objects in 2D.
%
% minSize3D: (uint)
%   - Minimum size threshold for synapse objects in 3D.
%
% minSlice: (uint)
%   - Minimum slice persistence in 3D for a synapse to count.
%
% doEdgeCrop: (logical)
%   - 0: do not crop cube.  1: remove all synapses touching the cube boundary.
%
% dynamicFlag: (logical)
%   - 0: do not adjust threshold.  1:  adjust probability threshold to account for variable intensities (useful for large deployments)
%
% outFile: (string)
%   - String specifying the full path and file name for the output of the object detection algorithm.
%
% padX (uint)
%   - Number representing value to crop the output volume in the x dimension.
%
% padY (uint)
%   - Number representing value to crop the output volume in the y dimension.
%
% padZ (uint)
%   - Number representing value to crop the output volume in the z dimension.
%
% **Outputs**
%
%	No explicit outputs.  Output file is saved to disk rather than
%	output as a variable to allow for downstream integration with LONI.

if ischar('prob') %assume passing in a RAMONObject if in workspace
    load(prob) %else load from file; should be saved as 'cube'
    prob = cube;
end

%% Threshold probabilities

if nargin < 12 %backward compatibility
    padX = 0;
    padY = 0;
    padZ = 0;
end

temp_prob = prob.data;

% POST PROCESSING
% threshold prob
if dynamicFlag
    % Dynamic threshold, but only within a range
    ppp = temp_prob(temp_prob>0);
    t2 = prctile(ppp,99.5);

    tnew = min(t2,threshold);

    if tnew > 0.5
        threshold = tnew;
    end
end

temp_prob(temp_prob >= threshold) = 1;
temp_prob(temp_prob < 1) = 0;

% Check 2D size limits first
cc = bwconncomp(temp_prob,4);

%Apply object size filter
for jj = 1:cc.NumObjects
    if length(cc.PixelIdxList{jj}) < minSize2D || length(cc.PixelIdxList{jj}) > maxSize2D
        temp_prob(cc.PixelIdxList{jj}) = 0;
    end
end

% get size of each region in 3D
cc = bwconncomp(temp_prob,6);

% check 3D size limits and edge hits
for ii = 1:cc.NumObjects
    %to be small
    if length(cc.PixelIdxList{ii}) < minSize3D
        temp_prob(cc.PixelIdxList{ii}) = 0;
    end
end

temp_prob = minSliceEnforce(temp_prob,minSlice);

%Drop all that touch an edge
if doEdgeCrop
    % get inds of edges
    ind_block = zeros(size(prob));
    ind_block(:,:,1) = 1;
    ind_block(:,:,end) = 1;
    ind_block(1,:,:) = 1;
    ind_block(end,:,:) = 1;
    ind_block(:,1,:) = 1;
    ind_block(:,end,:) = 1;
    inds = find(ind_block == 1);

    for ii = 1:cc.NumObjects

        if any(ismember(cc.PixelIdxList{ii},inds))
            temp_prob(cc.PixelIdxList{ii}) = 0;
            %continue;
        end
    end
end

% re-run connected components
cc = bwconncomp(temp_prob,18);

fprintf('Number Synapses detected: %d\n',cc.NumObjects);

data = labelmatrix(cc);
size(data)
data = data(padX+1:size(data,1)-padX,padY+1:size(data,2)-padY,padZ+1:size(data,3)-padZ);
size(data)
%% Need to fix XYZ offset and all that
cube.setXyzOffset([cube.xyzOffset(1)+padX,cube.xyzOffset(2)+padY, cube.xyzOffset(3)+padZ]);
cube.setCutout(data);
cube
outFile
save(outFile, 'cube')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% (c) (2014) The Johns Hopkins University / Applied Physics Laboratory All Rights Reserved.
% Contact the JHU/APL Office of Technology Transfer for any additional rights.  www.jhuapl.edu/ott
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
