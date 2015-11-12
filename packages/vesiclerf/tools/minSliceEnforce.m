function anno = minSliceEnforce(anno,minSlice)
% Function to remove objects that do not persist across multiple slices
%
% **Inputs**
%
% anno (uint32)
%   - Matrix containing annotation objects
%
% minSlice: (uint)
%   - Minimum number of slices required for persistence
%
% **Outputs**
%
% anno (uint32)
%   - Filtered anno matrix with spurrious detections removed.
%
% nslices = 1 will have no effect

if minSlice > 1

    Z = bwconncomp(anno,18);
   % Z.NumObjects
    for i = 1:Z.NumObjects
        [~, ~,c] = ind2sub(size(anno),Z.PixelIdxList{i});
        nSlice = length(unique(c));

        if nSlice < minSlice
            %remove
        %    disp('remove')
            anno(Z.PixelIdxList{i}) = 0;
        end
    end
    %Z = bwconncomp(D,18);
else
    disp('No change - processing skipped for continuity constraint of 1 or less')
end
