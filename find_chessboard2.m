function find_chessboard2(file)
    fileName = file.name;
    filePath = strcat(file.folder, '\', file.name);
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
    %BW = bwmorph(Ibiggest, 'skel', Inf);
    
    %HoughDemo(Ibiggest);
    Imasked = Ibiggest .* image;
    Imasked( all(~Imasked,2), : ) = [];
    Imasked( :, all(~Imasked,1) ) = [];
    Imasked = padarray(Imasked, [50 50]);
    imwrite(Imasked, strcat('./test2/', fileName));
    
%     figure, imshow(BW);
%     stat = regionprops(Ifinal,'boundingbox');
%     figure;
%     imshow(image); hold on;
%     for cnt = 1 : numel(stat)
%         bb = stat(cnt).BoundingBox;
%         rectangle('position',bb,'edgecolor','r','linewidth',2);
%     end
end