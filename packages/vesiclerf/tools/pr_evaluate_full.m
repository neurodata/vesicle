function pr_evaluate_full(detectVol, truthVol, metricsFile)
% Function to compute a precision recall curve across a wide range of parameters
%
% **Inputs**
%
% detectVol: (string)
%   - Location of mat file containing detected objects in a RAMONVolume named cube.
%
% truthVol: (string)
%   - Location of mat file containing truth objects in a RAMONVolume named cube.
%
% metricsFile: (string)
%   - Location of mat file containing metrics data from conducting the sweep.
%
% **Outputs**
%
%	No explicit outputs.  Output file is saved to disk rather than
%	output as a variable to allow for downstream integration with LONI.
%
% ** Notes**
%
% This function grid searches the parameter space with no optimizations for clarity.  pr_object provides an alternative, simpler sweep.

tic
load(truthVol)
sDataTest = cube.clone;

load(detectVol)
DV = cube.data ;


clear precision recall dMtx thresh minSize
count = 1;
tic
pad = [0,0,0]; % assume padding is taken care of externally
minSize2DVals = [0,50,200];%0, 100];
maxSize2DVals = [2500, 5000, 10000];
minSize3DVals = [100, 500, 1000, 2000];
thresholdVals = [0.5, 0.6, 0.7:0.025:1];
minSliceVals = [1, 3, 5];
maxCount = length(minSize2DVals)*length(maxSize2DVals)*length(minSize3DVals)*length(thresholdVals)*length(minSliceVals);
for minSize2D = minSize2DVals
    % fprintf('OUTERLOOP: %d\n',minSize2D)
    for maxSize2D = maxSize2DVals
        for minSize3D = minSize3DVals
            for threshold = thresholdVals
                for minSlice = minSliceVals
                    temp_prob = DV;
                    fprintf('NOW PROCESSING SEARCH %d of %d...\n', count, maxCount)
                    % POST PROCESSING
                    % threshold prob
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

                    % re-run connected components
                    detectcc = bwconncomp(temp_prob,18);
                    detectMtx = labelmatrix(detectcc);

                    % POST PROCESSING
                    stats2 = regionprops(detectcc,'PixelList','Area','Centroid','PixelIdxList');

                    fprintf('Number Synapses detected: %d\n',length(stats2));

                    % 3D metrics

                    %Scale 1:
                    truthMtx = sDataTest.data(pad(1)+1:end-pad(1),pad(2)+1:end-pad(2), pad(3)+1:end-pad(3));
                    truthObj = bwconncomp(truthMtx,18);

                    TP = 0; FP = 0; FN = 0; TP2 = 0;

                    for j = 1:truthObj.NumObjects
                        temp =  detectMtx(truthObj.PixelIdxList{j});

                        if sum(temp > 0) >= 10 %50 %at least 25 voxel overlap to be meaningful
                            TP = TP + 1;

                            % TODO any detected objects can only be used
                            % once, so remove them here

                            % This does not penalize (or reward) fragmented
                            % detections
                            detectIdxUsed = unique(temp);
                            detectIdxUsed(detectIdxUsed == 0) = [];

                            for jjj = 1:length(detectIdxUsed)
                                detectMtx(detectcc.PixelIdxList{detectIdxUsed(jjj)}) = 0;

                            end
                        else
                            FN = FN + 1;
                        end
                    end

                    %length(detectObj)
                    for j = 1:detectcc.NumObjects
                        temp =  truthMtx(detectcc.PixelIdxList{j});
                        %sum(temp>0)
                        if sum(temp > 0) >= 10%50 %at least 25 voxel overlap to be meaningful
                            %TP = TP + 1;  %don't do this again, because already
                            % considered above
                            TP2 = TP2 + 1;
                        else
                            FP = FP + 1;
                        end
                    end

                    metrics.precision(count) = TP./(TP+FP);
                    metrics.recall(count) = TP./(TP+FN);
                    metrics.f1(count) = (2*metrics.precision(count)*metrics.recall(count))...
                        /(metrics.precision(count)+metrics.recall(count));
                    metrics.thresh(count) = threshold;
                    metrics.minSize2DOut(count) = minSize2D;
                    metrics.minSize3DOut(count) = minSize3D;
                    metrics.maxSize2DOut(count) = maxSize2D;
                    metrics.minSliceOut(count) = minSlice;
                    fprintf('precision: %f recall: %f threshold %f minSize2D %d minSize3D %d maxSize2D %d minSlice %d\n',metrics.precision(count),metrics.recall(count), threshold, minSize2D, minSize3D, maxSize2D, minSlice);
                    count = count + 1;
                end
            end
        end
    end
end

save(metricsFile,'metrics')
toc
