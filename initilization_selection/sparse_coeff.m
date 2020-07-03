
function [A1 A2 A3 B1 B2 B3 C1 C2 C3]=sparse_coeff(Xtrain_A,Xtrain_B, Xtrain_C,D1,D2,D3,K1,K2,K3,N1,lambdaA,lambdaB,lambdaC)


    cvx_begin
        variable A1(K1, N1)
        variable A2(K1, N1) 
        variable A3(K1, N1) 
        variable B1(K2, N1)
        variable B2(K2, N1) 
        variable B3(K2, N1) 
        variable C1(K3, N1)
        variable C2(K3, N1) 
        variable C3(K3, N1) 
        
        minimize (  norm([Xtrain_A Xtrain_B Xtrain_C]- D1 * [A1 A2 A3] - D2*[B1 B2 B3]- D3*[C1 C2 C3], 'fro')   + ... 
       lambdaA * sum(sum(abs(A1 )))+lambdaA * sum(sum(abs(A2 )))+lambdaA * sum(sum(abs(A3 ))) + lambdaB * sum(sum(abs(B1)))+lambdaB * sum(sum(abs(B2)))+lambdaB * sum(sum(abs(B3))) +  lambdaC * sum(sum(abs(C1)))+ lambdaC * sum(sum(abs(C2)))+lambdaC * sum(sum(abs(C3)))   )
              A1 >= 0;
              A2 >= 0; 
              A3 >= 0;
              B1 >= 0; 
              B2 >= 0;
              B3 >= 0;
              C1 <= 0; 
              C2 <= 0; 
              C3 <= 0;
    cvx_end 
end