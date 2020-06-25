function cor = point_correspondence(I1, I2, Ftp1, Ftp2, varargin)
    % In this function you are going to compare the extracted features of a stereo recording
    % with NCC to determine corresponding image points.
    
    %% Input parser
    p=inputParser;
    p.addParameter('window_length',25,@(x) isnumeric(x) && (mod(x,2)==1) && (x>1));
    p.addParameter('min_corr',0.95,@(x) isnumeric(x)&&(0<=x)&&(x<=1));
    p.addParameter('do_plot',false,@(x) islogical(x));
    p.parse(varargin{:});  
    window_length=p.Results.window_length;
    min_corr=p.Results.min_corr;
    do_plot=p.Results.do_plot;
    Im1=double(I1);
    Im2=double(I2);
    
    %% Feature preparation
    dist_max=(window_length-1)/2;
    temp=zeros(2,0);
    for i=1:max(size(Ftp1))
        ver=Ftp1(2,i);
        hor=Ftp1(1,i);
        ver_max=size(I1,1);
        hor_max=size(I1,2);
        if (ver+dist_max<=ver_max)&&(hor+dist_max<=hor_max)&&(ver-dist_max>=1)&&(hor-dist_max>=1)
            temp=[temp,Ftp1(:,i)];
        end
    end
    Ftp1=temp;

    temp=zeros(2,0);
    for i=1:max(size(Ftp2))
        ver=Ftp2(2,i);
        hor=Ftp2(1,i);
        ver_max=size(I2,1);
        hor_max=size(I2,2);
        if (ver+dist_max<=ver_max)&&(hor+dist_max<=hor_max)&&(ver-dist_max>=1)&&(hor-dist_max>=1)
            temp=[temp,Ftp2(:,i)];
        end
    end
    Ftp2=temp;
    no_pts1=size(Ftp1,2);
    no_pts2=size(Ftp2,2);
    
    %% Normalization
    dist=(window_length-1)/2;
    for i=1:max(size(Ftp1))
        ver=Ftp1(2,i);
        hor=Ftp1(1,i);
        window=Im1(ver-dist:ver+dist,hor-dist:hor+dist);
        window=(window-mean(window(:)))/std(window(:));
        Mat_feat_1(:,i)=window(:);
    end
    for i=1:max(size(Ftp2))
        ver=Ftp2(2,i);
        hor=Ftp2(1,i);
        window=Im2(ver-dist:ver+dist,hor-dist:hor+dist);
        window=(window-mean(window(:)))/std(window(:));
        Mat_feat_2(:,i)=window(:);
    end    
    
    %% NCC calculations
    N=size(Mat_feat_1,1);
    for i=1:size(Mat_feat_1,2)
        for j=1:size(Mat_feat_2,2)
            window1=reshape(Mat_feat_1(:,i),[window_length,window_length]);
            window2=reshape(Mat_feat_2(:,j),[window_length,window_length]);
            NCC_matrix(j,i)=trace(window1'*window2)/(N-1);
        end
    end
    NCC_matrix(find(NCC_matrix<min_corr))=0;
    temp=[NCC_matrix(:),(1:size(NCC_matrix(:),1))'];
    temp=temp(find(temp(:,1)>0),:);   
    temp=sortrows(temp,1,'descend');
    sorted_index=temp(:,2);
    
    %% Correspondeces
    %take highest NCC points, set colomn to 0 and calculate NCC and index again till all 0 in NCC
    cor=zeros(4,0);
    while size(find(NCC_matrix),1)~=0
        %index current
        temp=[NCC_matrix(:),(1:size(NCC_matrix(:),1))'];
        temp=temp(find(temp(:,1)>0),:);   
        temp=sortrows(temp,1,'descend');%%default direction ascend
        sorted_index=temp(:,2);
        index_current=sorted_index(1);
        %find points in 2 image
        po_ver=mod(index_current,size(NCC_matrix,1));
        po_hor=(index_current-po_ver)/size(NCC_matrix,1)+1;
        index_point1=po_ver;
        index_point2=po_hor;
        %save their coordinates in each image
        x1=Ftp1(1,index_point2);
        y1=Ftp1(2,index_point2);
        x2=Ftp2(1,index_point1);
        y2=Ftp2(2,index_point1);
        cor_current=[x1;y1;x2;y2];
        cor=[cor,cor_current];
        %new NCC calculate, set 0
        NCC_matrix(:,po_hor)=0;
    end
    
    %% Visualize the correspoinding image point pairs
    if do_plot
        result=I1+0.5*I2;
        result(find(result>255))=255;
        imshow(result);
        hold on
        plot(cor(1,:),cor(2,:),'Marker','o','Color','red');
        hold on 
        plot(cor(3,:),cor(4,:),'Marker','*','Color','blue');
    end
end