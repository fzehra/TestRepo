function [Tres,TMaz, Tscales]=FrangiMeadialnessAtAScale (I,scales,thresh)

switch nargin
    
    case 2
        thresh=0.90;
    case 1
      scales=[0.1 0.5 1 2 2.5 3.5 5 7 ];
       thresh=0.90;
end


[m,n]=size(I);
l=length(scales);
Tscales=zeros(m,n,l);

for i=1:l
   
    s=scales(i);
    h = (s^2)*fspecial('gaussian', 3*ceil(s), s);
    Ig=imfilter(I,h,'same'); 
   T=FrangisMedialness (Ig);
   Tscales(:,:,i)=T;

end

TMaz=max(Tscales,[],3);
Tres=(TMaz>thresh);
