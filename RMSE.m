function [rmse] = RMSE(X_i, est_i)
rmse = sqrt(norm(X_i - est_i, 'fro')^2  / prod(size(X_i)));
end

