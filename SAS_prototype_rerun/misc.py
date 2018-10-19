#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Oct 17 12:42:47 2018

@author: yuchenli
"""

import pandas as pd

df = pd.read_csv('/Users/yuchenli/Box Sync/Yuchen_project/Popclass/'\
                 '343_patient_SAS_scoring_date/31DEC2014Client450_10162018.csv')

df['patient_id'].count()
df['patient_id'].nunique()

counts = df['patient_id'].value_counts().to_dict()