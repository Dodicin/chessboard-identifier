function out=compute_surf(image)
  ch = size(image,3);
  
  if (ch==3) 
    image = rgb2gray(image);
  end
  
  points = detectSURFFeatures(image);
  out = extractFeatures(image, points);

end