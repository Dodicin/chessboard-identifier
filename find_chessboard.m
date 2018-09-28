function out = find_chessboard(file, out_folder)
    fileName = file.name;
    fileName = replace(file(1).name, '.jpg', '.png');
    filePath = strcat(file.folder, '/', file.name);
    image = im2double(imread(filePath));
    if size(image,3)==3
        image = rgb2gray(image);
    end
    
    se2 = strel('disk', 4);

    im = imgaussfilt(imadjust(image), 7.5);

    im = imopen(im, se2);
    im = edge(im, 'canny');
    im = imclose(im, se2);
    Ifill = imfill(im,'holes');
    Iarea = bwareaopen(Ifill,100);
    
    Ibiggest = bwareafilt(Iarea, 1);
    Imasked = Ibiggest .* image;
    Imasked( all(~Imasked,2), : ) = [];
    Imasked( :, all(~Imasked,1) ) = [];
    Imasked = padarray(Imasked, [2 2]);
    out = [out_folder '/' fileName];
    imwrite(Imasked, out);
end