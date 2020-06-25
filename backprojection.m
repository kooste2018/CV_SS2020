function [repro_error, x2_repro] = backprojection(correspondences, P1, Image2, T, R, K)
    % This function calculates the mean error of the back projection
    % of the world coordinates P1 from image 1 in camera frame 2
    % and visualizes the correct feature coordinates as well as the back projected ones.
    [~,n]=size(correspondences); 
    x2=correspondences(3:4,:);
    x2(3,:)=1;
    P2=zeros(3,n);
    for i=1:n
        P2(:,i)=R*P1(:,i)+T;
    end
    x2_homo=zeros(3,n);
    x2_uncaliberate=zeros(3,n);
    for i=1:n
        x2_homo(:,i)=P2(:,i)/P2(3,i); % get the homogeneous coordinates of points P1 in camera 2 
        x2_uncaliberate(:,i)=K*x2_homo(:,i);
    end
    x2_repro=x2_uncaliberate;
    im=im2double(Image2);
    imshow(im); hold on;
    plot(x2_repro(1,:),x2_repro(2,:),'r*');
    plot(x2(1,:),x2(2,:),'g.');
    for i=1:n
        text(x2_repro(1,i),x2_repro(2,i),sprintf('%d',i),'Color','red');
        text(x2(1,i),x2(2,i),sprintf('%d',i),'Color','green');
    end
    error_mat=x2_repro(1:2,:)-x2(1:2,:);
    sum=0;
    for i=1:n
        sum=sum+(error_mat(1,i)^2+error_mat(2,i)^2)^0.5;
    end
    repro_error=sum/n;
end