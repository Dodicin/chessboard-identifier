function out=compute_hog(image)
  ch = size(image,3);
  
  if (ch==3) 
    image = rgb2gray(image);
  end

  out = extractHOGFeatures(image, 'CellSize', [8 8]);

end