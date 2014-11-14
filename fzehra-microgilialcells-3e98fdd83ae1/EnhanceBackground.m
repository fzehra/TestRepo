function imMeanOrigi=EnhanceBackground(imMeanOrigi)
 
     sigma=40;%25
    imMeanOrigiS=imfilter(imMeanOrigi,fspecial('gaussian',[240 240],sigma)); %110 110
    imMeanOrigi=imMeanOrigi-imMeanOrigiS;
    imMeanOrigiMin=min(abs(imMeanOrigi(:)));
    
    I0=imMeanOrigi>0;
    I00=(1-I0).*imMeanOrigiMin; 
    I0=I0.*imMeanOrigi;
    imMeanOrigi=I00+I0;