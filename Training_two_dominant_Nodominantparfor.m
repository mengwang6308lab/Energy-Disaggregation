clc; close all; clear all;  
% synthetic datasets 
%% parameters 

% load('D:\Revision_experiment\dataset\tl_1','Indus1_domi', 'I1domi_Indus1_gt', 'I1domi_Indus2_gt', 'I1domi_Solar_gt'); 
% load('D:\Revision_experiment\dataset\tl_2','Commer_domi',  'I2domi_Indus2_gt' ,'I2domi_Indus1_gt' ,'I2domi_Solar_gt'); 

load('D:\Revision_experiment\dataset\trainP50_1','Indus1_domi', 'I1domi_Indus1_gt', 'I1domi_Indus2_gt', 'I1domi_Solar_gt'); 
load('D:\Revision_experiment\dataset\trainP50_2','Commer_domi',  'I2domi_Indus2_gt' ,'I2domi_Indus1_gt' ,'I2domi_Solar_gt'); 
load('D:\Revision_experiment\dataset\trainP50_3','Solar_domi','Solardomi_Solar_gt' ,'Solardomi_Indus1_gt', 'Solardomi_Indus2_gt'); 

ratio = 0.5; % pure
iter_max = 15;  
thres = 0.9  ;  
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


% C_gt1=Solardomi_Indus1_gt;
% C_gt2=Solardomi_Indus2_gt;
% C_gt3=Solardomi_Solar_gt;

% Xtrain_C=Solar_domi;



%% initialization   
K1 =   hardThres( Xtrain_A, thres );  
K2 =  hardThres( Xtrain_B , thres );  
K3 =  (K1+K2)/2;

N1 = size(Xtrain_A, 2);  


% indd1 = [1,52,51,22];  
% indd2 = [9,13,25,50];%, 5  if ratio = 0.7, 

indd1 = [1,52,51,22];  
indd2 = [9,13,25,50];

indd3=[81 98]
indd4=[102 111]
indd3=[81 98]
indd4=[82 99]

% 
D1_ini=Xtrain_A(:, indd1); 
D2_ini=Xtrain_B(:, indd2); 
%D3_ini=abs(Xtrain_B(:, indd3));
D3_temp=[ (Xtrain_A(:, indd3)) (Xtrain_B(:, indd4))]

%D3_ini=D3_temp;
% 
for j=1:K3
 
D_max=max(D3_temp(:, j));
D_min=min(D3_temp(:, j));

if D_max<0||D_min>0
    
D3_ini(:,j)= abs(D3_temp(:, j));    
else if D_max>0 & D_min <0
      D3_ini(:,j)= max(-D3_temp(:, j),0); 
    end
end
 end

% start=tic;
% 
% D1=D1_ini;
% D2=D2_ini; 
% D3=D3_ini; 
% 
% D1  = normalize_dic(D1); 
% D2 = normalize_dic(D2);   
% D3 = normalize_dic(D3);  

%% solve the D1 and D2   
tune_num = 1  ; 
all_results = []; 

    
 %  lambdaA=  6.0000e-04;
 %  lambdaB=8.0000e-04;% 8.0000e-04 0.01 0.03
 %  lambdaC=0.01; 
 %  savename = 'Training_update_50';
paras =[];  
if ratio == 0.5
%    lambdaA=  1.5000e-03;
%    lambdaB=2.800e-03;% 8.0000e-04 0.01 0.03
%    lambdaC=0.01; 
%    lambdaA2=  9.0000e-04
%    lambdaB1= 3.0000e-04;
%    lambdaC1=0.02; 
%    lambdaC2= 0.01; 
    lambdaA2= 0.003;   %6.0000e-04 0.006
  
   lambdaB1= 8.0000e-04%0.001 0.002  6.0000e-04
 
   lambdaC1= 0.003
   lambdaC2= 0.003

   
%    lambdaA2=   7.0000e-04
%    lambdaB1=1.500e-04;
%    lambdaC1=0.01; 
%    lambdaC2= 0.01; 
   savename = 'Training_update_50';
        
elseif ratio == 0.7  
 lambdaA2= 0.00;   %6.0000e-04 0.006
  
   lambdaB1= .0000e-04%0.001 0.002  6.0000e-04
 
   lambdaC1= 0.00
   lambdaC2= 0.00		
 lambda22 = 0.0000; 		
 lambda33 = 1e-3 * 0.06;% 0.00004;  
 savename = 'Training_update_50';%'Training_nonnormaIS_reduced_50_best';%'Training_DominantI_50_1';
 lambda4 = 20;
elseif ratio == 0.3  
 lambda1 =  0.00000000000000; 
 lambda2 =    1e-3 * 0.03 ;% 0.0003; 
 lambda3 =    1e-3 *0.008 ;%  0.000008; 
 lambda11 =    1e-3 *0.1;%  0.0001 ; 
 lambda22 = 0.0000; 
 lambda33 =  1e-3 *0.6;%  0.0006;	 
 savename = 'Training_update_30';%'Training_nonnormaIS_reduced_30'; %'Training_DominantI_30_1';
 lambda4 = 1;
end  


  
 %parame=[ 0.0001:0.0001:0.001 0.002:0.001:0.01 0.02:0.01:0.1 0.2:0.1:1 1:1:10 10:10:100];
 parame=[ 10:10:100 200:100:1000 2000];
%parame= [0.0001:0.0001:0.001 0.002:0.001:0.01 0.02:0.01:0.1];
 %parame=0.0018; c10.009 0.007
 %parame=[0.000001:0.0001:0.0001 0.0001:0.0001:0.001 0.002:0.001:0.01 0.02];
% parame=[000]
 %parame=[40]
 %parame= [6500];0.0005     0.0006
 %parame=[00];
 %parame=6500;
 lam=00;
 
  Q1=ones([K1 K2]);
  Q2=ones([K1 K3]);
  Q3=ones([K2 K3]);
 
 Z1=zeros([K1 K1]); 
 Z2=zeros([K2 K2]);
 Z3=zeros([K3 K3]);

 M=[Z1 Q1 Q2;Q1' Z2 Q3 ;Q2' Q3' Z3];      
%  %C=8*diag(ones([1 16]));
L=M;

 %parame=0;
best_result1 = 1 ; 
best_result2 = 1 ; 
%D10 = D1; D20 = D2;  D30 = D3; 


% for i=1:10000
%  indd1=randperm(N1, K2);
%  indd2=randperm(N1, K1);
%  indd3=randperm(N1*2, K3);
% 
% D1_ini{i}=max(Xtrain_A(:, indd1),0); 
% D2_ini{i}=max(Xtrain_B(:, indd2),0); 
% Xtrain_C=[Xtrain_A, Xtrain_B];
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
% save 'D_ini_twolabel'  'D1_ini' 'D2_ini' 'D3_ini'
% 
%load('D_ini_twolabel' ,'D1_ini','D2_ini','D3_ini');
 thresS=2;
%for tune = 1:numel(parame)
%parfor iii=1:20
%parfor iii=1:numel(parame)
parame=[10:10:100 ]
parame=[0 100:100:800]
%parame=[0 0.1:0.2:1 2:2:10 ]


parame=[300]
 
for iii=1:numel(parame)
%lam=parame(iii)   
% lam=500;
% lambdaC=parame(tune);
  lam=parame(iii);
 % lam=100;
% lambdaC1=parame(tune);
 % lambdaB1=parame(iii);
 %lambdaA2=parame(tune);
 %lambdaB2=parame(tune);
 % lambdaA2=parame(iii);
 %lambdaC2=parame(iii);


% D1=D1_ini{2292};%2292 6969 487
% D2=D2_ini{2292}; 
% D3=D3_ini{2292}; 

D1=D1_ini;%2292 6969 487
D2=D2_ini; 
D3=D3_ini;

D1  = normalize_dic(D1); 
D2 = normalize_dic(D2);   
D3 = normalize_dic(D3);  

%  D1 = D10; D2 = D20;  D3 = D30; 
  
for iter = 1: iter_max
   [A1 A2 B1 B2 C1 C2]=colsparse_coeff_2label(Xtrain_A,Xtrain_B, D1,D2,D3,K1,K2,K3,N1,lambdaA2,lambdaB1,lambdaC1,lambdaC2)

%     cvx_begin 
%         variable D2(size(Xtrain_S, 1), K2) 
%         variable D1(size(Xtrain_I, 1), K1) 
%         minimize (  norm(Xtrain_S - D1 * A1 - D2*A2, 'fro') + norm(Xtrain_I - D1 * B1 - D2*B2, 'fro') ) ;
%         D1 >= 0;
%         D2 >= 0;
%     cvx_end   
  %  errc(iter)= norm(Xtrain_S - D1 * A1 - D2*A2, 'fro') + norm(Xtrain_I - D1 * B1 - D2*B2, 'fro') ;
     D=[D1 D2 D3];
     A=[A1 A2 ];
     B=[B1 B2 ]; 
     C=[C1 C2 ]; 
     Xtrain=[Xtrain_A Xtrain_B];
     Coeff=[A; B; C];
    [D, hist_obj] = Dictionary_update_one(Xtrain,Coeff,D,L,lam,1000);
    D1=D(:,1:K1);
    D2=D(:,K1+1:K1+K2);
    D3=D(:,K1+K2+1:K1+K2+K3);
   % errc(iter)= norm(Xtrain_S - D1 * A1 - D2*A2, 'fro') + norm(Xtrain_I - D1 * B1 - D2*B2, 'fro') ;
    D1 = normalize_dic(D1);  
    D2 = normalize_dic(D2);   
    D3= normalize_dic(D3);
%     [ter1  ] = TER({ XI0_S,  XS0_S}, { D1*A1,  D2*A2} ); 
%     [ter2  ] = TER({ XI0_I,  XS0_I}, { D1*B1,  D2*B2} );  
%     
    fprintf('Iterate %d \n', iter);   
end  

%timm=toc(start)
% lambda1 * sum(sum(abs(A1)))  + lambda2 * sum(sum(abs(A2 ))) + lambda11 * sum(sum(abs(B1)))  + lambda22 * sum(sum(abs(B2 )))
    [rmseA1 ] = RMSE(A_gt1, D1 * A1) ;
    [rmseA2 ] = RMSE(A_gt2, D2 * B1) ;
    [rmseA3 ] = RMSE(A_gt3, D3 * C1) ;
    
    
    
    [rmseB1] = RMSE(B_gt1, D1 * A2); 
    [rmseB2] = RMSE(B_gt2, D2 * B2);
    [rmseB3] = RMSE(B_gt3, D3 * C2); 

     
    [maeA1] = NRMSE(A_gt1, D1 * A1) ;
    [maeA2] = NRMSE(A_gt2, D2 * B1) ;
    [maeA3] = NRMSE(A_gt3, D3 * C1) ;
    
    [maeB1] = NRMSE(B_gt1, D1 * A2) ;
    [maeB2] = NRMSE(B_gt2, D2 * B2) ;
    [maeB3] = NRMSE(B_gt3, D3 * C2) ;
    

     
    [terA  ] = TER({ A_gt1, A_gt2,A_gt3}, { D1*A1,  D2*B1, D3*C1} ); 
    [terB  ] = TER({ B_gt1, B_gt2,B_gt3}, { D1*A2,  D2*B2, D3*C2} ); 
   % [terC  ] = TER({ C_gt1, C_gt2,C_gt3}, { D1*A3,  D2*B3, D3*C3} ); 
    %[ter2  ] = TER({ XI0_I,  XS0_I}, { D1*B1,  D2*B2} );  

%     all_resultA = [rmseA1  rmseA2 rmseA3 maeA1 maeA2 maeA3 terA ];
%     
%     all_resultB = [rmseB1  rmseB2 rmseB3 maeB1 maeB2 maeB3 terB ] 
%     
%   %  all_resultC = [rmseC1  rmseC2 rmseC3 maeC1 maeC2 maeC3 terC ] 
%    % all_result2 = [rmse11  rmse22  mae11 mae22 ter2  ] 
%    all_resultAA{tune}=all_resultA;
%    all_resultBB{tune}=all_resultB;
%   % all_resultCC{tune}=all_resultC;
%    
%    terrA(tune)=terA;
%    terrB(tune)=terB;
  % terrC(tune)=terC;
  
  [AA2,counterA2] =Check_ColSparsity(A2,thresS)
 
   
   [BB1,counterB1] =Check_ColSparsity(B1,thresS)
   
   
   [CC1,counterC1] =Check_ColSparsity(C1,thresS)
   [CC2,counterC2] =Check_ColSparsity(C2,thresS)
   
   normm(iii)=  norm([Xtrain_A Xtrain_B]- D1 * [A1 A2] - D2*[B1 B2]- D3*[C1 C2], 'fro')   +  lambdaA2 * sum(sum(norms(A2 ))) + lambdaB1 * sum(sum(norms(B1)))+  lambdaC1 * sum(sum(norms(C1)))+ lambdaC2 * sum(sum(norms(C2)))
                  
   recons(iii)= norm([Xtrain_A Xtrain_B]- D1 * [A1 A2] - D2*[B1 B2]- D3*[C1 C2], 'fro');
   counterAA2(iii)=counterA2;
 %  counterAA3(iii)=counterA3;
   
   counterBB1(iii)=counterB1;
 %  counterBB3(iii)=counterB3;
   
   counterCC1(iii)=counterC1;
   counterCC2(iii)=counterC2;
   
   terrA(iii)=terA;
   terrB(iii)=terB;
   terC(iii)=(terA+terB)/2
  % terrC(iii)=terC;
end

 
  save 'training_50_2label3loads' 'D1' 'D2' 'D3' 'A1' 'A2'   'B1'  'B2'  'C1' 'C2'
  
  all_resultA
 all_resultB
% all_resultC
% day = 1:20:size(Xtrain_A);
% est1_S=D1*A1;
% est2_S=D2*A2;
% for i = 1: numel(day)
%     d = day(i); 
%     figure; plot(Xtrain_S(:,d), '.-');
%     hold on; ; plot(XS0_S(:, d),'*-');
%      hold on; plot(est2_S(:, d),'<-'); 
%     xlabel( 'Time (5 minutes)' , 'FontSize', 15, 'Fontname', 'Times New Roman');
%     ylabel('Active Power (MW)'); 
%     legend( 'Agg', 'Solar' ,'Estimated'  ) 
%     xlim([1, size(Xtrain_S, 1)]) 
%     figure; plot(Xtrain_S(:,d),'.-'); 
%      hold on;plot(XI0_S(:, d), '*-');
%     hold on; plot(est1_S(:, d),'<-'); 
%     xlabel( 'Time (5 minutes)' , 'FontSize', 15, 'Fontname', 'Times New Roman');
%     ylabel('Active Power (MW)'); 
%     legend( 'Agg',   'Industrial' , 'estimated' ) ; xlim([1, size(Xtrain_S, 1)]);
% end
%  
% save savename; 487 2292

%save Training_nonnormaIS_best_50