function splitter(file, out_folder)
    %file = files(1);
    fileName = file.name;
    filePath = strcat(file.folder, '/', file.name);
    image = im2double(imread(filePath));
    if size(image,3)==3
        image = rgb2gray(image);
    end
    
   image = imresize(image, [64 64]);
   
   [m,n] = size(image);
   Blocks = cell(m/8,n/8);
   counti = 0;
   
   for i = 1:8:m-7
       counti = counti + 1;
       countj = 0;
       for j = 1:8:n-7
            countj = countj + 1;
            Blocks{counti,countj} = image(i:i+7,j:j+7);
            imwrite(image(i:i+7,j:j+7), strcat(out_folder, '/', fileName));

       end
   end
   
end