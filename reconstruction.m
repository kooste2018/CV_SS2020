function [T, R, lambda, P1, camC1, camC2] = reconstruction(T1, T2, R1, R2, correspondences, K)
    %% Preparation
    T_cell={T1,T2,T1,T2};
    R_cell={R1,R1,R2,R2};
    co=correspondences;
    x1=co(1:2,:);
    x1=[x1;ones(1,size(co,2))];
    x2=co(3:4,:);
    x2=[x2;ones(1,size(co,2))];
    for i=1:size(co,2)
        x1(:,i)=inv(K)*x1(:,i);
        x2(:,i)=inv(K)*x2(:,i);
    end
    d=zeros(size(co,2),2);
    d_cell={d,d,d,d};
    
    %% Reconstruction
    [~,n]=size(correspondences);  % n is the number of correspondence pairs
    s=zeros(1,4);
    for i=1:4
        M1=zeros(n*3,n+1);
        M2=zeros(n*3,n+1);
        m=1;
        for j=1:3:3*n
            M1(j:j+2,m)=cross(x2(:,m),R_cell{i}*x1(:,m));%%2-3有，udach乘v等于u叉乘v
            M1(j:j+2,n+1)=cross(x2(:,m),T_cell{i});
            M2(j:j+2,m)=cross(x1(:,m),R_cell{i}'*x2(:,m));
            M2(j:j+2,n+1)=-cross(x1(:,m),R_cell{i}'*T_cell{i});
            m=m+1;
        end
        [~,~,v1]=svd(M1);
        [~,~,v2]=svd(M2);
        lambda1=v1(1:n,end)/v1(end);
        lambda2=v2(1:n,end)/v2(end);
        d_cell{i}=[lambda1 lambda2];
        d_mat=d_cell{i};
        s(i)=sum(d_mat(:)>0);
    end

    [~,index]=max(s(:));
    T=T_cell{index};
    R=R_cell{index};
    lambda=d_cell{index};
    
    %% Calculation and visualization of the 3D points and the cameras
    temp=[lambda(:,1)';lambda(:,1)';lambda(:,1)'];
    p1x1=temp.*x1;
    P1=p1x1;
    figure(1)
    scatter3(p1x1(1,:),p1x1(2,:),p1x1(3,:));
    for i=1:size(x1,2)
        text(p1x1(1,i),p1x1(2,i),p1x1(3,i),int2str(i));
    end
    
    camC1=[-0.2,0.2,0.2,-0.2;0.2,0.2,-0.2,-0.2;1,1,1,1];
    for i=1:4
        camC2(:,i)=inv(R)*(camC1(:,i)-T);%%no idea why 
    end
    
    figure(2)
    plot3(camC1(1,:),camC1(2,:),camC1(3,:),'Color','blue');
    fill3(camC1(1,:),camC1(2,:),camC1(3,:),'blue');
    text(mean(camC1(1,:)),mean(camC1(2,:)),mean(camC1(3,:)),'Cam1');
    hold on
    plot3(camC2(1,:),camC2(2,:),camC2(3,:),'Color','red');
    fill3(camC2(1,:),camC2(2,:),camC2(3,:),'red');
    text(mean(camC2(1,:)),mean(camC2(2,:)),mean(camC2(3,:)),'Cam2');
    hold on
    xlabel('X');
    ylabel('Y');
    zlabel('Z');
    grid on 
    campos([43,-22,-87]);
    camup([0,-1,0]);
end