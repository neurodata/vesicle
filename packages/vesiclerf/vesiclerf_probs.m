function vesiclerf_probs(edata, vesicles, membrane, classifier_file, padX, padY, padZ, outFile)
% Function to compute classifier probabilities on an input data cube.
%
% **Inputs**
%
% edata: (string)
%   - Location of mat file containing uint8 EM data RAMONVolume, saved as 'cube'.
%
% vesicles: (string)
%   - Location of mat file containing uint32 vesicle data RAMONVolume, saved as 'cube'.
%
% membrane: (string)
%   - Location of mat file containing float32 membrane data RAMONVolume, saved as 'cube'.
%
% classifier_file: (string)
%   - Location of classifier mat file, created during training.  Classifier is saved as the variable 'classifier'.
%
% padX (uint)
%   - Number representing value to crop the output volume in the x dimension.
%
% padY (uint)
%		- Number representing value to crop the output volume in the y dimension.
%
% padZ (uint)
%   - Number representing value to crop the output volume in the z dimension.
%
% outFile (string)
%   - Location of output file, saved as a matfile containing a RAMONVolume named 'cube'.  Contains result of applying classifier to input data.  Output cube is a probability map (float32).
%
% **Outputs**
%
%	No explicit outputs.  Output file is saved to disk rather than
%	output as a variable to allow for downstream integration with LONI.
%
% **Notes**
%
%	Optionally, input data may be passed in as variables from the current workspace, rather than through files.


disp('Executing vesiclerf-probs')

% Load data volume
if ischar(edata)
    load(edata) %should be saved as cube
    edata = cube; %#ok<NODEF>
end

% Load data volume
if ischar(vesicles)
    load(vesicles) %should be saved as cube
    vesicles = cube;
end

% Load data volume
if ischar(membrane)
    load(membrane) %should be saved as cube
    membrane = cube;
end

tic
% Find valid pixels
if exist('membrane') %#ok<EXIST>
    mThresh = 0.75;
    mm = (membrane.data>mThresh);
    mm = imdilate(mm,strel('disk',5));
    mm = bwareaopen(mm, 1000, 4);
    pixValid = find(mm > 0);
else % this exists as a starting point if membranes are unavailable
    pixValid = 1:numel(eData.data);
end

% Extract Feats and Run Classifier
disp('Feature Extraction...')
Xtest = vesiclerf_feats(edata.data, pixValid, vesicles);
toc

em = edata.data;

[xs, ys, zs] = size(em);

DV = zeros(xs*ys*zs,1);

disp('Running RF classifier...')

%load classifier
if ~isfield(classifier_file,'importance')
    load(classifier_file)
else
    classifier = classifier_file;
end

clear classifier_file

votes_sTest = zeros(xs*ys*zs,2);

idxToTest = pixValid;
tic
chunk = 1E6;
nChunk = min(ceil(length(idxToTest)/chunk),length(Xtest));
for i = 1:nChunk
    if i < nChunk
        tIdx = (i-1)*chunk+1:i*chunk;
    else
        tIdx = (i-1)*chunk+1:length(idxToTest);
    end
    [~,votes_sTest(idxToTest(tIdx),:)] = classRF_predict(double(Xtest(tIdx,:)),classifier);toc

end

if nChunk > 0
    DV = votes_sTest(:,2)./sum(votes_sTest,2);
end

DV(isnan(DV)) = 0;
% postprocessing
disp('Post-processing data...')

DV = reshape(DV,[xs,ys,zs]);

% Need to crop padded region
size(DV)
DV = DV(padX+1:size(DV,1)-padX,padY+1:size(DV,2)-padY,padZ+1:size(DV,3)-padZ);
size(DV)
%% Need to fix XYZ offset and all that
cube = edata.clone;
cube.setXyzOffset([edata.xyzOffset(1)+padX,edata.xyzOffset(2)+padY, edata.xyzOffset(3)+padZ]);
cube.setResolution(edata.resolution);
cube.setCutout(DV);
cube
% Need to save output file
save(outFile,'cube')


% (c) [2014] The Johns Hopkins University / Applied Physics Laboratory All Rights Reserved. Contact the JHU/APL Office of Technology Transfer for any additional rights.  www.jhuapl.edu/ott
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
