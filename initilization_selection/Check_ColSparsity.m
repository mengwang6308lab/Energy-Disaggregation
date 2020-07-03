function [A,counter] =Check_ColSparsity(A1,thre)


A=abs(A1);
counter=0;

for i = 1:size(A,1)
    for j = 1:size(A,2)
        if A (i,j) <thre
            A(i,j)= 0;
        end
        
    end
    
end

for j=1:size(A,2)
   if(sum(A(:,j))==0)
        counter=counter+1;
    end 
end

end