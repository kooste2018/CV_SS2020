function [T1, R1, T2, R2, U, V] = TR_from_E(E)
    % This function calculates the possible values for T and R 
    % from the essential matrix
    [U,S,V]=svd(E);
    temp1=diag(ones(1,3));
    temp1(3,3)=1/det(U);
    U=U*temp1;
    temp2=diag(ones(1,3));
    temp2(3,3)=1/det(V');
    V=(temp2*V')';
    S=inv(temp1)*S*inv(temp2);
    Rz=[0,-1,0;
        1,0,0;
        0,0,1];
    R1=U*Rz'*V';
    T1dach=U*Rz*S*U';
    T1=[T1dach(3,2),T1dach(1,3),T1dach(2,1)]';
    Rz=[0,1,0;
        -1,0,0;
        0,0,1];
    R2=U*Rz'*V';
    T2dach=U*Rz*S*U';
    T2=[T2dach(3,2),T2dach(1,3),T2dach(2,1)]';
end