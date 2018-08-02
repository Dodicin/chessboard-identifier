function normalize2(file)
    fileName = file.name;
    filePath = strcat(file.folder, '\', file.name);
    image = im2double(imread(filePath));
    if size(image,3)==3
        image = rgb2gray(image);
    end
    mask = imbinarize(imgaussfilt(image, 1.7), 0);
    mask = imfill(mask, 'holes');
    HoughDemo(mask, fileName);
    return;
    
    corners = detectHarrisFeatures(mask);
    
    
    f = figure; set(gcf,'Visible', 'off'); 
    imshow(mask), hold on;
    plot(corners.selectUniform(4, size(mask)));
    saveas(f, strcat('./test3-norm2/', fileName));
    return;
    imwrite(mask, strcat('./test3/', fileName));
    %HoughDemo(mask);
    return;
    
    
    
    imwrite(mask, strcat('./test3/', fileName));
end