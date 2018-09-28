%function create_descriptor_files()
  % Calcola i descrittori delle immagini e li salva su file.

  import_imagescsv;
  import_labelscsv;
  
  in_folder = 'step4';
  files = dir(fullfile(in_folder, '*.png'));
  n_files = length(files);

  lbp = [];
  hog = [];
  surf = [];
  average = [];
  variance = [];
  extrema = [];
  convexhull = [];
  eccentricity = [];
  
  for k = 1 : n_files
    im = im2double(imread([in_folder '\' files(k).name]));
    bw = imbinarize(im);
%     extrema = [extrema; regionprops(bw, 'Extrema')];
%     convexhull = [convexhull; regionprops(bw, 'ConvexHull')];
%     eccentricity = [eccentricity; regionprops(bw, 'Eccentricity')];
    %surf = [surf; compute_surf(im)];
    lbp   = [lbp;compute_lbp(im)];
    hog = [hog; compute_hog(im)];
    average  = [average;mean(im)];
    variance = [variance;var(im)];
  end
  
  save('features/lbp','lbp');
  save('features/hog','hog');
  save('features/surf','surf');
  save('features/average','average');
  save('features/variance','variance');
%   save('features/extrema','extrema');
%   save('features/convexhull','convexhull');
%   save('features/eccentricity','eccentricity');
  
%end