function [correspondences_robust, largest_set_F] = F_ransac(correspondences, varargin)
    % This function implements the RANSAC algorithm to determine 
    % robust corresponding image points
    co=correspondences;
    x1=co(1:2,:);
    x1=[x1;ones(1,size(co,2))];
    x2=co(3:4,:);
    x2=[x2;ones(1,size(co,2))];
    x1_pixel=x1;
    x2_pixel=x2;

    input=inputParser;
    input.addParameter('epsilon',0.5,@(x) isnumeric(x) && (x>=0) && (x<=1));
    input.addParameter('p',0.5,@(x) isnumeric(x) && (x>=0) && (x<=1));
    input.addParameter('tolerance',0.01,@(x) isnumeric(x));
    input.parse(varargin{:}); 
    epsilon=input.Results.epsilon;
    p=input.Results.p;
    tolerance=input.Results.tolerance;

    %% RANSAC algorithm preparation
    k=8;
    s=log(1-p)/log(1-(1-epsilon)^k);
    largest_set_size=0;
    largest_set_dist=inf;
    largest_set_F=zeros(3);
    
    %% RANSAC algorithm
    for i=1:s
        co=correspondences(:,1:k);
        F = epa(co);
        dist= sampson_dist(F, x1_pixel, x2_pixel);
        currentset=correspondences(:,find(dist<tolerance));
        num=size(currentset,2)*2;
        dist_abs=sum(dist(find(dist<tolerance)));
        if num>largest_set_size
            largest_set_size=num;
            largest_set_F=F;
            correspondences_robust=currentset;
        end
        if num==largest_set_size&dist<largest_set_dist
            largest_set_size=num;
            largest_set_F=F;
            largest_set_dist=dist;
            correspondences_robust=currentset;
        end
    end
end