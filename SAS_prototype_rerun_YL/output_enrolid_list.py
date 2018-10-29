#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 17 12:42:47 2018

@author: yuchenli
"""

import pandas as pd

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




df_2= pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_rerun_reference_tables/'
                 'u071439_DISEASESTAGING6.34_31DEC2015Enrolids2000_10292018_Dsoutput.csv')

df_2['patient_id'].count()
df_2['patient_id'].nunique()

counts_2 = df_2['patient_id'].value_counts().to_dict()






# Convert unique patient_id(enrollee_id) to dataframe
df2 = pd.DataFrame(df['patient_id'].unique(), columns = ['enrolid'])
df2.to_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
           'SAS_prototype_rerun_reference_tables/'
           'SAS_prototype_unmodified_enrolid.csv',
           index=False)