#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 17 12:42:47 2018

@author: yuchenli
"""

import pandas as pd
import numpy as np
from collections import Counter


# Count ENROLIDS
df = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_rerun_reference_tables/'
                 '31DEC2015Enrolids2000_10292018.csv')

df['patient_id'].count()
df['patient_id'].nunique()

counts = df['patient_id'].value_counts().to_dict()



df_1 = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_rerun_reference_tables/'
                 '31DEC2015Enrolids2000_10292018_SamplewClassification.csv')

df_1['ENROLID'].count()
df_1['ENROLID'].nunique()

counts_1 = df_1['ENROLID'].value_counts().to_dict()


# YL
df_2= pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_rerun_reference_tables/'
                 'u071439_DISEASESTAGING6.34_31DEC2015Enrolids2000_10292018_Dsoutput.csv')

df_2['patient_id'].count()
df_2['patient_id'].nunique()

counts_2 = df_2['patient_id'].value_counts().to_dict()


# UM
df_3= pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_modified_UM/'
                 'u071366_DISEASESTAGING6.34_31DEC2015MarketScanSample_Dsoutput.csv')

df_3['patient_id'].count()
df_3['patient_id'].nunique()

counts_3 = df_3['patient_id'].value_counts().to_dict()



# Convert unique patient_id(enrollee_id) to dataframe
df2 = pd.DataFrame(df['patient_id'].unique(), columns = ['enrolid'])
df2.to_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
           'SAS_prototype_rerun_reference_tables/'
           'SAS_prototype_unmodified_enrolid.csv',
           index=False)


# Compare AE input
um_AE_1 = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_modified_UM/'
                 '31DEC2015MarketScanSample.csv')

yl_AE_1 = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_rerun_reference_tables/'
                 '31DEC2015Enrolids2000_10292018.csv')

AE_input_match = dict()
for i in range(len(um_AE_1)):
    match = True
    for j in range(0,15):
        cell1 = str(um_AE_1.iloc[i,j])
        cell2 = str(yl_AE_1.iloc[i,j])
        if cell1 == 'nan' and cell2 == 'nan':
            match = match and True
        else:
            match = (match and (um_AE_1.iloc[i,j] == yl_AE_1.iloc[i,j]))
    
    AE_input_match[um_AE_1.iloc[i,2]] = match
    
counts_AE_input = Counter(AE_input_match.values())

# Conclusion, our AE_input matches
               
        


# Compare AE output
um_AE = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_modified_UM/'
                 'u071366_DISEASESTAGING6.34_31DEC2015MarketScanSample_Dsoutput.csv')

yl_AE = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_rerun_reference_tables/'
                 'u071439_DISEASESTAGING6.34_31DEC2015Enrolids2000_10292018_Dsoutput.csv')

AE_output_match = dict()
for i in range(len(um_AE)):
    match = True
    for j in range(0,19):
        cell1 = str(um_AE.iloc[i,j])
        cell2 = str(yl_AE.iloc[i,j])
        if cell1 == 'nan' and cell2 == 'nan':
            match = match and True
        else:
            match = (match and (cell1==cell2))  
        # print (cell1, cell2, match)
    
    AE_output_match[um_AE.iloc[i,2]] = match
    
counts_AE_output = Counter(AE_output_match.values())

# Conclusion, our AE_output matches




# Compare 'ALLRULES.csv' between UM and YL
um = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_modified_UM/'
                 'AllRules31DEC2015MarketScanSample.csv')
um_dict = dict(zip(um.ENROLID, um.PopClassFinalDescription))
um_dict_counter = Counter(um_dict.values())

yl = um = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_rerun_reference_tables/'
                 'AllRules31DEC2015Enrolids2000_10292018.csv')
yl_dict = dict(zip(yl.ENROLID, yl.PopClassFinalDescription))
yl_dict_counter = Counter(yl_dict.values())


result = list()
for key in um_dict:
    if um_dict[key] != yl_dict[key]:
        result.append(key)
        
print(result)


tag_output_match = dict()
for i in range(len(um)):
    match = True
    for j in range(0,66):
        cell1 = str(um.iloc[i,j])
        cell2 = str(yl.iloc[i,j])
        if cell1 == 'nan' and cell2 == 'nan':
            match = match and True
        else:
            match = (match and (um.iloc[i,j] == yl.iloc[i,j]))
            
        # print (cell1, cell2, match)
    
    tag_output_match[um.iloc[i,0]] = match

tag_output_match_counter = Counter(tag_output_match.values())