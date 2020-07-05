function [result] = render(frame,mask,bg,mode)
  % Add function description here
  %frame: current image to be used
  %mask: mask for sepearate face and background
  %bg: virtual background
  %mode: 4 modes,foreground: to set background black
  %              background: to set foreground black
  %              overlay: colored, transparent, overlayed
  %              substitute: set background as virtual bg

  fg_here(:,:,1:3)=frame(:,:,1:3).*mask;  %if mask is MxN, use it 3 times for RGB
  bg_here(:,:,1:3)=frame(:,:,1:3).*(abs(mask-1));
  bg_virtual(:,:,1:3)=bg(:,:,1:3).*(abs(mask-1));
  result=zeros(size(frame));
  
  switch mode
      case 'foreground'
          result=fg_here;%the rest is already 0, i.e. black
      case 'background'
          result=bg_here;
      case 'overlay'
          ph_overlay=zeros(size(frame));
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
          result=fg_here+bg_virtual;
      otherwise
          warning('Unexpected mode. Black image exported.')
  end
end