%the matrix K is fixed, we don't have to put it in segmentation loop
function K=get_K(im1,im2,im3)
im1=rgb_to_gray(im1);
im2=rgb_to_gray(im2);
im3=rgb_to_gray(im3);
fea1=harris_detector(im1);%get features and correspondences
fea2=harris_detector(im2);
fea3=harris_detector(im3);
corr12=point_correspondence(im1,im2,fea1,fea2);
corr23=point_correspondence(im2,im3,fea2,fea3);
corr13=point_correspondence(im1,im3,fea1,fea3);
%get H 
H12=fpa(corr12);
H23=fpa(corr23);
H13=fpa(corr13);
H_all={H12,H23,H13};%to cell for loop
V=cell(3,1);
%get h1 h2, i.e. a and c, see 4-3
%we need min 3 cameras 
for i=1:3
    H=H_all{i};
    a=H(:,1);
    c=H(:,2);
    vh1h2=[a(1)*c(1),a(1)*c(2)+a(2)*c(1),a(2)*c(2),a(3)*c(1)+a(1)*c(3),...
        a(3)*c(2)+a(2)*c(3),a(3)*c(3)]';
    vh1h1=[a(1)*a(1),a(1)*a(2)+a(2)*a(1),a(2)*a(2),a(3)*a(1)+a(1)*a(3),...
        a(3)*a(2)+a(2)*a(3),a(3)*a(3)]';
    vh2h2=[c(1)*c(1),c(1)*c(2)+c(2)*c(1),c(2)*c(2),c(3)*c(1)+c(1)*c(3),...
        c(3)*c(2)+c(2)*c(3),c(3)*c(3)]';
    V(i)={[vh1h2';(vh1h1-vh2h2)']};
end
V=cell2mat(V);
[~,~,v]=svd(V);
b=v(:,end);
B=[b(1),b(2),b(4);b(2),b(3),b(5);b(4),b(5),b(6)];
if issymmetric(B)&all(eig(B)>0)%check positive definite
    B=B;
else 
    B=-B;
end
% Cholesky-Faktorisierung and normierung 
K_welle=chol(B);
K=inv(K_welle);
K=(K-mean(K(:)))/std(K(:));
end
