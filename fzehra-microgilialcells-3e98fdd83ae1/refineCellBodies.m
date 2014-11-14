function Output=refineCellBodies(CellBodies2,Images2,coordinatesOfBox)

BoxedImMean=Images2.BoxedImMean;
BoxedImStd=Images2.BoxedImStd;

ImagePatches1 = squeeze(CellBodies2);
ImagePatches2 = squeeze(BoxedImMean);
ImagePatches3 = squeeze(BoxedImStd);


[r,c,x]=size(ImagePatches1);
Areas=[];
% Patches1=zeros(r,c,1,x);
% Patches2=zeros(r,c,1,x);
% Patches3=zeros(r,c,1,x);

coordinatesOfBox2=[];
repeat=0;

MA=[];
MI=[];
MAI=[];
for i=1:x
    P=zeros(r,c);
    I=ImagePatches1(:,:,i);
    I2=ImagePatches2(:,:,i);
    I3=ImagePatches3(:,:,i);
    
    if (sum(I(:))>0)
        repeat=repeat+1;
        %% normalise the mean projection of Image patches
        I2n=(I2-min(I2(:)))/(max(I2(:))-min(I2(:)));
        
        MeanInt= mean(I2n(:));
        
        
        CC = bwconncomp(I);
        STATS = regionprops(CC, 'area','PixelIdxList','MajorAxisLength','MinorAxisLength');
        Area=[STATS.Area];
        
        PixelIdxList={STATS.PixelIdxList};
        
        
        maxInd= find(Area==max(Area(:)));
        IID=PixelIdxList{maxInd};
        P(IID)=1;
        S = regionprops(P,'MajorAxisLength','MinorAxisLength');
        MajorAxisLength=S.MajorAxisLength;
        MinorAxisLength=S.MinorAxisLength;
        MajorAxisLength=MajorAxisLength;%/Area(maxInd);
        MinorAxisLength=MinorAxisLength;%/Area(maxInd);
        MA=[MA;MajorAxisLength];
        MI=[MI;MinorAxisLength];
        MAI=[MAI;MajorAxisLength/MinorAxisLength];
        
        Patches1(:,:,:,repeat)=P;
        %% gray_image
        Patches2(:,:,:,repeat)=I2;
        Patches3(:,:,:,repeat)=I3;
        %% coordinate of selected images
        coordinatesOfBox2=[coordinatesOfBox2;coordinatesOfBox(i,:)];
        
        %% Divide MaxArea by mean intensity
        Areas=[Areas;Area(maxInd)/MeanInt];
    end
    
end
MeanAreas=mean(Areas(:));
StdAreas=std(Areas(:));

MeanMA = mean(MA);
StdMA = std(MA);

MeanMI = mean(MI);
StdMI = std(MI);

MeanMAI =mean(MAI);
StdMAI=std(MAI);

Output.CellBody=Patches1;
Output.MeanIm=Patches2;
Output.StdIm=Patches3;

Output.coordinatesOfBox=coordinatesOfBox2;
Output.MeanAreas=MeanAreas;
Output.StdAreas=StdAreas;
Output.MA=MA;
Output.MI=MI;
Output.MeanMA=MeanMA;
Output.StdMI=StdMI;
Output.MeanMAI=MeanMAI;
Output.StdMAI=StdMAI;

