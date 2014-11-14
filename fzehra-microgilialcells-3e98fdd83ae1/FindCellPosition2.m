%% edited in 05.11.2014
%% intensity values are not used

function Output=FindCellPosition2(Images, boxWidth)
% names=fieldnames(Images);
% numberOfFields=numel(names);
BW=Images.BW;
IRatedMean=Images.IstdMean;
imMeanOrigi=  Images.IMean;
imStdOrigi=  Images.IStd;

OutputBox= DetermineBoxPosition (BW,IRatedMean,boxWidth);

CheckMultipleCells=OutputBox.CheckMultipleCells ;
coordinatesOfBox=OutputBox.coordinatesOfBox;
CentroidOfCells=OutputBox.CentroidOfCells ;


CentroidOfCells2=[];
NewMatrix={};
 checker=checkMultipleBox(CheckMultipleCells,coordinatesOfBox);
 repeat=0;
 for i=1:length(checker)
     if checker(i)
         repeat=repeat+1;
         m=coordinatesOfBox(i,:);
         matrix1=BW(m(1):m(2),m(3):m(4));
         matrix2= IRatedMean(m(1):m(2),m(3):m(4));
         matrix3= imMeanOrigi (m(1):m(2),m(3):m(4));
         matrix4= imStdOrigi (m(1):m(2),m(3):m(4));
         matrix = cat(3, matrix1, matrix2,matrix3,matrix4);
         
         NewMatrix{repeat}=matrix;
         CentroidOfCells2=[CentroidOfCells2; CentroidOfCells(i,:)];
          
     end
     
 end 
 
Output.NewMatrix=NewMatrix;
Output.CentroidOfCells=CentroidOfCells;
Output.coordinatesOfBox=coordinatesOfBox;


figure, imagesc(IRatedMean)
colormap(gray)
hold on
plot(CentroidOfCells2(:,1), CentroidOfCells2(:,2), 'b*')
hold off
% figure, imagesc(CheckMultipleCells>1)


