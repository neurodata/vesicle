function vesicledetect_quick_deploy(tokenDown, channelDown, queryFile, ...
    template, annoId, neighborhood_size, neighbor_dist, thresh, ...
    data_set, padX, padY, padZ, upToken, upChannel)


% Get data

oo = OCP();
oo.setImageToken(tokenDown);
oo.setImageChannel(channelDown);
load(queryFile)

cube = oo.query(query);

if sum(cube.data(:)) > 0
    zz = tempname;
    
    vesicledetect_quick(cube, template, annoId, neighborhood_size, neighbor_dist, thresh, data_set, padX, padY, padZ, zz)
    
    load(zz)
    
    delete(zz)
    
    if sum(cube.data(:)) > 0
        % Put data
        cube.setChannel(upChannel);
        cube.setDataType(eRAMONChannelDataType.uint32); %just in case
        cube.setChannelType(eRAMONChannelType.annotation)
        tic
        oo.setAnnoToken(upToken)
        oo.setAnnoChannel(upChannel)
        oo.createAnnotation(cube);
        fprintf('Block Write Upload: ');
        toc
    else
        disp('no vesicles - skipping upload')
    end
else
    disp('black region - skipping processing')
end
