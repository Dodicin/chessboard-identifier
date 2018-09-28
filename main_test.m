close all;
clear;

%% Step 1: finds chessboards in the set: 46/48
in_folder = 'photo';
files = dir(fullfile(in_folder, '*.jpg'));
n_files = length(files);
out_folder = 'step1';
mkdir(out_folder);
return;
for k = 1 : n_files
    find_chessboard(files(k), out_folder);
end

%% Step 2: finds inner square for every image from Step 1: 46/46
in_folder = 'step1';
files1 = dir(fullfile(in_folder, '*.png'));
n_files = length(files1);
out_folder = 'presentation';
mkdir(out_folder);
for k = 1 : n_files
    find_chessboard2(files1(k), out_folder);
end

%% Step 3: transforms chessboards (normalizing): 45/46 (39 has 5 corners)
in_folder = 'step2';
files = dir(fullfile(in_folder, '*.png'));
n_files = length(files);
out_folder = 'step3';
subfolder = '/corners';
mkdir(out_folder);
mkdir(strcat(out_folder, subfolder));
for k = 1 : n_files
    normalize(files(k), out_folder);
end

%% Step 4: creating the dataset

in_folder = 'step3_working';
files = dir(fullfile(in_folder, '*.png'));
n_files = length(files);
out_folder = 'step4';
mkdir(out_folder);
cell_labels = [];

for k = 1 : n_files
    cell_labels = [cell_labels; splitter(files(k), out_folder)];
end

cell_labels = num2cell(cell_labels);
save('cell_labels', 'cell_labels');

%% Step 5: training the classifier

create_descriptor_files();
% return;
load('features/lbp');
load('features/hog');
load('features/average');
load('features/variance');
load('features/surf');

labels = load('cell_labels');
labels = labels.cell_labels;
cv = cvpartition(labels,'Holdout', 0.3);

class_table_train = table(labels, lbp, hog, average, variance);


%% Test

load('trainedModel');
in_folder = 'step4';
files = dir(fullfile(in_folder, '*.png'));
n_files = length(files);

im = im2double(imread([in_folder '\' '006-4-5-r.png']));

lbp  = compute_lbp(im);
hog = compute_hog(im);
average  = mean(im);
variance = var(im);
T = table(lbp, hog, average, variance);
yfit = trainedModel.predictFcn(T);
disp(yfit);

%% Step 6: FEN Prediction

load('trainedModel.mat');

in_folder = 'step3_working';
files = dir(fullfile(in_folder, '*.png'));
n_files = length(files);
out_folder = 'step6';
mkdir(out_folder);

import_imagescsv;
import_labelscsv;
load('trainedModel');

ok = {};
failed = {};

fen_gt = {};
fen_p = {};

for k = 1 : n_files
    fileName = strsplit(files(k).name, '.');
    fileName = fileName{1};
    fileNumber = str2double(fileName);
    
    puzzle = images.Puzzle(fileNumber);
    index = find(ismember(labels.Puzzle, puzzle));
    fen_string = labels.BoardConfiguration(index);
    fen_string = strsplit(fen_string, ' ');
    fen_string = strcat(fen_string(1), '/');
    
    fen_gt = [fen_gt; fen_string];
    
    mkdir([out_folder '\' fileName]);
    splitter(files(k), [out_folder '\' fileName]);
    
    predicted_fen = predict_fen([out_folder '\' fileName], trainedModel);
    fen_p = [fen_p; predicted_fen];
    
    if(fen_string == predicted_fen)
        ok = [ok; fileName];
    else
        failed = [failed; fileName];
    end
end




