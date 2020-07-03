function [ter] = TER(allX, allest  )  
% TER is Total-Error-Rate
ter = 0;  
dter  = 0;
for j = 1: size(allX, 2)
    Xj = allX{1, j};
    estj = allest{1, j}; 
   for i = 1: size(Xj, 2)  
     ter  = ter  + min(  sum(abs(Xj(:, i) - estj(: , i))), sum(abs(Xj(:, i))) ) ;
       dter  = dter  +  sum(abs(Xj(:, i))) ;
   end
end
ter = ter /dter ;
end