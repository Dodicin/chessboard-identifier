
folder = fullfile('data/photo');
[name, user_canceled] = imgetfile('InitialPath', folder);
[folder, name, ext] = fileparts(name);
name = [name ext];
file = struct('folder', folder, 'name', name);


s1 = 'out/step1';
s2 = 'out/step2';
s3 = 'out/step3';
s32 = 'out/step3/corners';
s4 = 'out/step4';
s5 = 'out/step5';
mkdir('out');
mkdir(s1);
mkdir(s2);
mkdir(s3);
mkdir(s32);
mkdir(s4);

tmp = find_chessboard(file, s1);

[folder, name, ext] = fileparts(tmp);
name = [name ext];
file = struct('folder', folder, 'name', name);

tmp = find_chessboard2(file, s2);

[folder, name, ext] = fileparts(tmp);
name = [name ext];
file = struct('folder', folder, 'name', name);

tmp = normalize(file, s3);

[folder, name, ext] = fileparts(tmp);
name = [name ext];
file = struct('folder', folder, 'name', name);

splitter(file, s4);

load('trainedModel');
predicted_fen = predict_fen(s4, trainedModel);
disp(predicted_fen);