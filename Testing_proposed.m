clc; close all; clear all; 
%load the testing dataset
load('testP70_1','TIndus1_domi', 'TI1domi_Indus1_gt', 'TI1domi_Indus2_gt', 'TI1domi_Solar_gt'); 
load('testP70_2','TCommer_domi',  'TI2domi_Indus2_gt' ,'TI2domi_Indus1_gt' ,'TI2domi_Solar_gt'); 
load('testP70_3','TSolar_domi','TSolardomi_Solar_gt' ,'TSolardomi_Indus1_gt', 'TSolardomi_Indus2_gt'); 
%load the trained dictionary and sparse coefficient
load('training_70', 'D1', 'D2','D3' ,'A1', 'B1', 'C1','A2', 'B2', 'C2','A3', 'B3', 'C3' );

%load the ground truth data
A_gt1=[TI1domi_Indus1_gt TI2domi_Indus1_gt TSolardomi_Indus1_gt] ;
A_gt2=[TI1domi_Indus2_gt TI2domi_Indus2_gt TSolardomi_Indus2_gt];
A_gt3=[TI1domi_Solar_gt TI2domi_Solar_gt TSolardomi_Solar_gt];

lambda =1;%hyper parameter

%% testing datasets
Xtest=[TIndus1_domi TCommer_domi TSolar_domi];
N2 = size(Xtest, 2);   

A=[A1 A2 A3];
B=[B1 B2 B3];
C=[C1 C2 C3];
ind=randi([1,  N2], [1, 12]); %down sampling the original coefficient matrix
% Disaggregate 
K1 = size(A1, 1); K2 = size(B1, 1);  K3 = size(C1, 1); 

N1 = size(A1, 2); 

Abar1 = A(:, ind);%down sampling the original coefficient matrix
Abar2 = B(:, ind);%down sampling the original coefficient matrix
Abar3 = C(:, ind);%down sampling the original coefficient matrix


D = [D1 D2 D3]; 

cvx_begin
        variable W1(size(Abar1, 2), N2 );
        variable W2(size(Abar2, 2), N2 );
        variable W3(size(Abar3, 2), N2 );
        minimize (  norm(Xtest - D*[Abar1 * W1; Abar2 * W2; Abar3 * W3], 'fro') + lambda *sum(sum(abs(W1))) + lambda * sum(sum(abs(W2))) +lambda * sum(sum(abs(W3))) );
        W1 >= 0 
        W2 >= 0
        W3 >= 0
cvx_end  

 
S1 = Abar1 * W1; 
S2 = Abar2 * W2;
S3 = Abar3 * W3;

[rmseS1 ] = RMSE(A_gt1, D1 * S1) ;
[rmseS2 ] = RMSE(A_gt2, D2 * S2) ;
[rmseS3 ] = RMSE(A_gt3, D3 * S3) ;

[maeS1] = NRMSE(A_gt1, D1 * S1) ;
[maeS2] = NRMSE(A_gt2, D2 * S2) ;
[maeS3] = NRMSE(A_gt3, D3 * S3) ;

[terS  ] = TER({ A_gt1, A_gt2,A_gt3}, { D1*S1,  D2*S2, D3*S3} ); 

final = [rmseS1 rmseS2 rmseS3 maeS1 maeS2 maeS3 terS ];




