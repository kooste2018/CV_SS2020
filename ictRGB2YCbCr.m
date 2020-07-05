function yuv = ictRGB2YCbCr(rgb)
% Input         : rgb (Original RGB Image)
% Output        : yuv (YCbCr image after transformation)
% YOUR CODE HERE
%para=[0.299,0.587,0.114;
%    -0.169,-0.331,0.5;
%    0.5,-0.419,-0.081];
yuv=rgb;
s=size(rgb);
for i=1:s(1)
    for j=1:s(2)
        yuv(i,j,1)=0.299*rgb(i,j,1)+0.587*rgb(i,j,2)+0.114*rgb(i,j,3);
        yuv(i,j,2)=-0.169*rgb(i,j,1)-0.331*rgb(i,j,2)+0.5*rgb(i,j,3);
        yuv(i,j,3)=0.5*rgb(i,j,1)-0.419*rgb(i,j,2)-0.081*rgb(i,j,3);
    end
end
end