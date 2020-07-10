%% Computer Vision Challenge 2020 config.m

%% Generall Settings
% Group number:
group_number = 35;

% Group members:
members = {'Jiangnan Huang', 'Zhiwei Lin','Nan Chen', 'Ivan Hartono'};

% Email-Address (from Moodle!):
mail = {'jiangnan.huang@tum.de', 'zhiwei.lin@tum.de','nan.chen@tum.de','hartono.ivan@tum.de'};


%% Setup Image Reader
% Specify Scene Folder
if ispc%if it's windows
    src = strcat(pwd,'\originalfiles\P1E_S1');
else
    if ismac||isunix%if it's mac or unix
        src = strcat(pwd,'/originalfiles/P1E_S1');
    else
        error("System not supported!\n");%error 
    end
end

% Select Cameras
L =1;%set index of folder, camera left and right
R =2;

% Choose a start point
start = randi(1000);%pick start index, randomly from 1 to 1000

% Choose the number of succseeding frames
N =4;%set number of following images

%get object
ir = ImageReader(src, L, R, start, N);%initialize object of class ImageReader

%set loop 
loop=0;

%% Output Settings
% Output Path
%check system
if ispc%system recognition again for path 
    dest = strcat(pwd,'\','output.avi');
else
    if ismac||isunix
        dest = strcat(pwd,'/','output.avi');
    else
        error("System not supported!\n");
    end
end

% Load Virtual Background
if ispc%all virtual background will be saved in bg folder, which is in the same directory of this config.m
    bgpath = strcat(pwd,'\bg\bg1.jpg');
else
    if ismac||isunix
        bgpath = strcat(pwd,'/bg/bg1.jpg');
    else
        error("System not supported!\n");
    end
end
bg = im2double(imread(bgpath));%get virtual background

% Select rendering mode
mode = "foreground";

% Create a movie array
movie=cell(1,5000);
movie_flag=0;%if movie is full, set flag 1

%index for movie, for loop later
i=1;

% Store Output?
store = true;
