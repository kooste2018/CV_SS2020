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
src = 'C:\master\learning materials\CV\challenge\originalfiles\P1E_S1\';

% Select Cameras
L =1;
R =2;

% Choose a start point
start = randi(1000);
start=291;

% Choose the number of succseeding frames
N =2;

%get object
ir = ImageReader(src, L, R, start, N);

%set loop 
loop=0;

%% Output Settings
% Output Path
dst = "C:\master\learning materials\CV\challenge\output.avi";

% Load Virual Background
bg = im2double(imread("C:\master\learning materials\CV\challenge\bg1.jpg"));

% Select rendering mode
mode = "substitute";

% Create a movie array
movie=cell(1,5000);

%index for movie, for loop later
i=1;

% Store Output?
store = true;
