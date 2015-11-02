function anno = minSliceEnforce(anno,minSlice)
%3D Filter
%nslices = 1 will have no effect

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