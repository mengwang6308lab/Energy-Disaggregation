function D = normalize_dic(D )



n = size(D,1); 
% D = D - repmat( mean(D),[n 1] );
% D(:,1) = 1; % enforce low pass
% Normalize
d = sqrt(sum(D.^2,1));
I = find(d<1e-9);  
D(:,I) = randn(size(D,1),length(I)); 
D = D./repmat(d, n, 1);

end
