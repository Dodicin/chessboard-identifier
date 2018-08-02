close all;
clear;
d = '/home/bern/uni/EI/project/schemi/foto/';
dp = 'schemi/foto/';
d1 = 'test1';

%% Step 1: finds chessboards in the set: 46/48
dp = 'schemi/foto/';
files = dir(fullfile(dp, '*.jpg'));
numFiles = length(files);
mkdir('./test1');
for k = 1 : numFiles
    find_chessboard(files(k));
end

%% Step 2: finds inner square for every image from Step 1: 46/46
d1 = 'test1/';
files1 = dir(fullfile(d1, '*.png'));
numFiles = length(files1);
mkdir('./test2');
for k = 1 : numFiles
    find_chessboard2(files1(k));
end

%% Step 3: transforms chessboards (normalizing): WIP
d2 = 'test2/';
files = dir(fullfile(d2, '*.png'));
numFiles = length(files);
mkdir('./test3-norm1');
mkdir('./test3-norm2');
mkdir('./test3-norm3');
for k = 1 : numFiles
    normalize(files(k));
end