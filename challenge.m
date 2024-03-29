%% Computer Vision Challenge 2020 challenge.m
clear
clc
close all
%% Start timer here
tic
%% Generate Movie

%load default parameters, if gui has passed parameters already, this should not be executed.
% if exist('ir')==0 %pick one variable in config to check if workspace empty,one is enough
%   config;
% end

config;

while loop ~= 1
  % Get next image tensors
    [left,right,loop]=next(ir);
    
  % Generate binary mask
    if loop~=1
        mask=segmentation(left,right);
        frame=left(:,:,7:9);          
      % Render new frame
        result = im2uint8(render(frame,mask,bg,mode)); %double not work due to precision error, memory error and so on, so convert it to uint8
        movie{i}=result;  %save current processed image to movie cell array
        i=i+1;
    else
        frame=left(:,:,1:3);
        result = im2uint8(render(frame,mask,bg,mode));
        movie{i}=result;  % movie is a cell
    end
    if i==5000 %if movie is full, new image will overwrite from beginning  
        i=1;
        movie_flag=1;%if GUI set loop mode, movie will be full filled and totally exported.
    end 
    %%if gui loop set loop here 0
end

%% Stop timer here
%elapsed_time = 0;
toc %get runtime

%% Write Movie to Disk
if store
    VideoObj = VideoWriter(dst,'Motion JPEG AVI');  % VideoWriter is an object to write files, dst is file name, 'Motion JPEG AVI' is file type
    % create the video writer with 5 fps, the default value is 30
    VideoObj.FrameRate = 5;
    
    % open the video writer
    open(VideoObj);
    
    %clip movie, delete blank frames
    if movie_flag==0 %if movie is full, export all as video, if not, delete blank part 
        movie=movie(1:i);
    else 
        movie_flag=0;%reset it for next
    end
    
    % write the frames to the video
    for u=1:length(movie)     
     % convert the image to a frame
       frame = im2frame(movie{u});
       writeVideo(VideoObj, frame);
    end
    
    % close the writer object
    close(VideoObj);
end
