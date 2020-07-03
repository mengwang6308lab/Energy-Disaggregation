
function [A,ave_sparse] =Check_Sparsity(A1,thre)

count=0;
counter=zeros(1,120);
A=abs(A1);
for i = 1:size(A,1)
    for j = 1:size(A,2)
        if A (i,j) <thre
            A(i,j)= 0;
        end
        
    end
end
 
NN=size(A,2);
for j = 1:size(A,2)
    count=0;
    for i = 1:size(A,1)
        if A (i,j) ==0
            count=count+1;
            counter(j)=count;
        end
        
    end
    ave_sparse=sum(counter)/NN;
end

end