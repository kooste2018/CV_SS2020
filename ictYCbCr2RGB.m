function rgb = ictYCbCr2RGB(yuv)
% Input         : yuv (Original YCbCr image)
% Output        : rgb (RGB Image after transformation)
% YOUR CODE HERE
rgb=yuv;
s=size(yuv);
for i=1:s(1)
    for j=1:s(2)
    rgb(i,j,1)=yuv(i,j,1)+1.402*yuv(i,j,3);
    rgb(i,j,2)=yuv(i,j,1)-0.344*yuv(i,j,2)-0.714*yuv(i,j,3);
    rgb(i,j,3)=yuv(i,j,1)+1.772*yuv(i,j,2);
    end
end
end