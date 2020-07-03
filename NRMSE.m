function [nrmse] = NRMSE(X_i, est_i)
nrmse =  norm(X_i - est_i, 'fro')   / norm(X_i, 'fro');
end

