clc; close all; clear all;  
%You should install cvx in matlab to run this code
%load different datasets with different partial labels. Here we show one
%case when gamma=70%
load('D:\Revision_experiment\dataset\trainP70_1','Indus1_domi', 'I1domi_Indus1_gt', 'I1domi_Indus2_gt', 'I1domi_Solar_gt'); 
load('D:\Revision_experiment\dataset\trainP70_2','Commer_domi',  'I2domi_Indus2_gt' ,'I2domi_Indus1_gt' ,'I2domi_Solar_gt'); 
load('D:\Revision_experiment\dataset\trainP70_3','Solar_domi','Solardomi_Solar_gt' ,'Solardomi_Indus1_gt', 'Solardomi_Indus2_gt'); 


iter_max = 15;  
thres = 0.9 ;  
T_wind = 8*12;  


%% training datasets 
Xtrain_A= Indus1_domi;

A_gt1=I1domi_Indus1_gt;
A_gt2=I1domi_Indus2_gt;
A_gt3=I1domi_Solar_gt;

Xtrain_B=Commer_domi;

B_gt1=I2domi_Indus1_gt;
B_gt2=I2domi_Indus2_gt;
B_gt3=I2domi_Solar_gt;


C_gt1=Solardomi_Indus1_gt;
C_gt2=Solardomi_Indus2_gt;
C_gt3=Solardomi_Solar_gt;

Xtrain_C=Solar_domi;

%% initialization determine the rank   
K1 =   hardThres( Xtrain_A, thres );  
K2 =  hardThres( Xtrain_B , thres );  
K3 =  hardThres( Xtrain_C , thres );

N1 = size(Xtrain_A, 2);  

%randomly select some patterns from the training datasets
indd1=[randi([1,  N1], [1, K1]) ]; 
indd2=[randi([1,  N1], [1, K2]) ]; 
indd3=[randi([1,  N1], [1, K3]) ]; 

D1_ini=max(Xtrain_A(:, indd1),0); 
D2_ini=max(Xtrain_B(:, indd2),0); 
 
 for j=1:K3
 
D_max=max(Xtrain_C(:, indd3(j)));
D_min=min(Xtrain_C(:, indd3(j)));

if D_max<0||D_min>0
    
D3_ini(:,j)= abs(Xtrain_C(:, indd3(j)));    
else if D_max>0 & D_min <0
      D3_ini(:,j)= max(-Xtrain_C(:, indd3(j)),0); 
    end
end
end


D1=D1_ini;
D2=D2_ini; 
D3=D3_ini; 

D1 = normalize_dic(D1); 
D2 = normalize_dic(D2);   
D3 = normalize_dic(D3);  

%%hyper parameter for sparsity 

lambdaA= 1.0000e-04;   %tune parameters to let corresponding matrix column sparse
lambdaB= 1.0000e-04;
lambdaC= 1.0000e-04


lam=0; %incoherence term hyper parameters; for conventional dictionary learning method, lam is set as 0;

%Define the weight matrix for incoherence term 
Q1=ones([K1 K2]);
Q2=ones([K1 K3]);
Q3=ones([K2 K3]);
  
Z1=zeros([K1 K1]); 
Z2=zeros([K2 K2]);
Z3=zeros([K3 K3]);

L=[Z1 Q1 Q2;Q1' Z2 Q3 ;Q2' Q3' Z3];      

%training start
for iter = 1: iter_max
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
             lambdaA * sum(sum(abs(A1 )))+lambdaA* sum(sum(abs(A2 )))+lambdaA * sum(sum(abs(A3 ))) + lambdaB * sum(sum(abs(B1)))+lambdaB* sum(sum(abs(B2)))+lambdaB * sum(sum(abs(B3))) +  lambdaC * sum(sum(abs(C1)))+ lambdaC * sum(sum(abs(C2)))+lambdaC * sum(sum(abs(C3)))  )
              A1 >= 0;
              A2 >= 0; 
              A3 >= 0;
              B1 >= 0; 
              B2 >= 0 ;
              B3 >= 0;
              C1 <= 0; 
              C2 <= 0; 
              C3 <= 0;
    cvx_end 

     D=[D1 D2 D3];
     A=[A1 A2  A3];
     B=[B1 B2  B3]; 
     C=[C1 C2  C3]; 
     Xtrain=[Xtrain_A Xtrain_B Xtrain_C];
     Coeff=[A; B; C];
    [D, hist_obj] = Dictionary_update(Xtrain,Coeff,D,L,lam,1000);
    D1=D(:,1:K1);
    D2=D(:,K1+1:K1+K2);
    D3=D(:,K1+K2+1:K1+K2+K3);
  
    D1 = normalize_dic(D1);  
    D2 = normalize_dic(D2);   
    D3= normalize_dic(D3);
    fprintf('Iterate %d \n', iter);   
end  


%If you have the ground truth data, you can check the error with the
%following matrices
    [rmseA1 ] = RMSE(A_gt1, D1 * A1) ;
    [rmseA2 ] = RMSE(A_gt2, D2 * B1) ;
    [rmseA3 ] = RMSE(A_gt3, D3 * C1) ;
    
    
    
    [rmseB1] = RMSE(B_gt1, D1 * A2); 
    [rmseB2] = RMSE(B_gt2, D2 * B2);
    [rmseB3] = RMSE(B_gt3, D3 * C2); 
     
    [rmseC1] = RMSE(C_gt1, D1 * A3); 
    [rmseC2] = RMSE(C_gt2, D2 * B3);
    [rmseC3] = RMSE(C_gt3, D3 * C3); 
     
    [maeA1] = NRMSE(A_gt1, D1 * A1) ;
    [maeA2] = NRMSE(A_gt2, D2 * B1) ;
    [maeA3] = NRMSE(A_gt3, D3 * C1) ;
    
    [maeB1] = NRMSE(B_gt1, D1 * A2) ;
    [maeB2] = NRMSE(B_gt2, D2 * B2) ;
    [maeB3] = NRMSE(B_gt3, D3 * C2) ;
    
    [maeC1] = NRMSE(C_gt1, D1 * A3) ;
    [maeC2] = NRMSE(C_gt2, D2 * B3) ;
    [maeC3] = NRMSE(C_gt3, D3 * C3) ;
     
    [terA  ] = TER({ A_gt1, A_gt2,A_gt3}, { D1*A1,  D2*B1, D3*C1} ); 
    [terB  ] = TER({ B_gt1, B_gt2,B_gt3}, { D1*A2,  D2*B2, D3*C2} ); 
    [terC  ] = TER({ C_gt1, C_gt2,C_gt3}, { D1*A3,  D2*B3, D3*C3} ); 

    all_resultA = [rmseA1  rmseA2 rmseA3 maeA1 maeA2 maeA3 terA ];
    
    all_resultB = [rmseB1  rmseB2 rmseB3 maeB1 maeB2 maeB3 terB ]; 
    
    all_resultC = [rmseC1  rmseC2 rmseC3 maeC1 maeC2 maeC3 terC ]; 

 
 save 'trainingDL' 'D1' 'D2' 'D3' 'A1' 'A2' 'A3'  'B1'  'B2' 'B3' 'C1' 'C2' 'C3'
