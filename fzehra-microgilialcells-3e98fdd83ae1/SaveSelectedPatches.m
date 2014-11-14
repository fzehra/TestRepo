function SaveSelectedPatches(Input,name,WholeImages,i) 
    

    CellBody=Input.CellBody;
    MeanIm=Input.MeanIm;
    StdIm=Input.StdIm;
    coordinatesOfBox= Input.coordinatesOfBox;
    
    imMeanOrigi= WholeImages.imMeanOrigi;
    imStdOrigi = WholeImages.imStdOrigi;
    imMeanStdOrigi=WholeImages.imMeanStdOrigi;
    
    
    Output.name=name;
    Output.WholeMeanImage=imMeanOrigi;
    Output.WholeStdImage=imStdOrigi;
    Output.WholeMeanStdImage=imMeanStdOrigi;
    Output.CellBodies=CellBody;
    Output.MeanImagePatches=MeanIm;
    Output.StdImagePatches=StdIm;
    
    ImPatch=Output;
    save (sprintf('ImagePatches %d',i), 'ImPatch')
    
    