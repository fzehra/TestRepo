function Ifinal=Thresholding2(Icells,threshold)
[nr,nc]=size(Icells);
centersMat=[];
Inew2=[];
numObjs=0;    
Inew=zeros(nr,nc);
Ifinal=zeros(nr,nc);
start1=0;
    
    InewTemp=zeros(nr,nc);
    for k=1:15
        IcellsTemp=Icells;
        cells= Icells>threshold;
        
        ind=find(cells==1);
        IcellsTemp(ind)=0;
       
        
 %% find out the iteration if there is only 2 object before becoming 1  


        InewTemp(ind)=1;
         InewTemp=imfill(InewTemp,'holes');
%          figure, imagesc(InewTemp)
        CC={};
        CC = bwconncomp(InewTemp);
        numObj=CC.NumObjects;
        numObjs=[numObjs;numObj];
        
        IcellsTemp=(IcellsTemp-min(IcellsTemp(:)))/(max(IcellsTemp(:))-min(IcellsTemp(:)));
           Inew= InewTemp;
           Icells=IcellsTemp;
           figure, subplot(1,2,1), imagesc(IcellsTemp)
           subplot(1,2,2), imagesc(Inew)
           
%         if (k==1)& numObj
%             start1=1;
%         
%         else
            
            
            
%              if (numObjs(k+1)<=1)
          
%            CC = bwconncomp(Inew);
%             STATS = regionprops(CC, 'Area','PixelIdxList');
%             Area=[STATS.Area];
%             indArea=find(Area==max(Area(:)));
%             PixelIdxList={STATS.PixelIdxList};
%             
%             Pil=PixelIdxList{indArea};
%             Ifinal(Pil)=1;
%             figure, imagesc(Ifinal);
%             break;
%            
%             
%        end
%             
%     
%         end
    end
        
        
        
%         if k>2
%     
%         difnumObjs(k)=numObjs(k)-numObjs(k+1);
%    
%        if difnumObjs(k)<=0 %% increase in the object number
%     
%            if  (numObjs(k+1)==1) & (difnumObjs(k)>=0)
%                
%                 CC = bwconncomp(Inew);
%             STATS = regionprops(CC, 'Area','PixelIdxList');
%             Area=[STATS.Area];
%             indArea=find(Area==max(Area(:)));
%             PixelIdxList={STATS.PixelIdxList};
%             
%             Pil=PixelIdxList{indArea};
%             Ifinal(Pil)=1;
% %             figure, imagesc(Ifinal);
%             break;
%            else
%                
%                 IcellsTemp=(IcellsTemp-min(IcellsTemp(:)))/(max(IcellsTemp(:))-min(IcellsTemp(:)));
%            Inew= InewTemp;
%            Icells=IcellsTemp;
%            
%            end
%            
%        else
%            
%            
% end
%         
%         
%        if (numObjs(k+1)>1)
%             figure, subplot(1,2,1), imagesc(IcellsTemp)
%              IcellsTemp=(IcellsTemp-min(IcellsTemp(:)))/(max(IcellsTemp(:))-min(IcellsTemp(:)));
%            Inew= InewTemp;
%            Icells=IcellsTemp;
%            subplot(1,2,2), imagesc(InewTemp)
% %             figure, imagesc(Inew);
% 
% 
%            
%        else
%        
%            CC = bwconncomp(Inew);
%             STATS = regionprops(CC, 'Area','PixelIdxList');
%             Area=[STATS.Area];
%             indArea=find(Area==max(Area(:)));
%             PixelIdxList={STATS.PixelIdxList};
%             
%             Pil=PixelIdxList{indArea};
%             Ifinal(Pil)=1;
% %             figure, imagesc(Ifinal);
%             break;
%            
%             
%        end
%         end
%             
%         end
%    
    