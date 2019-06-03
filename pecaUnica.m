clear all
close all

pkg load image

im = imread('./p1.jpg');
imb = im2bw(im);
imf = medfilt2(imb);
img2=~imf;

##cotagem de bolinhas
se = strel("square", 10);
imer = imerode(img2, se);
figure('Name', 'erode')
imshow(imer)

boundsb = bwboundaries(img2, 8, "noholes");
boundsbe = bwboundaries(imer, 8, "noholes");

contL = 0;
contTotal = (length(boundsbe)-1);
isCount = true;
divisor = 0;
for k = 2:numel (boundsb)
  n = length(boundsb {k});
  if(n > 65) 
    divisor = (boundsb {k} (1,1));
  endif
endfor

for k = 2:numel (boundsb)
  n = length(boundsb {k});
  if((boundsb {k} (1,1)) < divisor && n > 40) 
    contL++;
  endif
endfor

label = sprintf("Sua peça é uma: %dx%d", contL, (contTotal-contL));

figure('Name', '2')
imshow(im)
text(40,40,strcat('\color{green}',label))
text(40,80,strcat('\color{green}Total de pontos:',num2str(length(boundsbe)-1)))

hold on
 for k = 2:numel (boundsb)
   n = length(boundsb {k});
   if(n < 65) 
    plot (boundsb {k} (:, 2), boundsb {k} (:, 1), '.g', 'linewidth', 5);
   endif 
 endfor
hold off

