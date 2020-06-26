function H=fpa(correspondences)
    co=correspondences;
    x1=co(1:2,:);
    x1=[x1;ones(1,size(co,2))];
    x2=co(3:4,:);
    x2=[x2;ones(1,size(co,2))];
    for i=1:size(co,2)
        x2_dach=[0,-x2(3,i),x2(2,i);
                x2(3,i),0,-x2(1,i);
                -x2(2,i),x2(1,i),0];
        a=kron(x1(:,i),x2_dach);
        A(i,:)=a';
    end
    [U,S,V]=svd(A);
    HL=V(:,9);
    HL=reshape(HL,[3,3]);
    %durch sigma
    
    %weiter
    H1=H;
    H2=-H;
    %validate positive, see 4-2
    flag=1;
    i=1;
    while flag>0
        a=x2(:,i)'*H1*x1(:,i);
        b=x2(:,i)'*H2*x1(:,i);
        flag=a*b;
        i=i+1;
    end
    if a>0
        H=H1;
    else
        H=H2;
    end
end