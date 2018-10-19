#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 17 12:42:47 2018

@author: yuchenli
"""

import pandas as pd

df = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
                 'SAS_prototype_rerun/31DEC2014Client450_10162018.csv')

df['patient_id'].count()
df['patient_id'].nunique()

counts = df['patient_id'].value_counts().to_dict()


# Convert unique patient_id(enrollee_id) to dataframe
df2 = pd.DataFrame(df['patient_id'].unique(), columns = ['enrolid'])
df2.to_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'
           'SAS_prototype_rerun/SAS_prototype_unmodified_enrolid.csv',
           index=False)