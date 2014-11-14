%% created in 05.11.2014
%% detect cell bodies by statistic
close all
clear all
clc

Ims=dir('*.tif');
names={Ims.name};
boxWidth=60;
i=1;
CC={};
NewMatrixes={};
MatrixMeanAreas=zeros(numel(Ims),1);
MatrixStdAreas=zeros(numel(Ims),1);
MatrixMeanMA= zeros(numel(Ims),1);
MatrixStdMA = zeros(numel(Ims),1);
MatrixMeanMI= zeros(numel(Ims),1);
MatrixStdMI = zeros(numel(Ims),1);
MatrixMeanMAI=zeros(numel(Ims),1);
MatrixStdMAI=zeros(numel(Ims),1);
for i=1%:numel(Ims)
    [nr,nc]=size(imread(names{i}));
    imOriginal=[];
    
    for j=1:11
        imOriginal(:,:,j)=double(imread(names{i},j));
    end
    
   
    
  
    imMeanOrigi=mean(imOriginal,3);
    imStdOrigi=std(imOriginal,0,3);
    
      %% enhanced  mean image with subtracted background
      %% change negative places with minimum  intensity values
      
      imMeanOrigi=EnhanceBackground(imMeanOrigi);
   
      imStdOrigi=EnhanceBackground(imStdOrigi);
      
    
     figure, subplot(2,4,1), imagesc(imMeanOrigi), title('imMeanOrigi')
    
    
  
   subplot(2,4,2), imagesc(imStdOrigi), title('imStdOrigi')
  
    
    
    Portion=(imStdOrigi-min(imStdOrigi(:)))/(max(imStdOrigi(:))-min(imStdOrigi(:)));
%     IRatedMean=double(imMeanOrigi.*Portion);
     IRatedMean31=double(imMeanOrigi.*Portion);
      subplot(2,4,3), imagesc(IRatedMean31), title('imMeanOrigi*Portion')
    
    %% remove background
%     sigma=40;%25
%     IRatedMean21=imfilter(IRatedMean,fspecial('gaussian',[240 240],sigma)); %110 110
%     IRatedMean31=IRatedMean-IRatedMean21;
    %% focus on cells
    sigma=10;%10
    IRatedMean22=imfilter(IRatedMean31,fspecial('gaussian',[60 60],sigma)); %110 110
    
    IRatedMean32=IRatedMean31-IRatedMean22;
    
      subplot(2,4,4), imagesc(IRatedMean32),  title(' focus on cell bodies')
    
    Icells=IRatedMean31.*IRatedMean22;
     subplot(2,4,5) ,imagesc(Icells), title(' focus on cell bodies 2')
    
    Icells=(Icells-min(Icells(:)))/(max(Icells(:))-min(Icells(:)));
    
     subplot(2,4,6) ,imagesc(Icells), title(' normalised cell bodies')
    subplot(2,4,7),  hist(Icells(:),100);
    [counts,centers]=hist(Icells(:),100) ;
    MaxCo= find(counts==max(counts(:)));
    MaxCe=centers(MaxCo);
    barLeng=1/100;
    thresh=MaxCe+ barLeng/2;
    
    
    %% Thresholding 
    threshold=0.7; %0.7
    Inew=Thresholding(Icells,threshold);
  subplot(2,4,8), imagesc(Inew); title('thresholded cell bodies')
    
    %%
    %   figure, imagesc(Inew)
    Inew=imfill(Inew,'holes');
    
%     Inew3=IRatedMean.*Inew;
    Inew3=IRatedMean32.*Inew;
    % subplot(1,2,2), imagesc(Inew3);
    Images.BW=Inew;
%     Images.IstdMean=IRatedMean;
    Images.IstdMean=IRatedMean32;
    Images.IMean=imMeanOrigi;
     Images.IStd=imStdOrigi;
     
    
    Output=FindCellPosition2(Images,boxWidth);
    NewMatrix=Output.NewMatrix;
    CentroidOfCells=Output.CentroidOfCells;
    coordinatesOfBox=Output.coordinatesOfBox;
    
    numOfObjects=numel(NewMatrix);
    
    BoxedImStdMean=zeros(boxWidth+1,boxWidth+1,1,numOfObjects);
    BoxedImMean=zeros(boxWidth+1,boxWidth+1,1,numOfObjects);
    CellBodies=zeros(boxWidth+1,boxWidth+1,1,numOfObjects);
    BoxedIm2=zeros(boxWidth+1,boxWidth+1,1,numOfObjects);
    
    
    for j=1:numOfObjects
        
        n=NewMatrix{j};
        CellBodies(:,:,:,j)=n(:,:,1);
        BoxedImStdMean(:,:,:,j)=n(:,:,2);
        BoxedImMean (:,:,:,j)=n(:,:,3);
        BoxedImStd(:,:,:,j)=n(:,:,4);
       %% normalisation in each frame to apply  'disk' filter
        kn=n(:,:,3);
        BoxedIm2 (:,:,:,j)= (kn-min(kn(:)))/(max(kn(:))-min(kn(:)));
        
    end
    
    H = fspecial('disk',4);
    CellBodies2 = imfilter(BoxedIm2,H,'same')>0.4; % 0.4 is used
    
    CellBodies3=(CellBodies2.*BoxedImMean); %entropyfilt
    Images2.BoxedImMean=BoxedImMean;
    Images2.BoxedImStd=BoxedImStd;
    
    
    Output2=refineCellBodies(CellBodies2,Images2,coordinatesOfBox);
    Patches1=Output2.CellBody;
    Patches2=Output2.MeanIm;
    Patches3=Output2.StdIm;
    coordinatesOfBox2= Output2.coordinatesOfBox;
    
    WholeImages.imMeanOrigi=imMeanOrigi;
    WholeImages.imStdOrigi=imStdOrigi;
    WholeImages.imMeanStdOrigi=IRatedMean32;
    
    SaveSelectedPatches(Output2,names{i},WholeImages,i); 
    
%    figure, hist(CellBodies2(:),100)

%     
%     figure, subplot (2,3,1),montage(BoxedImStdMean,'DisplayRange',[]);
%     title('Image Patches in Std*Mean Image')
%           subplot (2,3,2),montage(BoxedImMean,'DisplayRange',[]);
%     title('Image Patches in Mean Image')
%     subplot (2,3,3), montage(BoxedIm2,'DisplayRange',[]);
%     title('Normalised Image Patches in Mean Image')
%     subplot (2,3,4),montage(CellBodies,'DisplayRange',[]);
%     title('Cell Bodies after threshold')
%    
%      subplot (2,3,5), montage(CellBodies2,'DisplayRange',[]);
%     title('Cell Bodies after disk filtering')
%   
%    subplot (2,3,6), montage(CellBodies3,'DisplayRange',[]);
%     title('Cell Bodies after disk filtering * mean Image ')
%     
  
%     figure, subplot (1,3,1),montage(Patches1,'DisplayRange',[]);
%     title('Refined Cell Bodies')
%      subplot (1,3,2),montage(Patches2,'DisplayRange',[]);
%     title('Selected Image Patches in Mean Image')
%      subplot (1,3,3),montage(Patches3,'DisplayRange',[]);
%     title('Selected Image Patches in Std Image')
%     
%    
%     
    
%     MatrixMeanAreas (i)= MeanAreas;
%     MatrixStdAreas (i)= StdAreas;
%     
%     
%      MatrixMeanMA(i)= MeanMA;
%     MatrixStdMA (i)= StdMA;
%     
%      MatrixMeanMI (i)= MeanMI;
%     MatrixStdMI (i)= StdMI;
%     
%     MatrixMeanMAI(i)=MeanMAI;
%     MatrixStdMAI(i)=StdMAI;
    
    
%     figure, subplot(1,2,1),plot(MA,'*'); 
%     subplot(1,2,2),plot(MI,'*'); 
    
    
end
% x=1:i;
% % 
% figure, subplot(2,1,1), plot(x,MatrixMeanAreas,'*'); title('MeanArea')
% subplot(2,1,2), plot(x,MatrixStdAreas,'*');title('STD Area')
% 
% figure, 
% subplot(2,3,1), plot(x,MatrixMeanMA,'*'),title('Mean Major Axis'), 
% subplot(2,3,2), plot(x,MatrixMeanMI,'*'), title('Mean Minor Axis'), 
% subplot(2,3,3), plot(x,MatrixMeanMAI,'*'),title('Mean Major Axis/ Minor Axis '), 
% 
% subplot(2,3,4), plot(x,MatrixStdMA,'*'),title('STD Major Axis'), 
% subplot(2,3,5), plot(x,MatrixStdMI,'*'), title('STD Minor Axis'), 
% subplot(2,3,6), plot(x,MatrixStdMAI,'*'), title('STD Major Axis/ Minor Axis'), 

