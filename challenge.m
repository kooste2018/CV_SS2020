%% Computer Vision Challenge 2020 challenge.m
clear
clc
close all
%% Start timer here
tic

%% Generate Movie
config;

while loop ~= 1
  % Get next image tensors
    [left,right,loop]=next(ir);
  % Generate binary mask
    mask=segmentation(left,right);
  % Render new frame
    frame=left(:,:,1:3);
    result = render(frame,mask,bg,mode);
    movie(i)={result};
    i=i+1;
end

%% Stop timer here
%elapsed_time = 0;
toc

%% Write Movie to Disk
if store
    writerObj = VideoWriter(dst,'Motion JPEG AVI');
    % create the video writer with 1 fps
    writerObj.FrameRate = 1;
    % open the video writer
    open(writerObj);
    %clip movie, delete blank frames
    movie=movie(1:i);
    % write the frames to the video
    for u=1:length(movie)
     % convert the image to a frame
     frame = im2frame(movie{u});
     writeVideo(writerObj, frame);
    end
    % close the writer object
    close(writerObj);
end
