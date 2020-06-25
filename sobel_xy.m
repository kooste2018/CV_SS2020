function [Fx, Fy] = sobel_xy(input_image)
    % In this function you have to implement a Sobel filter 
    % that calculates the image gradient in x- and y- direction of a grayscale image.

    gab=[log(2)/2,0,-log(2)/2];
    g=[1/4,1/2,1/4];
    filter_x=g'*gab/(log(2)/8);
    filter_y=filter_x';
    Fx=conv2(input_image,filter_x,'same');
    Fy=conv2(input_image,filter_y,'same');
end