function gray_image = rgb_to_gray(input_image)
    % This function is supposed to convert a RGB-image to a grayscale image.
    % If the image is already a grayscale image directly return it.
  if size(input_image,3)==3
     input_image=double(input_image);
     a=size(input_image);
     for i=1:a(1)
         for j=1:a(2)
             gray_image(i,j)=0.299*input_image(i,j,1)+0.587*input_image(i,j,2)+0.114*input_image(i,j,3);
         end
     end
     gray_image=uint8(gray_image);
  else
      gray_image=input_image;
  end
end
