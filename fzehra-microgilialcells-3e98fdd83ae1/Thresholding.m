function Inew=Thresholding(Icells,threshold)
[nr,nc]=size(Icells);
centersMat=[];
    
    Inew=zeros(nr,nc);
    for k=1:15
        IcellsTemp=Icells;
        cells= Icells>threshold;
        
        ind=find(cells==1);
        IcellsTemp(ind)=0;
        
        
        IcellsTemp=(IcellsTemp-min(IcellsTemp(:)))/(max(IcellsTemp(:))-min(IcellsTemp(:)));
        [counts,centers]= hist(IcellsTemp(:),100);
        MaxCo= find(counts==max(counts(:)),1,'first');
        MaxCe=centers(MaxCo);
        centersMat=[centersMat;MaxCe];
        
        if (length(centersMat)>2)
            %      if (centersMat(end)-centersMat(end-1)<0)
            if ((centersMat(end)<0.7))
                Inew(ind)=1;
                Icells=IcellsTemp;
%                figure, subplot(1,3,1),imagesc(Icells), subplot(1,3,2), hist(Icells(:),100), subplot(1,3,3), imagesc(Inew)
            else
                break
                
            end
            
            
        end
    end
    