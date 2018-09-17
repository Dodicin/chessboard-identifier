close all;
clear;
d = '/home/bern/uni/EI/project/schemi/foto/';
dp = 'schemi/foto/';
d1 = 'test1';

%% Step 1: finds chessboards in the set: 46/48
in_folder = 'foto';
files = dir(fullfile(in_folder, '*.jpg'));
n_files = length(files);
out_folder = 'step1';
mkdir(out_folder);
for k = 1 : n_files
    find_chessboard(files(k), out_folder);
end

%% Step 2: finds inner square for every image from Step 1: 46/46
in_folder = 'step1';
files1 = dir(fullfile(in_folder, '*.png'));
n_files = length(files1);
out_folder = 'step2';
mkdir(out_folder);
for k = 1 : n_files
    find_chessboard2(files1(k), out_folder);
end

%%%% nota Giorgia: Contrast Limited Adaptive Histoigram Equalization
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

%% Step 4: classification

in_folder = 'step3_working';
files = dir(fullfile(in_folder, '*.png'));
n_files = length(files);
out_folder = 'step4';
mkdir(out_folder);

for k = 1 : n_files
    splitter(files(k), out_folder);
end


%% Prima colonna (label) ogni pezzo tutte le altre colonne feature

label = {'pedone'; 'regina'};
feature1 = [1; 0.5];
feature2 = [0.1; 0.2];

classifier_table = table(label, feature1, feature2);


