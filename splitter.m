function out = splitter(file, out_folder)

    labelize = false;

    fileName = strsplit(file.name, '.');
    fileName = fileName{1};
    filePath = [file.folder '/' file.name];
    image = im2double(imread(filePath));
    if size(image,3)==3
        image = rgb2gray(image);
    end

    [m, n] = size(image);
    counti = 0;
    block_role_arr = [];

    for i = 1:70:m-69

    counti = counti + 1;
    countj = 0;
        for j = 1:70:n-69
            countj = countj + 1;
            block = image(i:i+69,j:j+69);
            if(labelize)
                block_role = fen_parser(counti, countj, fileName);
                block_role_arr = [block_role_arr; block_role];
                imwrite(block, [out_folder '/' fileName '-' num2str(counti) '-' num2str(countj) '-' block_role '.png']);
            else
                imwrite(block, [out_folder '/' fileName '-' num2str(counti) '-' num2str(countj) '.png']);
            end
            
        end
    end

    out = block_role_arr;
   
end