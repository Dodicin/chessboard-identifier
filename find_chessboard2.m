function out = find_chessboard2(file, out_folder)

    fileName = file.name;
    filePath = strcat(file.folder, '/', file.name);
    image = im2double(imread(filePath));
    if size(image,3)==3
        image = rgb2gray(image);
    end
    image = imadjust(imresize(image, 0.5));
    
    im = image;
    im = 1-im;
    
    im = imtophat(im, strel('disk', 8));
    im = edge(im, 'canny', [], 1.5);
    im = imclose(im, strel('disk', 3));
    Ifill = imfill(im, 'holes');

    Iarea = bwareaopen(Ifill, 100);
    Ibiggest = bwareafilt(Iarea, 1);

    Ibiggest = bwmorph(Ibiggest, 'spur');
    Ibiggest = bwmorph(Ibiggest, 'fill');
    Ibiggest = imopen(Ibiggest, strel('disk', 6));
    Ibiggest = bwmorph(Ibiggest, 'spur');
    Ibiggest = bwmorph(Ibiggest, 'hbreak');
    Ibiggest = bwmorph(Ibiggest, 'fill');
    Ibiggest = bwareafilt(Ibiggest, 1);

    Imasked = Ibiggest .* image;
    Imasked( all(~Imasked,2), : ) = [];
    Imasked( :, all(~Imasked,1) ) = [];
    Imasked = padarray(Imasked, [50 50]);
    
    out = [out_folder '/' fileName];
    imwrite(Imasked, out);

end