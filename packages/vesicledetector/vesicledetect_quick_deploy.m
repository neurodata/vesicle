function vesicledetect_quick_deploy(tokenDown, channelDown, queryFile, ...
    template, annoId, neighborhood_size, neighbor_dist, thresh, ...
    data_set, padX, padY, padZ, upToken, upChannel)


% Get data

oo = OCP();
oo.setImageToken(tokenDown);
oo.setImageChannel(channelDown);
load(queryFile)

cube = oo.query(query);

vesicledetect_quick(cube, template, annoId, annoId, neighborhood_size, neighbor_dist, thresh, data_set, padX, padY, padZ, outFile)

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
