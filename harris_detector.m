function features = harris_detector(input_image, varargin)
    % In this function you are going to implement a Harris detector that extracts features
    % from the input_image.

    %% Input parser
    p=inputParser;
    p.addParameter('segment_length',15,@(x) isnumeric(x) && (mod(x,2)==1) && (x>1));
    p.addParameter('k',0.05,@(x) isnumeric(x) && (0<=x) && (x<=1));
    p.addParameter('tau',10^6,@(x) isnumeric(x) && (0<x));
    p.addParameter('do_plot',false,@(x) islogical(x));
    p.addParameter('min_dist',20,@(x) isnumeric(x)&&(x>=1));
    p.addParameter('tile_size',[200,200],@(x) isnumeric(x)&&(size(x,1)==1)&&(size(x,2)<=2));
    p.addParameter('N',5,@(x) isnumeric(x)&&(x>=1));
    p.parse(varargin{:});
    segment_length=p.Results.segment_length;
    k=p.Results.k;
    tau=p.Results.tau;
    do_plot=p.Results.do_plot;
    min_dist=p.Results.min_dist;
    tile_size=p.Results.tile_size;
    N=p.Results.N;
    if isscalar(tile_size)
        tile_size=[tile_size, tile_size];
    end
    
    %% Preparation for feature extraction
    if size(input_image,3)==1
        % Check if it is a grayscale image
        input_image=double(input_image);
        % Approximation of the image gradient
        [Ix, Iy] = sobel_xy(input_image);
        % Weighting
        %%see gaussian filter vorlesung 1-2
        filter_sigma=segment_length/6;
        filter_x=[1:segment_length];
        filter_mittelwert=mean(filter_x);
        filter_x_norm=filter_x-filter_mittelwert*ones(size(filter_x));
        filter_c=1/sum(exp(-(filter_x_norm).^2/(2*filter_sigma^2)));
        filter_gx=filter_c*exp(-(filter_x_norm).^2/(2*filter_sigma^2));
        w=filter_gx;
        % Harris Matrix G sowie darstellung in G11,G12,G22
        G11=conv2(Ix.*Ix,w'*w,'same');
        G12=conv2(Ix.*Iy,w'*w,'same');
        G22=conv2(Iy.*Iy,w'*w,'same');    
    else
        error("Image format has to be NxMx1");
    end
    
    %% Feature extraction with the Harris measurement
    H=zeros(size(G11));
    size_H=size(H);
    G_pixel=zeros(2);
    for i=1:size_H(1)
        for j=1:size_H(2)
            G_pixel(1,1)=G11(i,j);
            G_pixel(2,2)=G22(i,j);
            G_pixel(1,2)=G12(i,j);
            G_pixel(2,1)=G12(i,j);
            H(i,j)=det(G_pixel)-k*(trace(G_pixel))^2;
        end
    end
    %eliminate corner
    corners=H;
    corners(find(corners)<tau)=0;
    %find remaining features coordinates
    [row,column]=find(corners~=0);
    features=[column';row'];
    
    %%plot if set
    if do_plot
        figure
        plot(features(1,:),features(2,:),'o');
    end
    
    %% Feature preparation
    corners=padarray(corners,[min_dist, min_dist],0,'both');
    
    %% Feature detection with minimal distance and maximal number of features per tile
    num_tile_hor_ceil=ceil(size(input_image,2)/tile_size(2));
    num_tile_ver_ceil=ceil(size(input_image,1)/tile_size(1));
    features=zeros(2,10000);
    cake_11=cake(min_dist);
    features_index=1;%predefine features for faster performance
    
    for i=1:num_tile_hor_ceil
        for j=1:num_tile_ver_ceil
            %reset corners_wo_border because of cake set 0
            corners_wo_border=corners(min_dist+1:end-min_dist,min_dist+1:end-min_dist);
            %close to border, dim changes, so decide tile region first
            %right border
            if i==num_tile_hor_ceil&&j~=num_tile_ver_ceil
                tile=corners_wo_border((j-1)*tile_size(1)+1:j*tile_size(1),(i-1)*tile_size(2)+1:end);
            end
            %down border
            if j==num_tile_ver_ceil&&i~=num_tile_hor_ceil
                tile=corners_wo_border((j-1)*tile_size(1)+1:end,(i-1)*tile_size(2)+1:i*tile_size(2));
            end
            %left down corner
            if j==num_tile_ver_ceil&&i==num_tile_hor_ceil
                tile=corners_wo_border((j-1)*tile_size(1)+1:end,(i-1)*tile_size(2)+1:end);
            end
            %normal
            if j~=num_tile_ver_ceil&&i~=num_tile_hor_ceil
                tile=corners_wo_border((j-1)*tile_size(1)+1:j*tile_size(1),(i-1)*tile_size(2)+1:i*tile_size(2));
            end
            %find max value,save coordinate to features and set 0 with cake
            n=0;
            while isempty(find(tile))~=1&n<=N-1
                [r,c,v]=find(tile);
                sort_temp=[r,c,v];%this is sub in tile, row_max is sub in corner wo border
                sort_temp=sortrows(sort_temp,3,'descend');
                %coordinate (x,y) based on corners wo border
                row_max=sort_temp(1,1)+(j-1)*tile_size(1);
                col_max=sort_temp(1,2)+(i-1)*tile_size(2);
                features(features_index)=[col_max;row_max];
                features_index=features_index+1;
                %set tile 0 with min_dist, use cake to set 0 in corners,to
                %influent corners_wo_border, and change the next tile.
                %both!!!!
                %if only set tile with min_dist,the dist may not be hold
                %over tile border 
                %transformation of coordination, 
                %tile co % to corners wo co %to corners co careful here
                %subscript not xy
                a=row_max+min_dist;%a and b is sub in corner with border min_dist, so plus min_dist
                b=col_max+min_dist;
                corners(a-min_dist:a+min_dist,b-min_dist:b+min_dist)=corners(a-min_dist:a+min_dist,b-min_dist:b+min_dist).*cake_11;
                %set tile 0 with min_dist, cake not required, for next
                %while loop
                for p=1:tile_size(1)
                    for q=1:tile_size(2)
                        distance=sqrt((p-sort_temp(1,1))^2+(q-sort_temp(1,2))^2);
                        if distance<=min_dist
                            tile(p,q)=0;
                        end
                    end
                end
                n=n+1;
            end
        end
    end
    features=features(1:features_index);%delete useless 0
end