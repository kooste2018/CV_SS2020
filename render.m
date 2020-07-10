function [result] = render(frame,mask,bg,mode)
  % Add function description here
  %frame: current image to be used
  %mask: mask for sepearate face and background
  %bg: virtual background
  %mode: 4 modes,foreground: to set background black
  %              background: to set foreground black
  %              overlay: colored, transparent, overlayed
  %              substitute: set background as virtual bg

  fg_here(:,:,1:3)=frame(:,:,1:3).*mask; %apply mask to get foreground 
  bg_here(:,:,1:3)=frame(:,:,1:3).*(abs(mask-1)); %apply mask to get background 
  bg_virtual(:,:,1:3)=bg(:,:,1:3).*(abs(mask-1));%get virtual background from image
  result=zeros(size(frame));%predefine result 
  
  switch render_mode
      case 'foreground'
          result=fg_here;%the rest is already 0, i.e. black
      case 'background'
          result=bg_here;%the rest is already 0, i.e. black
      case 'overlay'
          ph_overlay=zeros(size(frame));%both will be showed, transparently colored
          [ind_0]=find(mask==0);
          [ind_1]=find(mask==1);
          rgb1=[0 0.7 0.9];  % the background is blue
          rgb2=[1 1 0];  % the foreground is yellow
          for i=1:3
              col=ph_overlay(:,:,i);
              col(ind_0)=frame(ind_0)*rgb1(i);
              col(ind_1)=frame(ind_1)*rgb2(i);
              ph_overlay(:,:,i)=col;
          end
          result=ph_overlay;
      case 'substitute'
          result=fg_here+bg_virtual;%apply virtual background 
      otherwise
          warning('Unexpected mode. Black image exported.')%error message
  end
end
