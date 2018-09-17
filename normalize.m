function normalize(file, out_folder)
    %file = files(1);
    fileName = file.name;
    filePath = strcat(file.folder, '/', file.name);
    image = im2double(imread(filePath));
    if size(image,3)==3
        image = rgb2gray(image);
    end

    %# get boundary
    BW = image;
    B = bwboundaries(BW, 8, 'noholes');
    B = B{1};

    %%# boudary signature
    %# convert boundary from cartesian to polar coordinates
    objB = bsxfun(@minus, B, mean(B));
    [theta, rho] = cart2pol(objB(:,2), objB(:,1));
    rho = medfilt1(rho, 10);
    rho_mean = mean(rho);
    rho(rho<rho_mean) = rho_mean;
    
    [peaks, corners] = findpeaks(rho);
    rho_mean = mean(rho(corners));
    
    rho(rho<rho_mean-100) = rho_mean;
    %# find corners
    %#corners = find( diff(diff(rho)>0) < 0 );     %# find peaks
    
    %[~,order] = sort(rho_filt, 'descend');
    %corners = order(1:10);
    
    
    if numel(corners) > 4
        corners_new = [];
        skip = [];
        [~,theta_order]=sort(theta(corners)+3);
        corners=corners(theta_order);
        
        n_corners = numel(corners);
        
        for i = 1 : n_corners - 1
            if(~any(skip == i))
                corn1 = theta(corners(i)) + 5;
                corn2 = theta(corners(i+1)) + 5;
                x = corn2 - corn1;
                if x <= 0.01
                    avg = (corn1+corn2)/2;
                    theta(corners(i)) = avg - 5;
                    corners_new = [corners_new, corners(i)];
                    skip = [skip, i+1];
                else
                    if x > 0.01 && x < 1
                        [~, max_index] = max([rho(corners(i)), rho(corners(i+1))]);
                        corners_new = [corners_new, corners(i+max_index-1)];
                        skip = [skip, i+(2-max_index)];
                    else
                        corners_new = [corners_new, corners(i)];
                        if(n_corners - i == 1)
                            corners_new = [corners_new, corners(i+1)];
                        end
                    end
                end
            end
        end
        corners_old = corners;
        corners = unique(corners_new);
    end
    

    %# plot boundary signature + corners
    f1 = figure; set(gcf,'Visible', 'off'); 
    plot(theta, rho, '.'), hold on
    plot(theta(corners), rho(corners), 'ro'), hold off
    xlim([-pi pi]), title('Boundary Signature'), xlabel('\theta'), ylabel('\rho');
    saveas(f1, strcat(out_folder, '/corners/',fileName));

    %# plot image + corners
    f2 = figure; set(gcf,'Visible', 'off'); 
    imshow(BW), hold on
    x = B(corners, 2);
    y = B(corners, 1);
    plot(x, y, 's', 'MarkerSize',10, 'MarkerFaceColor','r');
    hold off, title('Corners');
    saveas(f2, strcat(out_folder, '/corners/', strcat(fileName, '-plot.png')));
    
    % orthonormalization of the schemes
    try
        base = [0 0; 10 0; 10 10;  0 10];
        tf = fitgeotrans([x y], base*50, 'projective');
        [xf1, ~] = imwarp(BW, tf);
        xf1( all(~xf1,2), : ) = [];
        xf1( :, all(~xf1,1) ) = [];
        [r, c] = size(xf1);
        xf1(r-10:r, :) = [];
        xf1(:, c-10:c) = [];
        xf1(1:10, :) = [];
        xf1(:, 1:10) = [];
        imwrite(xf1, strcat(out_folder, '/', fileName));
    catch ME
    end
    
end