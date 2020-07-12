%% Computer Vision Challenge 2020 challenge.m
clear
clc
close all
%% Start timer here
tic
%% Generate Movie
%load default parameters, if gui has passed no parameters already, this should not be executed.
config;

while loop ~= 1
  % Get next image tensors
  [left,right,loop]=next(ir);
  if loop~=1%we ignore image 1,2 and rest image in the end, because seg not work for them
    % Generate binary mask
    mask=segmentation(left,right);
    frame=left(:,:,7:9);          
    % Render new frame
    result = im2uint8(render(frame,mask,bg,render_mode)); %double not work due to precision error, memory error and so on, so convert it to uint8
    movie{i}=result;  %save current processed image to movie cell array
    i=i+1;
  end
  if i==5000 %if movie is full, new image will overwrite from beginning  
    i=1;
    movie_flag=1;%if GUI set loop mode, movie will be full filled and totally exported.
  end 
end

%% Stop timer here
elapsed_time =toc; %get runtime

%% Write Movie to Disk
if store
    VideoObj = VideoWriter(dest,'Motion JPEG AVI');  % VideoWriter is an object to write files, dest is file name, 'Motion JPEG AVI' is file type
    % create the video writer with 5 fps, the default value is 30
    VideoObj.FrameRate = 15;
    
    % open the video writer
    open(VideoObj);
    
    %clip movie, delete blank frames
    if movie_flag==0 %if movie is full, export all as video, if not, delete blank part 
        movie=movie(1:i-1);
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
