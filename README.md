# H2020_AMIGO_code
-------------

This repository contains all the code involving AMIGO used in the H2020 project involving the Toggle Switch Model. The five  different models of the toggle switch being considered can be found in the folder AMIGO2_R2018b\Examples\TSM in the two subfolders model_calibration\ and model_selection. 

- model_calibration\
    
    |-- M1 contains all files related to the reformulated Toggle Switch Model (model M1). 
  
       |--- CMS contains all files related to the characterising the model structure of the reformulated Toggle Switch Model.
              |--- \Structural_Identifiability contains all scripts related to employing STRIKE-GOLDD for carrying out a structural identifiability analysis on model M1.
              |--- \Practical_Identifiability contains all scripts required for carrying out a practical identifiability analysis on model M1.
              |--- \Sensitivity_analysis contains all scripts required for carrying out sensitivity analyses on model M1.
  
       |--- CIC contains all files required for comparing informativeness of different inpout types when used to stimulate the reformulated Toggle Switch Model.
       
       |--- CMD contains all files required for characterising the dynamics (response time) of the reformulated Toggle Switch Model.
        
- model_selection\
    
    Unlike model_calibration\, this folder contains all files required for examining the remaining four models (M2 .. M5) used to describe the toggle switch model. The folder structure of each of these four models is identical to the folder structure found within model_calibration\M1\

