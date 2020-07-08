classdef ImageReader
    properties  
        l%path of folder, camera left
        r%path of folder, camera right 
        start=0%0 means actually the fist image
        N=1%number of followers
        loop=0%loop flag
        allimage_left%struct, saving information of all images of folder camera left
        allimage_right%struct, saving information of all images of folder camera right
    end
    
    methods
        function ir = ImageReader(src, L, R, varargin)     
            if (L==R)
                error('L and R must be different!\n');
            else
            % Input Parser
            p=inputParser;
            p.addRequired('src');
            p.addRequired('L',@(x) isnumeric(x) && (x==1) || (x==2));
            p.addRequired('R',@(x) isnumeric(x) && (x==3) || (x==2));
            p.addOptional('start',ir.start,@(x) isnumeric(x));
            p.addOptional('N',ir.N, @(x) isnumeric(x));
            p.parse(src, L, R, varargin{:});
            % update properties of this object ir 
            %check path if something strange happens!
            %check system
            if ispc
                ir.l = strcat(src,'\',src(end-5:end),'_C',string(p.Results.L),'\'); 
                ir.r = strcat(src,'\',src(end-5:end),'_C',string(p.Results.R),'\');
            else
                if ismac||isunix
                    ir.l = strcat(src,'/',src(end-5:end),'_C',string(p.Results.L),'/'); 
                    ir.r = strcat(src,'/',src(end-5:end),'_C',string(p.Results.R),'/');
                else
                    error("System not supported!\n");
                end
            end
            ir.start = p.Results.start;
            ir.start=max(ir.start,1);%0 means index 1 by me, so set start min 1
            ir.N = p.Results.N;
            ir.allimage_left=dir(strcat(ir.l,"*.jpg"));%read all images for next()
            ir.allimage_right=dir(strcat(ir.r,"*.jpg"));
            end
        end

        function [left, right, loop] = next(ir)
            persistent index;%define and init persistent index, otherwise value lost
            if isempty(index)
                index=ir.start;
            end
            left = zeros(600,800,3*(ir.N+1));
            right = left;%initialize left and right for speeding up
            if index+ir.N<numel(ir.allimage_left)%if not reach the end
                for i=1:ir.N+1
                    left(:,:,3*i-2:3*i)=im2double(imread(strcat(ir.l,ir.allimage_left(index).name)));
                    right(:,:,3*i-2:3*i)=im2double(imread(strcat(ir.r,ir.allimage_right(index).name)));
                    index=index+1;%update index
                end
            else%reach the end, set loop, and set start to begin
                num_rest=numel(ir.allimage_left)-index+1;
                left = zeros(600,800,3*num_rest);%redefine dimension
                right = left;
                for i=1:num_rest%all rest image together, less than N+1
                    left(:,:,3*i-2:3*i)=im2double(imread(strcat(ir.l,ir.allimage_left(index).name)));
                    right(:,:,3*i-2:3*i)=im2double(imread(strcat(ir.r,ir.allimage_right(index).name)));
                    index=index+1;%update index
                end
                ir.loop=1;%set loop
                index=1;%reset to beginning
            end
            loop = ir.loop;%pass loop to output
        end
    end
end
