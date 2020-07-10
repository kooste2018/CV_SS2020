classdef ImageReader
    properties  
        l  %path of folder, camera left
        r  %path of folder, camera right 
        start=0  %0 means actually the fist image
        N=1  %number of followers
        loop=0  %loop flag
        allimage_left  %struct, saving information of all images of folder camera left
        allimage_right  %struct, saving information of all images of folder camera right
    end

    methods
        function ir = ImageReader(src, L, R, varargin)  % function with same name, to get parameters and update properties   
            if (L==R)  %check if the same folder
                error('L and R must be different!\n');
            else
            % Input Parser
            p=inputParser;
            p.addRequired('src');  %these 3 are required parameter 
            p.addRequired('L',@(x) isnumeric(x) && (x==1) || (x==2));
            p.addRequired('R',@(x) isnumeric(x) && (x==3) || (x==2));
            p.addOptional('start',ir.start,@(x) isnumeric(x)); %these 2 are optional, we have default value for them
            p.addOptional('N',ir.N, @(x) isnumeric(x));
            p.parse(src, L, R, varargin{:});
            
            % update properties of this object ir 
            % check path if something strange happens!
            %check system, update full path correctly
            if ispc  % judge if code can run on Windows platform
                ir.l = strcat(src,'\',src(end-5:end),'_C',string(p.Results.L));  % Concatenate strings horizontally
                ir.r = strcat(src,'\',src(end-5:end),'_C',string(p.Results.R));
            else
                if ismac||isunix  %if it's mac or unix, they have same path syntax 
                    ir.l = strcat(src,'/',src(end-5:end),'_C',string(p.Results.L)); 
                    ir.r = strcat(src,'/',src(end-5:end),'_C',string(p.Results.R));
                else
                    error("System not supported!\n"); %error message
                end
            end
            ir.start = p.Results.start; %index of starting image
            ir.start=max(ir.start,1); %0 means index 1 by me, so set start min 1
            ir.N = p.Results.N; %number of following images
            ir.allimage_left=dir(fullfile(ir.l,'*.jpg')); %read all images for next()
            ir.allimage_right=dir(fullfile(ir.r,'*.jpg'));
            end
        end


        function [left, right, loop] = next(ir) %function to read image further and further
            persistent index; %define and initialize persistent index of images, otherwise value lost after calling 
            if isempty(index)
                index=ir.start; %start from ir.start 
            end
            left = zeros(600,800,3*(ir.N+1));
            right = left;  %initialize left and right for speeding up
            if index+ir.N<=numel(ir.allimage_left)  %if not reach the end. numel:count the number of elements
                for i=1:ir.N+1
                    left(:,:,3*i-2:3*i)=im2double(imread(strcat(ir.l,'/',ir.allimage_left(index).name)));
                    right(:,:,3*i-2:3*i)=im2double(imread(strcat(ir.r,'/',ir.allimage_right(index).name)));
                    index=index+1; %update index for next image
                end
            else  %reach the end, set loop, and set start to begin
                num_rest=numel(ir.allimage_left)-index+1;
                left = zeros(600,800,3*num_rest);  %redefine dimension because there are less than N+1 images left
                right = left;
                for i=1:num_rest %pack all rest image together and pass it to left and right
                    left(:,:,3*i-2:3*i)=im2double(imread(strcat(ir.l,'/',ir.allimage_left(index).name)));
                    right(:,:,3*i-2:3*i)=im2double(imread(strcat(ir.r,'/',ir.allimage_right(index).name)));
                    index=index+1;%update index
                end
                ir.loop=1;  %set loop 1 to escape the while loop in challenge
                index=1;  %reset to beginning for next call of this function
            end
            loop = ir.loop; %pass loop to output
        end
    end
end
