function [ rank ] = hardThres( Xbar, thres )
% determine the rank 
% rank of data 
[u,s,v] = svd(Xbar);
sum_s = 0; 
s = diag(s);
for p = 1:min(size(Xbar))
    if sum_s < thres
        sum_s = sum(s(1:p))/(sum(s));
    else
        rank = p; % r1 = 10; r2 = 8; r_train = 9; 
        break;
    end
end
end

