% vesicle-rf driver
% W. Gray Roncal

% In this standalone (non-LONI) paradigm, many defaults have to be defined.
%  We use a helper function, get_ac3_data

% Note that results here won't exactly equal the LONI version because of
% cropping effects. (TODO)

%% BLOCK COMPUTE AND CUBE CUTOUT STANDALONE REPLACEMENT

zSlice = [1000,1100]; 
padX = 50; padY = 50; padZ = 2;

%Get data

[eData, mData, sData, vData] = get_ac3_data_50_50_2_pad(zSlice(1),zSlice(2));

% Save Data in an appropriate format

cube = eData.clone;
save('eData.mat','cube');

cube = mData.clone;
save('mData.mat','cube');

cube = sData.clone;
save('sData.mat','cube');

cube.setCutout(cube.data(1+padX:end-padX, 1+padY:end-padY, 1+padZ:end-padZ));
save('sDataPR.mat','cube');

cube = vData.clone;
save('vData.mat','cube');

% When deploying vesicle-rf, the core of the code consists of
% vesiclerf_probs and vesiclerf_object
%% PIXEL CLASSIFICATION
vesiclerf_probs('edata', 'vData', 'mData', 'bmvc_classifier', padX, padY, padZ, 'classProbTest.mat')
%% OBJECT PROCESSING
vesiclerf_object('classProbTest.mat', 0.90, 0, 5000, 2000, 0, 0, 'testObjVol.mat')
%% UPLOAD

if 0 
server = 'openconnecto.me';
token = 'vesicle_results_bmvc';
channel = '';

cubeUploadDense(server, token, channel, 'testObjVol', 'RAMONSynapse', 0)
end
%% METRICS COMPUTATION
pr_eval_metrics('testObjVol','sDataPR','metricsTest')
pr_evaluate_full_v2('classProbTest','sDataPR','metrics_bmvc')
load metrics_bmvc
metrics
