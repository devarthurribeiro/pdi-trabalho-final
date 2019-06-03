clear all
close all

pkg load image

function imNova = separaObjetos(rotulo,vetor,qtdD)
  cont = 1;
  for k=2:qtdD+1
    for i=1:size(rotulo,1)
      for j=1:size(rotulo,2)
        if(vetor(k) == rotulo(i,j))
          imNova(i,j,cont) = 1;
        else
          imNova(i,j,cont) = 0;
        endif       
      endfor
    endfor
    cont++;
  endfor
endfunction

function imd = addPontos(imb, masc) 
  for i=1:size(imb,1)
    for j=1:size(imb,2)
      if(masc(i,j) > 0)
        masc(i,j) = imb(i,j,:);
      endif
    end
  end
  imd = masc;
endfunction

function A = contarPontos(im) 
imb = im2bw(im);
imf = medfilt2(imb);
img2=~imf;

##cotagem de bolinhas
se = strel("square", 10);
imer = imerode(img2, se);

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
A = im;
endfunction

im = imread('./p1.jpg');
imb = im2bw(im);
imf = medfilt2(imb);

img2=~imf;

se = strel("square", 15);
imer = imerode(img2, se);
mascara=~imer;
#figure('Name', 'mascara'), imshow(mascara)

[rotulo,qtdD] = bwlabel(mascara);
figure('name','label'), imshow(rotulo,[]);
colormap(jet), colorbar;
vetor = unique(rotulo);
title([strcat('Quantidade de Pecas: ',int2str(qtdD))])
separaDominos = separaObjetos(rotulo,vetor,qtdD);#separa objetos

for i=1:qtdD
   imr = addPontos(imb, (separaDominos(:,:,i)));
   ##figure('name','label'), imshow(imr);
   contarPontos(imr);
endfor