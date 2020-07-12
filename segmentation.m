function [mask] = segmentation(left,right)
% 3-frame-method: a good way to get the contour of a moving object with 3
% consecutive frames. Here one camera is enough.We use the left camera.PAY
% ATTENTION: N must be 4.
% 
% evaluation: 8.3/10

% read and preprocess the images
p1=left(:,:,1:3);
p1=im2double(rgb2gray(p1));
p2=left(:,:,7:9);
p2=im2double(rgb2gray(p2));
p3=left(:,:,13:15);
p3=im2double(rgb2gray(p3));

% set the main parameters of the algorithm
t1=0.028;  % Set a threshold to detect the changing pixels. The smaller t1 is, the more pixels will be detected as moving.
se1=strel('disk',1);
se2=strel('disk',8);
se3=strel('disk',5);
se4=strel('disk',5);
se5=strel('disk',11);

% 3-frame-method
diff1=abs(p1-p2);
diff1=im2bw(diff1,t1);  % convert the gray image into 2-value image
diff1=imopen(diff1,se1);  % open operation,delete small white noises
diff2=abs(p2-p3);
diff2=im2bw(diff2,t1);
diff2=imopen(diff2,se1);

% get the  raw contour of the foreground of p2
mask=diff1.*diff2; 

% improve the mask with morphology
mask=imdilate(mask,se2);  % dilate to fill black areas as much as possible 
mask=imopen(mask,se3);  % again delete white noises, especially belonging to the background
mask=bwareaopen(mask,3000);  % delete small white areas
mask=[mask;true(1,size(mask,2))]; % process boundary
mask=imfill(mask,'holes');  % fill the surrounded black areas
mask=mask(1:end-1,:);
mask=imdilate(mask,se4);  % dilate
mask=imfill(mask,'holes');  % fill the surrounded black areas
mask=imerode(mask,se5);  % erode to approach the contour of the man
mask=medfilt2(mask,[50 ,50]);  % median filtering to get a smooth contour of the final mask
mask=bwareaopen(mask,1000);  % delete small white areas

end