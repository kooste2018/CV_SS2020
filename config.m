%% Computer Vision Challenge 2020 config.m


%% Generall Settings
% Group number:
group_number = 35;

% Group members:
members = {'Jiangnan Huang', 'Zhiwei Liang','Nan Chen', 'Ivan Hartono'};

% Email-Address (from Moodle!):
mail = {'jiangnan.huang@tum.de', 'zhiwei.liang@tum.de','nan.chen@tum.de','hartono.ivan@tum.de'};

%% Setup Image Reader
% Specify Scene Folder
if ispc %if it's windows
    src = strcat(pwd,'\data\P1L_S1');  % pwd: identify current folder
else
    if ismac||isunix %if it's mac or unix
        src = strcat(pwd,'/data/P1L_S1');
    else
        error("System not supported!\n");
    end
end

% Select Cameras
L =2; %set index of folder, camera left and right
R =3; 

% Choose a start point
start = randi(1000);  % return randomly a value between 0 and 1000
start=1500;

% Choose the number of succseeding frames
N =4; %set number of following images

%get object
ir = ImageReader(src, L, R, start, N); %initialize object of class ImageReader

%set loop 
loop=0;

%% Output Settings
% Output Path
%check system
if ispc %system recognition again for path 
    dst = strcat(pwd,'\output.avi');
else
    if ismac||isunix
        dst = strcat(pwd,'/output.avi');
    else
        error("System not supported!\n");
    end
end

% Load Virtual Background
if ispc %all virtual background will be saved in bg folder, which is in the same directory of this config.m
    bgpath = strcat(pwd,'\bg\bg2.png');
else
    if ismac||isunix
        bgpath = strcat(pwd,'/bg/bg2.png');
    else
        error("System not supported!\n");
    end
end

bg = im2double(imread(bgpath));

bg=imresize(bg,[600,800]); % adapt the bg to the size of 600*800*3, since the original virtual background can be of random size
        
% Select rendering mode
mode = "substitute";

% Create a movie array
movie=cell(1,5000);
movie_flag=0; %if movie is full, set flag 1

%index for movie, for loop later
i=1;

% Store Output?
store = true;
