clear
clc

tic
cd('C:\master\learning materials\CV\challenge');
config;
cd('C:\master\learning materials\CV\challenge\originalfiles\P1E_S1\P1E_S1_C1');
im1=imread('00000500.jpg');
temp1=imread('00000600.jpg');
temp2=imread('00000601.jpg');
left(:,:,1:3)=temp1;
left(:,:,4:6)=temp2;
cd('C:\master\learning materials\CV\challenge\originalfiles\P1E_S1\P1E_S1_C2');
im2=imread('00000600.jpg');
temp1=imread('00000600.jpg');
temp2=imread('00000601.jpg');
right(:,:,1:3)=temp1;
right(:,:,4:6)=temp2;
cd('C:\master\learning materials\CV\challenge\originalfiles\P1E_S1\P1E_S1_C3');
im3=imread('00000500.jpg');
cd('C:\master\learning materials\CV\challenge');
K=get_K(im1,im2,im3);%%here unrecognized error, the features of im2 and im3 cannot be extracted
mask= segmentation(left,right,K);
frame=left(:,:,1:3);
result = render(frame,mask,bg,mode);
figure(1)
imshow(frame);
figure(2)
imshow(result);
toc

