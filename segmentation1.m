% It's very easy to seperate the background and the foregound if we simply
% compare one photo with the already existing background with a proper threshold of the difference. 
% But some noise will remain. One possible reason is that the effect of light and shadow can't simply be ignored in this case. 
% So this method is not feasible enough.

% You can try this easy function with 2 photos to verify it. The ideal output "mask" should be a black background with only a white human figure.

function [mask] = segmentation1(background,photo)
background=imread(background);
background=im2double(rgb2gray(background));
photo=imread(photo);
photo=im2double(rgb2gray(photo));
mask=photo;


diff=abs(background-photo);
diff(diff<0.1)=0;  % set a threshold
mask(diff==0)=0;
mask(mask~=0)=1;

figure;imshow(mask);

end
