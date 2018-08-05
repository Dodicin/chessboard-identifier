close all;
clear;
d = '/home/bern/uni/EI/project/schemi/foto/';
dp = 'schemi/foto/';
d1 = 'test1';

%% Step 1: finds chessboards in the set: 46/48
in_folder = 'foto/';
files = dir(fullfile(in_folder, '*.jpg'));
n_files = length(files);
out_folder = 'step1';
mkdir(out_folder);
for k = 1 : n_files
    find_chessboard(files(k), out_folder);
end

%% Step 2: finds inner square for every image from Step 1: 46/46
in_folder = 'step1/';
files1 = dir(fullfile(in_folder, '*.png'));
n_files = length(files1);
out_folder = 'step2';
mkdir(out_folder);
for k = 1 : n_files
    find_chessboard2(files1(k), out_folder);
end

%% Step 3: transforms chessboards (normalizing): WIP
in_folder = 'step2/';
files = dir(fullfile(in_folder, '*.png'));
n_files = length(files);
out_folder = 'step3';
mkdir(out_folder);
for k = 1 : n_files
    normalize(files(k), out_folder);
end