function HoughDemo(im, fileName)
  %close all;
%   % Vogliamo trovare il cartello stradale nell'immagine
% 
%   % Carichiamo l'immagine RGB e ridimensioniamola al 50%
%   imrgb = imresize(imread('test4/017.jpg'), 0.5);
%   
%   % Convertiamo l'immagine a livelli di grigio e a valori tra 0 e 1
   imgray = im;
  
  [rows,cols,ch] = size(im);
  
  %figure,imshow(imgray),title('Immagine di input');

  % Calcoliamo gli edge usando Canny
  % Modifichiamo la sigma del filtro Gaussiano di canny 
  % I valori di soglia dei gradienti, a e b, li facciamo calcolare in automatico 
  % Vogliamo avere pochi edge e non perdere quelli del cartello stradale
  imedge = edge(imgray,'Canny',[], 3);
  %imedge = bwmorph(imgray, 'remove');
  %figure,imshow(imedge),title('Immagine degli edge');
  
  
  % Applichiamo la trasformata di hough per le linee
  % H ? l'immagine dello spazio dei parametri (rho,theta)==(y,x)
  % H contiene le evidenze che una coppia (rho, theta) corrisponda ad una
  % linea presente nell'immagine degli edge. Valori alti significano forti
  % evidenze.
  % T contiene i valori di theta corrispondenti alle coordinate x di H
  % R contiene i valori di rho corrispondenti alle coordinate y di H
  [H,T,R] = hough(imedge, 'RhoResolution', 8);
  %figure,imagesc(H),colorbar,title('Spazio dei parametri della trasformata di Hough');
  
  % Cerchiamo i massimi nella matrice H. Dato che ci interessano 4 linee, 
  % ci facciamo ritornare 4 valori (va bene se siamo ragionevolmente sicuri che 
  % nell'immagine degli edge ci sono 4 linee dominanti). 
  % La funzione houghpeaks ritorna le coordinate (y,x) della matrice dove
  % ci sono i massimi. Per sapere a che parametri corrispondono, dobbiamo 
  % prelevare i valori di rho e theta da R e T.
  coords = houghpeaks(H,4);
  rhos   = R(coords(:,1));
  thetas = T(coords(:,2));
  
  % I valori di theta sono in gradi, ci servono i valori in radianti
  thetas = thetas*pi/180;
  
  % Disegnamo le linee individuate su una nuova figure (funsione scritta
  % sotto)
  draw_lines(imedge,rhos,thetas, fileName);
  
  % L'equazione delle linee della trasformata di hough crea linee
  % "infinite". Dobbiamo trovare i segmenti di linea utili per localizzare
  % il cartello. Cerchiamo le intersezioni tra le linee (funzioni scritte sotto).
  %XY=find_intersection_points(rhos,thetas,rows,cols);
  %draw_intersection_points(imedge,XY);
  
  % Raddrizziamo il cartello stradale (da fare, la funzione ? scritta sotto)
  %rotate_sign(imedge,XY);
end

function draw_lines(im,rhos,thetas, fileName)
  f = figure; set(gcf,'Visible', 'off'); 
  imshow(im);
  hold on
  X=[1:size(im,2)]; % tutti i valori delle coordinate x
  for n = 1 : numel(rhos)
    Y=(rhos(n)-X*cos(thetas(n)))/sin(thetas(n)); % valori delle coordinate y
    % Si risolve su y l'equazione rho=x*cos(theta)+y*sin(theta) 
    plot(X,Y,'r-', 'LineWidth', 1);
  end
  saveas(f, strcat('./test3-hough/', fileName));
end

function XY=find_intersection_points(rhos,thetas,rows,cols)
  % Dobbiamo risolvere un sistema lineare in due equazioni:
  %   rho1=x*cos(theta1)+y*sin(theta1)
  %   rho2=x*cos(theta2)+y*sin(theta2)
  % Testiamo tutte le possibili coppie di rette
  % Solo i punti che sono dentro l'immagine sono utili
  n = numel(rhos);
  XY=[];
  for i = 1 : n
    for j = i+1 : n
      A=[cos(thetas(i)) sin(thetas(i)); cos(thetas(j)) sin(thetas(j))];
      B=[rhos(i);rhos(j)];
      C=linsolve(A,B);
      x=C(1);y=C(2);
      if (x<0) || (y<0) || x>cols || y>rows
        continue;
      end
      XY=[XY;x y];
    end
  end
end

function XY=draw_intersection_points(im,XY)
  figure,imshow(im)
  hold on
  
  % Plottiamo i punti
  plot(XY(:,1),XY(:,2),'g*');
  
  % Ordiniamo i punti per avere una figura convessa
  k = convhull(XY(:,1),XY(:,2));
  XY = XY(k,:);
  
  % Disegnamo le linee del perimetro 
  plot(XY(:,1),XY(:,2),'b-','lineWidth',1);
  
  XY = XY(1:end-1,:); % L'ultimo punto coincide con il primo. Lo togliamo.
end

function rotate_sign(imedge,XY)
  % E' necessario determinare la trasformazione necessaria per portare il 
  % quadrilatero corrispondente al cartello stradale in un quadrato.
  
  % Suggerimento: usare maketform e imtransform
  
end