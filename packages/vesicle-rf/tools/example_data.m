% vesiclerf_upload_examples


idx = find(metrics.recall > 0.91);
idx = idx(1);
z = [metrics.minSize2DOut(idx), metrics.maxSize2DOut(idx), metrics.minSize3DOut(idx), metrics.minSliceOut(idx), metrics.thresh(idx), metrics.recall(idx), metrics.precision(idx)];
fprintf('precision: %0.2f, recall: %0.2f\n', z(7), z(6))
vesiclerf_object('classProbTest.mat', z(5), z(1), z(2), z(3), 0, 0, 'testObjVol1.mat')

idx = find(metrics.f1 == max(metrics.f1));
idx = idx(1);
z = [metrics.minSize2DOut(idx), metrics.maxSize2DOut(idx), metrics.minSize3DOut(idx), metrics.minSliceOut(idx), metrics.thresh(idx), metrics.recall(idx), metrics.precision(idx)];
fprintf('precision: %0.2f, recall: %0.2f\n', z(7), z(6))
vesiclerf_object('classProbTest.mat', z(5), z(1), z(2), z(3), 0, 0, 'testObjVol2.mat')

idx = find(metrics.recall == max(metrics.recall(metrics.precision > 0.99 & metrics.minSliceOut == 1)) & metrics.precision > 0.99 & metrics.minSliceOut == 1);
idx = idx(1);
z = [metrics.minSize2DOut(idx), metrics.maxSize2DOut(idx), metrics.minSize3DOut(idx), metrics.minSliceOut(idx), metrics.thresh(idx), metrics.recall(idx), metrics.precision(idx)];
fprintf('precision: %0.2f, recall: %0.2f\n', z(7), z(6))
vesiclerf_object('classProbTest.mat', z(5), z(1), z(2), z(3), 0, 0, 'testObjVol3.mat')

server = 'openconnecto.me';
token = 'vesiclerf_example';

channel = 'op_point1';
cubeUploadDense(server, token, channel, 'testObjVol1', 'RAMONSynapse', 0)

channel = 'op_point2';
cubeUploadDense(server, token, channel, 'testObjVol2', 'RAMONSynapse', 0)

channel = 'op_point3';
cubeUploadDense(server, token, channel, 'testObjVol3', 'RAMONSynapse', 0)

!wget http://openconnecto.me/ocp/ca/vesiclerf_example/prob/hdf5/1/5472,6496/8712,9736/1000,1100/

channel = 'prob';
uploadLabels(server, token, channel, 'classProbTest', 'null', 1, 0)

http://openconnecto.me/ocp/ca/kasthuri11cc/image/hdf5/1/5472,6496/8712,9736/1000,1100/
http://openconnecto.me/ocp/ca/vesiclerf_example/prob/hdf5/1/5472,6496/8712,9736/1000,1100/
http://openconnecto.me/ocp/ca/vesiclerf_example/op_point1/hdf5/1/5472,6496/8712,9736/1000,1100/
http://openconnecto.me/ocp/ca/vesiclerf_example/op_point2/hdf5/1/5472,6496/8712,9736/1000,1100/
http://openconnecto.me/ocp/ca/vesiclerf_example/op_point3/hdf5/1/5472,6496/8712,9736/1000,1100/