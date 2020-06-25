function [mask] = segmentation(left,right)
  % Add function description here
  %
  %
  %sobel filter, harris, KP, 3D reconstruction, get lambda and compare, if changes, so it is human, foreground
  %suppose N=1 
  %image 1 and 2 belong to first image pair, extract image, convert to gray
  image1=rgb_to_gray(left(:,:,1:3));
  image3=rgb_to_gray(left(:,:,4:6));
  image2=rgb_to_gray(right(:,:,1:3));
  image4=rgb_to_gray(right(:,:,4:6));
  %get features
  features1=harris_detector(image1);
  features2=harris_detector(image2);
  features3=harris_detector(image3);
  features4=harris_detector(image4);
  %get correspondences
  correspondences1=point_correspondence(image1,image2,features1,features2);
  correspondences2=point_correspondence(image3,image4,features3,features4);
  %get robust correspondences
  correspondences_robust1 = F_ransac(correspondences1);
  correspondences_r obust2 = F_ransac(correspondences2);
  %get essential matrix, K unknown, so use F
  F1=epa(correspondences_robust1);
  F2=epa(correspondences_robust2);
  %get euklidean movement,this function is not implemented yet
  [T1_1, R1_1, T2_1, R2_1, U_1, V_1] = TR_from_F(F1)
  [T1_2, R1_2, T2_2, R2_2, U_2, V_2] = TR_from_F(F2)
  %reconstruction, due to K this function is to be edited, and I only want
  %lambda, the function can be simplified
  [~, ~, lambda1, ~, ~] = reconstruction(T1_1, T2_1, R1_1, R2_1, correspondences_robust1,K)
  [~, ~, lambda2, ~, ~] = reconstruction(T1_2, T2_2, R1_2, R2_2, correspondences_robust2,K)
  %get lambda, compare lambda and recognize human
  lambda_diff=abs(lambda1-lambda2);
  [indices,~,~]=find(lambda_diff>0.05);
  %here I set a tolerance, if difference is bigger than it, 
  %I think it is foreground, row shows indices of correspondences_robust
  foreground=correspondences_robust1(1:2,indices);
  %use polygon to generate mask
  foreground(:,end+1)=foreground(:,1);
  mask=poly2mask(foreground(1,:),foreground(2,:),size(left,1),size(left,2));
end