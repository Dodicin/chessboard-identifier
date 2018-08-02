function normalize(file)
    %file = files(11);
    fileName = file.name;
    filePath = strcat(file.folder, '\', file.name);
    image = im2double(imread(filePath));
    if size(image,3)==3
        image = rgb2gray(image);
    end
    
%     subplot(221), imshow(I), title('org')
% 
%     %%# Process Image
%     %# edge detection
%     BW = edge(I, 'sobel');
%     subplot(222), imshow(BW), title('edge')
% 
%     %# dilation-erosion
%     se = strel('disk', 2);
%     BW = imdilate(BW,se);
%     BW = imerode(BW,se);
%     subplot(223), imshow(BW), title('dilation-erosion')
% 
%     %# fill holes
%     BW = imfill(BW, 'holes');
%     subplot(224), imshow(BW), title('fill')

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
    %# find corners
    %#corners = find( diff(diff(rho)>0) < 0 );     %# find peaks
    
    %[~,order] = sort(rho_filt, 'descend');
    %corners = order(1:10);
    [peaks, corners] = findpeaks(rho);
    %# plot boundary signature + corners
    f1 = figure; set(gcf,'Visible', 'off'); 
    plot(theta, rho, '.'), hold on
    plot(theta(corners), rho(corners), 'ro'), hold off
    xlim([-pi pi]), title('Boundary Signature'), xlabel('\theta'), ylabel('\rho');
    saveas(f1, strcat('./test3-norm1/', fileName));

    %# plot image + corners
    f2 = figure; set(gcf,'Visible', 'off'); 
    imshow(BW), hold on
    plot(B(corners,2), B(corners,1), 's', 'MarkerSize',10, 'MarkerFaceColor','r')
    hold off, title('Corners');
    saveas(f2, strcat('./test3-norm1/', strcat(fileName, 'a.jpg')));
end