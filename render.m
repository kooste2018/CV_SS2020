function [result] = render(frame,mask,bg,mode)
  % Add function description here
  %frame: current image to be used
  %mask: mask for sepearate face and background
  %bg: virtual background
  %mode: 4 modes,foreground: to set background black
  %              background: to set foreground black
  %              overlay: colored, transparent, overlayed
  %              substitute: set background as virtual bg
  
  mask2(find(mask==1))=0;%create mask2 for background separation
  mask2(find(mask==0))=1;
  fg_here(:,:,1)=frame(:,:,1).*mask;%if mask is MxN, use it 3 times for RGB
  fg_here(:,:,2)=frame(:,:,2).*mask;
  fg_here(:,:,3)=frame(:,:,3).*mask;
  bg_here(:,:,1)=frame(:,:,1).*mask2;
  bg_here(:,:,2)=frame(:,:,2).*mask2;
  bg_here(:,:,3)=frame(:,:,3).*mask2;
  bg_virtual(:,:,1)=bg(:,:,1).*mask2;
  bg_virtual(:,:,2)=bg(:,:,2).*mask2;
  bg_virtual(:,:,3)=bg(:,:,3).*mask2;
  result=zeros(size(frame));
  switch mode
      case 'foreground'
          result=fg_here;%the rest is already 0, i.e. black
      case 'background'
          result=bg_here;
      case 'overlay'
          %not sure here 
      case 'substitute'
          result=fg_here+bg_virtual;
      otherwise
          warning('Unexpected mode. Black image exported.')
  end
end
