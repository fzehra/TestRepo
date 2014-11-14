function checker=checkMultipleBox(CheckMultipleCells,coordinatesOfBox)
nr=size(coordinatesOfBox,1); 
checker=zeros(nr,1);
for i=1:nr
    m=coordinatesOfBox(i,:); 
    m1=m(1);
    m2=m(2);
    m3=m(3);
    m4=m(4);
    
   Box= CheckMultipleCells(m1:m2, m3:m4); 
   if (sum(Box(:)>1)>0)
       % calculate the rate of overlapping
       ind=find(Box(:)>1);
       RateOfOverlapping=length(ind)/length(Box(:));
       
       if RateOfOverlapping<0.5
       checker(i)=1;
       else 
           checker(i)=0;
       end
       
   else
       checker(i)=1; %% there is no object at the same box
   end
    
end



