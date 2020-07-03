clc; close all; clear all;  
% synthetic datasets 
%% parameters 

load('trainP50_1','Indus1_domi', 'I1domi_Indus1_gt', 'I1domi_Indus2_gt', 'I1domi_Solar_gt'); 
load('trainP50_2','Commer_domi',  'I2domi_Indus2_gt' ,'I2domi_Indus1_gt' ,'I2domi_Solar_gt'); 
load('trainP50_3','Solar_domi','Solardomi_Solar_gt' ,'Solardomi_Indus1_gt', 'Solardomi_Indus2_gt'); 

iter_max = 15;  
thres = 0.9 ;  
T_wind = 8*12;  


lambdaA=  0.00010;   %6.0000e-04 0.006

lambdaB= 0.00010;

lambdaC= 0.00010;

lam=0;

%set the threshold for dictionaries

thre1=2;
thre2=1;
recons_threshold=100;
   
   AA1thres1=thre1;
   AA1thres2=thre2;
   
   AA2thres1=thre1;
   AA2thres2=thre2;
  
   AA3thres1=thre1;
   AA3thres2=thre2;
   
   BB1thres1=thre1;
   BB1thres2=thre2;
   
   BB2thres1=thre1;
   BB2thres2=thre2;
   
   BB3thres1=thre1;
   BB3thres2=thre2;
   
   CC1thres1=thre1;
   CC1thres2=thre2;
   
   CC2thres1=thre1;
   CC2thres2=thre2;
   
   CC3thres1=thre1;
   CC3thres2=thre2;


%% training datasets 
Xtrain_A= Indus1_domi;

Xtrain_B=Commer_domi;

Xtrain_C=Solar_domi;



%% initialization   
K1 =   hardThres( Xtrain_A, thres );  
K2 =  hardThres( Xtrain_B , thres );  
K3 =  hardThres( Xtrain_C , thres );


N1 = size(Xtrain_A, 2);  


 
for i=1:500
 indd1=randperm(N1, K2);
 indd2=randperm(N1, K1);
 indd3=randperm(N1, K3);

D1_ini{i}=max(Xtrain_A(:, indd1),0); 
D2_ini{i}=max(Xtrain_B(:, indd2),0); 
 
 for j=1:K3
 
D_max=max(Xtrain_C(:, indd3(j)));
D_min=min(Xtrain_C(:, indd3(j)));

if D_max<0||D_min>0
    
D3_inii(:,j)= abs(Xtrain_C(:, indd3(j)));    
else if D_max>0 & D_min <0
      D3_inii(:,j)= max(-Xtrain_C(:, indd3(j)),0); 
    end
end
 end
D3_ini{i}=D3_inii;
    
end


  Q1=ones([K1 K2]);
  Q2=ones([K1 K3]);
  Q3=ones([K2 K3]);
  
 Z1=zeros([K1 K1]); 
 Z2=zeros([K2 K2]);
 Z3=zeros([K3 K3]);

 M=[Z1 Q1 Q2;Q1' Z2 Q3 ;Q2' Q3' Z3];  
 L=M;
 thresS=1;
%start=tic
parfor iii=1:1

D1=D1_ini{iii};
D2=D2_ini{iii}; 
D3=D3_ini{iii}; 

D1  = normalize_dic(D1); 
D2 = normalize_dic(D2);   
D3 = normalize_dic(D3);  


for iter=1:iter_max
  
 [A1 ,A2 ,A3 ,B1 ,B2 ,B3, C1, C2 ,C3]=sparse_coeff(Xtrain_A,Xtrain_B, Xtrain_C,D1,D2,D3,K1,K2,K3,N1,lambdaA,lambdaB,lambdaC)


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
end  
 
   [AA1,counterA1] =Check_Sparsity(A1,thresS)
   [AA2,counterA2] =Check_Sparsity(A2,thresS)
   [AA3,counterA3] =Check_Sparsity(A3,thresS)
   
   [BB1,counterB1] =Check_Sparsity(B1,thresS)
   [BB2,counterB2] =Check_Sparsity(B2,thresS)
   [BB3,counterB3] =Check_Sparsity(B3,thresS)
   
   [CC1,counterC1] =Check_Sparsity(C1,thresS)
   [CC2,counterC2] =Check_Sparsity(C2,thresS)
   [CC3,counterC3] =Check_Sparsity(C3,thresS)
   
        
   recons(iii)=norm([Xtrain_A Xtrain_B Xtrain_C]- D1 * [A1 A2 A3] - D2*[B1 B2 B3]- D3*[C1 C2 C3], 'fro');
   
   counterAA1(iii)=counterA1;
   counterAA2(iii)=counterA2;
   counterAA3(iii)=counterA3;
   
   counterBB1(iii)=counterB1;
   counterBB2(iii)=counterB2;
   counterBB3(iii)=counterB3;
   
   counterCC1(iii)=counterC1;
   counterCC2(iii)=counterC2;
   counterCC3(iii)=counterC3;
   
   DD1{iii}=D1;
   DD2{iii}=D2;
   DD3{iii}=D3;
   
   AA{iii}=A;
   BB{iii}=B;
   CC{iii}=C;
   

end



   
   AA1_index=find(counterAA1<AA1thres1& counterAA1>AA1thres2);
   AA2_index=find(counterAA2<AA2thres1& counterAA2>AA2thres2);
   AA3_index=find(counterAA3<AA3thres1& counterAA3>AA3thres2);
   
   AA_index1=intersect(AA2_index,AA3_index);
   AA_index2=intersect(AA1_index,AA3_index);
   AA_index=intersect(AA_index1,AA_index2);
  
   BB1_index=find(counterBB1<BB1thres1& counterBB1>BB1thres2);  
   BB2_index=find(counterBB2<BB2thres1& counterBB2>BB2thres2);  
   BB3_index=find(counterBB3<BB3thres1& counterBB3>BB3thres2); 
   
  
   BB_index1=intersect(BB1_index,BB3_index);
   BB_index2=intersect(BB2_index,BB3_index);
   BB_index=intersect(BB_index1,BB_index2);
   
   CC1_index=find(counterCC1<CC1thres1& counterCC1>CC1thres2);  
   CC2_index=find(counterCC2<CC2thres1& counterCC2>CC2thres2);  
   CC3_index=find(counterCC3<CC3thres1& counterCC3>CC3thres2);  
   
   CC_index1=intersect(CC1_index,CC2_index);
   CC_index2=intersect(CC2_index,CC3_index);
   CC_index=intersect(CC_index1,CC_index2);
   
   AB_index=intersect(AA_index,BB_index);
   BC_index=intersect(BB_index,CC_index);
   
   ABC_index=intersect(AB_index,BC_index);
   
   recons_index=find(recons<recons_threshold); 
   index_final=intersect(ABC_index,recons_index)
   
   recons_select=recons(index_final)
   
  
   %Select best training dictionaries and sparse coefficients
   D1_final=DD1{index_final};
   D2_final=DD2{index_final};
   D3_final=DD3{index_final};
   
   A_final=AA{index_final};
   B_final=BB{index_final};
   C_final=CC{index_final};


