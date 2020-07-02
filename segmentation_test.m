function [mask] = segmentation_test(left,right)
% 3-frame-method: a good way to get the contour of a moving object with 3
% consecutive frames. Here one camera is enough.We use the left camera.PAY
% ATTENTION: N must be 3.
% 
% evaluation: 8.1/10

p1=left(:,:,1:3);
p1=im2double(rgb2gray(p1));
p2=left(:,:,4:6);
p2=im2double(p2);
p2_gray=im2double(rgb2gray(p2));
p3=left(:,:,7:9);
p3=im2double(rgb2gray(p3));

se=strel('disk',1);
se2=strel('disk',6);
se3=strel('disk',3);
se4=strel('disk',40);
se5=strel('disk',12);
se6=strel('disk',5);
t=0.015;  % set a threshold: the larger t is, the more pixels will be regarded as background

diff1=abs(p2_gray-p1);
diff1=im2bw(diff1,t);  % convert the gray image into 2-value image
diff1=imopen(diff1,se);  % open image operation: first dilate, then erode
diff1=imdilate(diff1,se3);  % dilate
diff2=abs(p2_gray-p3);
diff2=im2bw(diff2,t);
diff2=imopen(diff2,se);
diff2=imdilate(diff2,se3);  % dilate

mask=diff1.*diff2;  % the programm below can be further improved, now it's a little complicated and the result is also not good enough

mask=bwareaopen(mask,6000);  % delete small white areas
mask=imfill(mask,'holes');
mask=imopen(mask,se2);
mask=imdilate(mask,se6);  % dilate
mask=imfill(mask,'holes');   % fill the surrounded black areas
mask=bwareaopen(mask,500);  % delete small white areas
mask=imclose(mask,se4);
mask=imerode(mask,se5); 
mask=imfill(mask,'holes');
mask=medfilt2(mask,[20 ,20]);  % median filtering

figure('NumberTitle', 'off', 'Name', 'final mask');imshow(mask);

figure;imshow(mask.*p2);

end
