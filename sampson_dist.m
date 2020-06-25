function sd = sampson_dist(F, x1_pixel, x2_pixel)
    % This function calculates the Sampson distance based on the fundamental matrix F
    e3dach=zeros(3);
    e3dach(1,2)=-1;
    e3dach(2,1)=1;
    matrixup=diag(x2_pixel'*F*x1_pixel).^2;
    matrixdown=(vecnorm(e3dach*F*x1_pixel).^2+vecnorm(e3dach*F*x2_pixel).^2)';
    sd=(matrixup./matrixdown)';
end