function Cake = cake(min_dist)
    % The cake function creates a "cake matrix" that contains a circular set-up of zeros
    % and fills the rest of the matrix with ones. 
    % This function can be used to eliminate all potential features around a stronger feature
    % that don't meet the minimal distance to this respective feature.
    Cake=ones(2*min_dist+1);
    centre=[min_dist+1,min_dist+1];
    for i=1:2*min_dist+1
        for j=1:2*min_dist+1
            dis=sqrt((i-centre(1))^2+(j-centre(2))^2);
            if dis<=min_dist
                Cake(i,j)=0;
            end
        end
    end
    Cake=logical(Cake>0);  
end