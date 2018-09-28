function out=predict_fen(in_folder, trainedModel)

    files = dir(fullfile(in_folder, '*.png'));
    n_files = length(files);
    
    spaces = 0;
    out = [];
    for k = 1 : n_files
        filePath = [files(k).folder '\' files(k).name];
        image = im2double(imread(filePath));
        if size(image,3)==3
            image = rgb2gray(image);
        end
        
        lbp  = compute_lbp(image);
        hog = compute_hog(image);
        average  = mean(image);
        variance = var(image);
        T = table(lbp, hog, average, variance);
        yfit = trainedModel.predictFcn(T);
        yfit = yfit{1};
        
        if(yfit == '0')
            spaces = spaces + 1;
        else
            if(spaces > 0)
                yfit = [num2str(spaces) yfit];
            end
            spaces = 0;
            out = [out yfit];
        end
        
        if(mod(k, 8)==0)
            if(spaces > 0)
                out = [out num2str(spaces) '/'];   
                spaces = 0;
            else
                out = [out '/'];
            end
            
        end
        
        
    end
end