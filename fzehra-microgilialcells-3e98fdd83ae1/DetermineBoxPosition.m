function Output= DetermineBoxPosition (BW,IRatedMean,boxWidth)

[nr,nc]=size(BW);
x=[];
y=[];
CC = bwconncomp(BW);
S = regionprops(CC,IRatedMean,'Area','PixelIdxList','centroid','WeightedCentroid');
Area=[S.Area];
[nelements,centers]=hist(Area(:),100);
limit=centers(1)*10;

centroids = cat(1, S.Centroid);
WeightedCentroid = cat(1, S.WeightedCentroid);

PixelIdxList={S.PixelIdxList};
% MeanIntensity=[S.MeanIntensity];
% figure, hist(MeanIntensity(:),100);

indAr=find(Area>=limit);
l=length(indAr); %% number of regions with bigger area values than the limit value
coordinatesOfBox=zeros(l,4);
CheckMultipleCells=zeros(nr,nc);


for iA=1:l
    i=indAr(iA);
   
        xx= WeightedCentroid(i,1);% centroids(i,1);
        yy= WeightedCentroid(i,2);%centroids(i,2);

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
      
        coordinatesOfBox(iA,:)=[newX1, newX2,newY1,newY2];
        %% check if there is another cell in that area
        CheckMultipleCells(newX1:newX2,newY1:newY2)=ones(boxWidth+1,boxWidth+1)+CheckMultipleCells(newX1:newX2,newY1:newY2);

end
CentroidOfCells=[x,y];
Output.CheckMultipleCells =CheckMultipleCells;
Output.coordinatesOfBox =coordinatesOfBox;
Output.CentroidOfCells =CentroidOfCells;

