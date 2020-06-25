function [EF] = epa(correspondences, K)
    % Depending on whether a calibrating matrix 'K' is given,
    % this function calculates either the essential or the fundamental matrix
    % with the eight-point algorithm.
    co=correspondences;
    x1=co(1:2,:);
    x1=[x1;ones(1,size(co,2))];
    x2=co(3:4,:);
    x2=[x2;ones(1,size(co,2))];
    if nargin == 2
        for i=1:size(co,2)
            x1(:,i)=inv(K)*x1(:,i);
            x2(:,i)=inv(K)*x2(:,i);
        end
    end
    for i=1:size(co,2)
        a=kron(x1(:,i),x2(:,i));
        A(i,:)=a';
    end
    [U,S,V]=svd(A);
    
    %% Estimation of the matrices
    G=V(:,9);
    G=reshape(G,[3,3]);
    [u,s,v]=svd(G);
    if nargin==2
        s(3,3)=0;
        sigma=(s(1,1)+s(2,2))/2;
        s(1,1)=1;
        s(2,2)=1;
        EF=u*s*v';%E
    else
        s(3,3)=0;
        EF=u*s*v';%F
    end
end