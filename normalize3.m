function normalize2(file)
    fileName = file.name;
    filePath = strcat(file.folder, '\', file.name);
    image = im2double(imread(filePath));
    if size(image,3)==3
        image = rgb2gray(image);
    end
    mask = imbinarize(imgaussfilt(image, 1.7), 0);
    mask = imfill(mask, 'holes');
    
    I = imedge;
    %Compute the centroid
    props = regionprops(mask,'centroid');
    centroid = props.Centroid;
    %Find the pixels that create the square
    [x,y] = find(I);

    %Change the origin
    X = [y,x]-centroid;

    %Sort the data
    X = sortrows(X,[1 2]);

    %Cartesian to polar coordinates
    [theta,rho] = cart2pol(X(:,1),X(:,2));

    %sort the polar coordinate according to the angle.
    [POL,index] = sortrows([theta,rho],1);

    %Smoothing, using a convolution
    len = 15; %the smoothing factor
    POL(:,2) = conv(POL(:,2),ones(len ,1),'same')./conv(ones(length(POL(:,2)),1),ones(len ,1),'same');

    %Find the peaks
    pfind = POL(:,2);
    pfind(pfind<mean(pfind)) = 0;
    [~,pos] = findpeaks(pfind);

    %Change (again) the origin
    X = X+centroid;
    
    %Plot the result
    
    plot(POL(:,1),POL(:,2));
    hold on;
    plot(POL(pos,1),POL(pos,2),'ro');
    f = figure; set(gcf,'Visible', 'off'); 
    %set(gcf,'Visible', 'off'); 
    imshow(I);
    hold on;
    plot(X(index(pos),1),X(index(pos),2),'ro');
    saveas(f, strcat('./test3-norm3/', fileName));
    
    
    
end