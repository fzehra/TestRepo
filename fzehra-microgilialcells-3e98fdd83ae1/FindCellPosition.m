%% edited in 05.11.2014
%% intensity values are not used

function [NewMatrix,PositionOfCentroid,Im2,BoundingBox]=FindCellPosition(BW,IRatedMean,boxWidth)
[nr,nc]=size(BW);
Im2=zeros(nr,nc);
CC = bwconncomp(BW);
S = regionprops(CC, 'Area','PixelIdxList','centroid');
Area=[S.Area];
[nelements,centers]=hist(Area(:),100);
limit=centers(1)*10;

centroids = cat(1, S.Centroid);

PixelIdxList={S.PixelIdxList};

%%
TPP=zeros(nr,nc);
BoundingBox={};
l=length(Area);
x=[];
y=[];


NewMatrix={};
repeat=0;


for i=1:l
    if (Area(i)>=limit)
        xx= centroids(i,1);
        yy= centroids(i,2);
        x=[x;xx];
        y=[y;yy];
        
        Pil=[];
       
        Pil=  PixelIdxList{i};
        
        Im2(Pil)=1;
        
        ll=numel(Pil);
        rr=[];
        cc=[];
        for j=1:ll
            [r c]= ind2sub([nr,nc],Pil(j));
            rr=[rr;r];
            cc=[cc;c];
        end
        
        r1=min(rr);
        r2=max(rr);
        c1=min(cc);
        c2=max(cc);
           repeat=repeat+1;
      
      BoundingBox{repeat}=[r1 c1 r2  c2]; %% used to save image patches
%       BoundingBox{i}=[r1 c1 r2-r1  c2-c1];
        %%
        %   BB= BoundingBox{i};
        X=r1;% round(BB(1));
        Y=c1;%round(BB(2));
        Xwidth=c2-c1;%BB(4);
        Ywidth=r2-r1;%BB(3);
        
        
        a1= floor((boxWidth-Xwidth)/2);
        b1= floor((boxWidth-Ywidth)/2);
        newX1=X-a1;
        newY1=Y-b1;
        
        
        
        if (newX1<1)
            newX1=1;
        end
        newX2=newX1+boxWidth;
        
        
        if ( newY1<1)
            newY1=1;
        end
        newY2=newY1+boxWidth;
        
        if (newX2>nr)
            newX2=nr;
            newX1=nr-boxWidth;
        end
        if (newY2>nc)
            newY2=nc;
            newY1=nc-boxWidth;
        end
        matrix1=  BW(newX1:newX2,newY1:newY2); % better than imMean2
        %        matrix2=zeros(boxWidth+1,boxWidth+1);
        %         matrix3=zeros(boxWidth+1,boxWidth+1);
        matrix2= IRatedMean(newX1:newX2,newY1:newY2);
%         matrix3= Im(newX1:newX2,newY1:newY2)*10000; %Im3 % to show clearly, multiplied by 10000
        matrix = cat(3, matrix1, matrix2);
        %        matrix = cat(3, matrix1, matrix2);
       
        NewMatrix{repeat}=matrix;
 
    end
end

PositionOfCentroid=[x,y];
% figure, imagesc(IRatedMean)
% colormap(gray)
% hold on
% plot(x, y, 'b*')
% hold off

% figure, imshow(double(Im2).*imMeanOrigi,[]);
%  figure, imshow(ZeroImage)
