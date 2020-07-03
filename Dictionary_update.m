function [D, hist_obj] = Dictionary_update(X1,A,D0,L,lambda,maxit)


% initialization
D = D0;
beta=0.1;
% set a constant step size
alpha_old = 0.000001;
epsilon=0.1;
hist_obj = 0.5*norm(X1-D*A,'fro')^2+lambda*trace(D*L*D');
hist_objtt=0.5*norm(X1-D*A,'fro')^2+lambda*trace(D*L*D');
for iter = 1:maxit
    
    % within each iteration, cycle through all coordinates
     %compute the gradient of the objective function
     grad = (X1-D*A)*(-A')+lambda*D*(L+L');
     Hessian = A*A'+lambda*(L+L');
     alpha=alpha_old;
     D_old=D;
     
     D = max(0, D-alpha*grad);
    
     D_new=D;
   
     while (1-epsilon)*sum(grad'.*(D_new'-D_old'))+0.5*sum((D_new'-D_old').*(Hessian*(D_new'-D_old'))) <=0
        alpha=alpha/beta;
        D = max(0, D_old-alpha*grad);
        D_new=D;
     end
     alpha=alpha*beta;
   
     while (1-epsilon)*sum(grad'.*(D_new'-D_old'))+0.5*sum((D_new'-D_old').*(Hessian*(D_new'-D_old'))) >0
    
        alpha=alpha*beta;
        D = max(0, D_old-alpha*grad);
        D_new=D;
     end
  
    alpha_old = alpha;
    D = max(0, D_old-alpha*grad);

    % compute the objective value after each iteration
    hist_obj = [hist_obj; 0.5*norm(X1-D*A,'fro')^2+lambda*trace(D*L*D')];
    
    if iter==1
       hist_objt=[hist_obj];
    else
    hist_objt=[hist_objt;hist_obj(iter)-hist_obj(iter-1)];
    end
    
    hist_objtt=[hist_objtt ; norm(grad,'fro')];
end

end


