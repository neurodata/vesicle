function vesiclerf_example(zStart,zStop)
% Driver function to demonstrate vesicle-rf functionality for new users.
%
% **Inputs**
%
%	None.  Driver script is self-contained.
%
% **Outputs**
%
%	None.  Driver script is self-contained.
%
% **Notes**
%
% Using the default parameters, small edge synapses may be missed in this reference implementation.
% As a prerequisite to running this script, you should have a trained classifier (provided in the git repo)
% called bmvc_classifier - you can use a different classifier if desired

if nargin < 2
    zStart = 1000;
    zStop = 1100;
end

zSlice = [zStart, zStop];
padX = 50; padY = 50; padZ = 2;

%Get data

[eData, mData, sData, vData] = get_ac3_data(zSlice(1),zSlice(2), padX, padY, padZ);

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
vesiclerf_object('classProbTest.mat', 0.90, 0, 5000, 2000, 1, 0, 0, 'testObjVol.mat', 0, 0, 0)
%% UPLOAD

if 0 % sample upload - please provide your own token and channels
server = 'openconnecto.me';
token = 'vesicle_example';
channel = 'prob';

cubeUploadDense(server, token, channel, 'testObjVol', 'RAMONSynapse', 0)

channel = 'object'
cube()
end

%% METRICS COMPUTATION
pr_objects('testObjVol','sDataPR','metrics_short')
pr_evaluate_full('classProbTest','sDataPR','metrics_full')
load metrics_full
metrics
