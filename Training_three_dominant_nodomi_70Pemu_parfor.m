clc; close all; clear all;  
% synthetic datasets 
%% parameters 

load('D:\Revision_experiment\dataset\trainP70_1','Indus1_domi', 'I1domi_Indus1_gt', 'I1domi_Indus2_gt', 'I1domi_Solar_gt'); 
load('D:\Revision_experiment\dataset\trainP70_2','Commer_domi',  'I2domi_Indus2_gt' ,'I2domi_Indus1_gt' ,'I2domi_Solar_gt'); 
load('D:\Revision_experiment\dataset\trainP70_3','Solar_domi','Solardomi_Solar_gt' ,'Solardomi_Indus1_gt', 'Solardomi_Indus2_gt'); 

ratio = 0.5; % pure
iter_max = 6;  
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



%% initialization   
K1 =   hardThres( Xtrain_A, thres );  
K2 =  hardThres( Xtrain_B , thres );  
K3 =  hardThres( Xtrain_C , thres );



N1 = size(Xtrain_A, 2);  
% 

indd1 = [1,52,81];  
indd2 = [9,13,95,100]
indd3=[62,46,57,83]


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



% indd1=[randi([1,  36], [1, 3]) randi([37,  120], [1, 1])]; 
% indd2=[randi([1,  36], [1, 3]) randi([37,  120], [1, 1])]; 
% indd3=[randi([1,  36], [1, 4]) randi([37,  120], [1, 0])]; 

% indd1 = [1,52,51,22];  
% indd2 = [9,13,25,50];
% indd3=[44    55    29    19  11];

% for i=1:500
%  indd1=randperm(N1, K2);
%  indd2=randperm(N1, K1);
%  indd3=randperm(N1, K3);
% 
% D1_ini{i}=max(Xtrain_A(:, indd1),0); 
% D2_ini{i}=max(Xtrain_B(:, indd2),0); 
%  
%  for j=1:K3
%  
% D_max=max(Xtrain_C(:, indd3(j)));
% D_min=min(Xtrain_C(:, indd3(j)));
% 
% if D_max<0||D_min>0
%     
% D3_inii(:,j)= abs(Xtrain_C(:, indd3(j)));    
% else if D_max>0 & D_min <0
%       D3_inii(:,j)= max(-Xtrain_C(:, indd3(j)),0); 
%     end
% end
%  end
% D3_ini{i}=D3_inii;
%     
% end
% save 'D_ini50'  'D1_ini' 'D2_ini' 'D3_ini'

%load('D_ini70' ,'D1_ini','D2_ini','D3_ini');
indd1
indd2
indd3
% 


% lambdaA2= 0.003;   %6.0000e-04 0.006
% lambdaA3= 0.003;
% lambdaB1=  1.0000e-03%0.001 0.002  6.0000e-04
% lambdaB3=  1.0000e-03
% lambdaC1=   0.002;
% lambdaC2=   0.002;
    lambdaA2= 5.0000e-04;   %6.0000e-04 0.006
   lambdaA3= 5.0000e-04;
   lambdaB1= 8.0000e-04%0.001 0.002  6.0000e-04
   lambdaB3=8.0000e-04
   lambdaC1= 5.0000e-04
   lambdaC2=  5.0000e-04

 lam=0;

  Q1=ones([K1 K2]);
  Q2=ones([K1 K3]);
  Q3=ones([K2 K3]);
  
 Z1=zeros([K1 K1]); 
 Z2=zeros([K2 K2]);
 Z3=zeros([K3 K3]);

 M=[Z1 Q1 Q2;Q1' Z2 Q3 ;Q2' Q3' Z3];  
 L=M;
 thresS=2;
%start=tic
%parame=[100];
parame=[10:10:100 200:200:1000]
parame=[0 200:200:2000]
parame= [9000 ];
for iii=1:1

%  D1=D1_ini{36};%34 35 36
%  D2=D2_ini{36}; 
%  D3=D3_ini{36}; 
D1=D1_ini;%34 35 36
D2=D2_ini; 
D3=D3_ini; 

D1  = normalize_dic(D1); 
D2 = normalize_dic(D2);   
D3 = normalize_dic(D3);  


%  parame= [0 0.00002:0.00001:0.0001 0.0002:0.0001:0.001 0.002:0.001:0.01];
  
 
%  parame=[300]
% parame=000;


D10 = D1; D20 = D2;  D30 = D3; 
%for tune = 1:numel(parame)

 
% lambdaC=parame(tune);
 lam=parame(iii);
 %lam=0;
 %lam=0;
%  lambdaC1=parame(tune);
%  lambdaC2=parame(tune);
%   lambdaB1=parame(tune)
%   lambdaB3=parame(tune);
 D1 = D10; D2 = D20;  D3 = D30; 
%   
%     lambdaC1=parame(tune)
%   lambdaC2=parame(tune);
%    lambdaA2=parame(tune);
%    lambdaA3=parame(tune);
for iter=1:iter_max
  
    [A1 ,A2 ,A3 ,B1 ,B2 ,B3, C1, C2 ,C3]=colsparse_coeff(Xtrain_A,Xtrain_B, Xtrain_C,D1,D2,D3,K1,K2,K3,N1,lambdaA2,lambdaA3,lambdaB1,lambdaB3,lambdaC1,lambdaC2)

     D=[D1 D2 D3];
     A=[A1 A2  A3];
     B=[B1 B2  B3]; 
     C=[C1 C2  C3]; 
     
     Xtrain=[Xtrain_A Xtrain_B Xtrain_C];
     Coeff=[A; B; C];
    [D, hist_obj] = Dictionary_update_one(Xtrain,Coeff,D,L,lam,1000);
    D1=D(:,1:K1);
    D2=D(:,K1+1:K1+K2);
    D3=D(:,K1+K2+1:K1+K2+K3);
   % errc(iter)= norm(Xtrain_S - D1 * A1 - D2*A2, 'fro') + norm(Xtrain_I - D1 * B1 - D2*B2, 'fro') ;
    D1 = normalize_dic(D1);  
    D2 = normalize_dic(D2);   
    D3= normalize_dic(D3);
    
%     [mu_min1,mu_max1,mu_ave1]=mu_incoherence(D1,D2)
%     [mu_min2,mu_max2,mu_ave2]=mu_incoherence(D2,D3)
%     [mu_min3,mu_max3,mu_ave3]=mu_incoherence(D1,D3)
%     
%     mu_min11(iter)=mu_min1;
%     mu_min22(iter)=mu_min2;
%     mu_min33(iter)=mu_min3;
%     
%      mu_max11(iter)=mu_max1;
%     mu_max22(iter)=mu_max2;
%     mu_max33(iter)=mu_max3;
%     
%     
%     mu_ave11(iter)=mu_ave1;
%     mu_ave22(iter)=mu_ave2;
%     mu_ave33(iter)=mu_ave3;
    
end  
%timm=toc(start);
% lambda1 * sum(sum(abs(A1)))  + lambda2 * sum(sum(abs(A2 ))) + lambda11 * sum(sum(abs(B1)))  + lambda22 * sum(sum(abs(B2 )))
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
    %[ter2  ] = TER({ XI0_I,  XS0_I}, { D1*B1,  D2*B2} );  

%     all_resultA = [rmseA1  rmseA2 rmseA3 maeA1 maeA2 maeA3 terA ];
%     
%     all_resultB = [rmseB1  rmseB2 rmseB3 maeB1 maeB2 maeB3 terB ]; 
%     
%     all_resultC = [rmseC1  rmseC2 rmseC3 maeC1 maeC2 maeC3 terC ]; 
%    % all_result2 = [rmse11  rmse22  mae11 mae22 ter2  ] 
%    all_resultAA{iii}=all_resultA;
%    all_resultBB{iii}=all_resultB;
%    all_resultCC{iii}=all_resultC;
   
   [AA2,counterA2] =Check_ColSparsity(A2,thresS)
   [AA3,counterA3] =Check_ColSparsity(A3,thresS)
   
   [BB1,counterB1] =Check_ColSparsity(B1,thresS)
   
   [BB3,counterB3] =Check_ColSparsity(B3,thresS)
   
   [CC1,counterC1] =Check_ColSparsity(C1,thresS)
   [CC2,counterC2] =Check_ColSparsity(C2,thresS)
   
   normm(iii)=norm([Xtrain_A Xtrain_B Xtrain_C]- D1 * [A1 A2 A3] - D2*[B1 B2 B3]- D3*[C1 C2 C3], 'fro')   + ... 
              lambdaA2 * sum(sum(norms(A2 )))+lambdaA3 * sum(sum(norms(A3 ))) + lambdaB1 * sum(sum(norms(B1)))+lambdaB3 * sum(sum(norms(B3))) +  lambdaC1 * sum(sum(norms(C1)))+ lambdaC2 * sum(sum(norms(C2))) ;
          
   recons(iii)=norm([Xtrain_A Xtrain_B Xtrain_C]- D1 * [A1 A2 A3] - D2*[B1 B2 B3]- D3*[C1 C2 C3], 'fro');
   counterAA2(iii)=counterA2;
   counterAA3(iii)=counterA3;
   
   counterBB1(iii)=counterB1;
   counterBB3(iii)=counterB3;
   
   counterCC1(iii)=counterC1;
   counterCC2(iii)=counterC2;
   
   terrA(iii)=terA;
   terrB(iii)=terB;
   terrC(iii)=terC;
end
  terALL=(terrA+terrB+terrC)/3
%  all_resultA
%  all_resultB
%  all_resultC

save 'train70_parforr'  'D1' 'D2' 'D3' 'A1' 'A2' 'A3'  'B1'  'B2' 'B3'  'C1' 'C2' 'C3'



%save Training_nonnormaIS_best_30