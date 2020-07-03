clc; close all; clear all; 

%load testing dataset
load('testP70_1','TIndus1_domi', 'TI1domi_Indus1_gt', 'TI1domi_Indus2_gt', 'TI1domi_Solar_gt'); 
load('testP70_2','TCommer_domi',  'TI2domi_Indus2_gt' ,'TI2domi_Indus1_gt' ,'TI2domi_Solar_gt'); 
load('testP70_3','TSolar_domi','TSolardomi_Solar_gt' ,'TSolardomi_Indus1_gt', 'TSolardomi_Indus2_gt'); 
%load training dictionary
load('trainingDL', 'D1', 'D2','D3' );

%ground truth data
A_gt1=[TI1domi_Indus1_gt TI2domi_Indus1_gt TSolardomi_Indus1_gt] ;
A_gt2=[TI1domi_Indus2_gt TI2domi_Indus2_gt TSolardomi_Indus2_gt];
A_gt3=[TI1domi_Solar_gt TI2domi_Solar_gt TSolardomi_Solar_gt];


lambda =0.0001;

%% testing datasets
Xtest=[TIndus1_domi TCommer_domi TSolar_domi];
N2 = size(Xtest, 2);   

D = [D1 D2 D3]; 


cvx_begin
        variable S1(size(D1, 2), N2 );
        variable S2(size(D2, 2), N2 );
        variable S3(size(D3, 2), N2 );
        minimize (  norm(Xtest - D*[S1 ; S2 ; S3 ], 'fro') + lambda *sum(sum(abs(S1))) + lambda * sum(sum(abs(S2))) +lambda* sum(sum(abs(S3))) ); 
        S1 >= 0 
        S2 >= 0
        S3 <= 0
cvx_end  


[rmseS1 ] = RMSE(A_gt1, D1 * S1) ;
[rmseS2 ] = RMSE(A_gt2, D2 * S2) ;
[rmseS3 ] = RMSE(A_gt3, D3 * S3) ;

[maeS1] = NRMSE(A_gt1, D1 * S1) ;
[maeS2] = NRMSE(A_gt2, D2 * S2) ;
[maeS3] = NRMSE(A_gt3, D3 * S3) ;

 [terS  ] = TER({ A_gt1, A_gt2,A_gt3}, { D1*S1,  D2*S2, D3*S3} ); 
final = [rmseS1 rmseS2 rmseS3 maeS1 maeS2 maeS3 terS ];



