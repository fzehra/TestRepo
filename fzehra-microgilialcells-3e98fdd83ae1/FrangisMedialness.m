%% calculate medialness values  for a scale
%% edited in 05.11.2014
%% Beta and C should be adjusted according to image 
%% Beta=0.5;  C=100; default values

function T=FrangisMedialness (I,Param)

switch nargin
    
    case 2
        Beta=Param(1);
        C=Param(2);
    case 1
       Beta=0.5;  
       C=100;      
end



[s1,s2]=size(I);
[Gx,Gy]=imgradientxy(I);

[Gxx, Gxy] = imgradientxy(Gx); %(uNew/abs(uNew));
[Gyx, Gyy] = imgradientxy (Gy); %(vNew/abs(vNew));

Gyx=Gxy;

% Beta=0.5;  %% In the literature, its value =0.5 . i used 1
% C=100;    %% In the literature, its value = 100 i used 50
eigVectors={};
for i=1:s1
    for k=1:s2
        A=[Gxx(i,k),Gxy(i,k);Gyx(i,k), Gyy(i,k)];
%        lambdaArray= eig(A);  
       [eigVector,unn]= eig(A);
       lambdaArray=diag(unn);
       
      [lambda,ind]=sort(abs(lambdaArray),'ascend');
    indis=(i-1)*s1+k;
    
%     eigVectors{indis}=[eigVector, lambdaArray];
      
      if ((ind(1)==1)&((ind(2)==2)))
          lambda=lambdaArray;
        % eigVectors{indis}=eigVector;
      else lambda=flipud(lambdaArray);
          % eigVectors{indis}=fliplr(eigVector);
      end
      
   
   
       if (lambda(2)<0)
           Rb=abs((lambda(1))/(lambda(2)));
          S=(lambda(1)^2+lambda(2)^2);
%      T(i,k)= abs(Rb);

       T(i,k)=(exp(-(Rb^2)/(2*(Beta^2))))*(1-exp(-S/(2*(C^2))));
      else
           T(i,k)=0;
    
      end
     
      
    end
end

