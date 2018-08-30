"""
VERSION CREATED: August 2, 2018
CONTACTS: jordan.baker@ibm.com

"""
from pyspark.sql.types import (StructType, StructField, StringType, DateType,
                               IntegerType)
from pyspark_common.reader import Reader


def cast_dtypes(dataframe):
    """
    A function to cast input from the reader into the proper datatype formats.

    Args:
        dataframe (DataFrame): The dataframe to be processed.

    Returns:
        DataFrame: A dataframe where all of the columns have the correct dtype.

    """
    schema = StructType([
        StructField('patient_id', StringType()),
        StructField('proc_code', StringType()),
        StructField('icd_proc1', StringType()),
        StructField('icd_flag', StringType()),
        StructField('fac_prof', StringType()),
        StructField('claim_id', StringType()),
        StructField('record_identifier', StringType()),
        StructField('rec_type', StringType()),
        StructField('svc_cat', StringType()),
        StructField('admit_type', StringType()),
        StructField('admit_date', DateType()),
        StructField('admission_id', StringType()),
        StructField('admit_type', StringType()),
        StructField('svc_date', DateType()),
        StructField('discharge_date', DateType()),
        StructField('dx1', StringType()),
        StructField('dx2', StringType()),
        StructField('dx3', StringType()),
        StructField('dx4', StringType()),
        StructField('dx_category1', StringType()),
        StructField('dx_category2', StringType()),
        StructField('dx_category3', StringType()),
        StructField('dx_category4', StringType()),
        StructField('dx_stage1', StringType()),
        StructField('dx_stage2', StringType()),
        StructField('dx_stage3', StringType()),
        StructField('dx_stage4', StringType()),
        StructField('dxcat', StringType()),
        StructField('stage', StringType()),
        StructField('drg', StringType()),
        StructField('NDCNUM', StringType()),
        StructField('GENERICID', StringType()),
        StructField('Prodname', StringType()),
        StructField('Category', StringType()),
        StructField('OpiatesGNID', StringType()),
        StructField('OpiatesTCLS', StringType()),
        StructField('flag_opiates', IntegerType()),
        StructField('ndc', StringType()),
        StructField('generid', StringType()),
        StructField('therCls', StringType()),
        StructField('DxCat', StringType()),
        StructField('Description', StringType()),
        StructField('Significance', StringType()),
        StructField('venipuncture_code', StringType()),
        StructField('cpt', IntegerType()),
        StructField('svcscat', IntegerType()),
        StructField('flag_excl', IntegerType()),
        StructField('DxCat', StringType()),
        StructField('Description', StringType()),
        StructField('Category', StringType()),
        StructField('hcpc', StringType()),
        StructField('procgrp', StringType()),
        StructField('csc', StringType()),
        StructField('atg', StringType()),
        StructField('atg_priority', StringType()),
        StructField('procgrp_intensity', StringType()),
        StructField('hcpcs_intensity', StringType()),
        StructField('imputed_rel_wgt', StringType()),
        StructField('status_ind', StringType()),
        StructField('procgrp_ver', StringType()),
        StructField('release', StringType()),
        StructField('condition_dxcat', StringType()),
        StructField('condition_dxcatstage', IntegerType()),
        StructField('condition_dxcat_er', StringType()),
        StructField('condition_drg', StringType()),
        StructField('condition_admtype', StringType()),
        StructField('condition_procgrp', StringType()),
        StructField('rebalance', IntegerType()),
        StructField('Neonate_DRG', StringType()),
        StructField('flag_neonate', IntegerType()),
        StructField('Description', StringType()),
        StructField('DxCatDesc', StringType()),
        StructField('PROCGRP', StringType()),
        StructField('Procedure_group', StringType()),
        StructField('CodeType', StringType()),
        StructField('Code', StringType()),
        StructField('Description', StringType()),
        StructField('therClassCode', StringType()),
        StructField('Inttherclass', StringType()),
        StructField('therDesc', StringType()),
        StructField('gcrTitles', StringType()),
        StructField('genindDesc', StringType()),
        StructField('roa', StringType()),
        StructField('cyle', StringType()),
        StructField('Active', StringType()),
        StructField('Stage', StringType()),
        StructField('StageHistory', StringType()),
        StructField('ICD', StringType()),
        StructField('Description', StringType()),
        StructField('ICDVersion', StringType())
        ])

    new_df = Reader.cast_and_exclude(dataframe=dataframe, schema=schema)

    return new_df
