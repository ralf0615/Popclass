
import pandas as pd

import popclass.fa_to_mktscan_popclass as util2


pd.set_option('display.max_columns', 100)

fa_input_files_path = "/Users/ujwal.reddy.moramgantiibm.com/Downloads/Input " \
                      "files/Utility_testing/LatestSetOfInputFiles/"


precursor_analytics_file_path = "/Users/ujwal.reddy.moramgantiibm.com/" \
                                "Downloads/Input files/Utility_testing/" \
                                "precursor_analytics/"

ref_files_path = "/Users/ujwal.reddy.moramgantiibm.com/Downloads/POPCLASS-1" \
                 ".0.30/"

sample_output_files_path_gt = "/Users/ujwal.reddy.moramgantiibm.com/Downloads"\
                            "/Input files/Utility_testing/mktscan/"


def test_ccaed(sample_output_files_path_gt, fa_input_files_path,
               fa_pharmacy_filename, ref_files_path):
    # ENROLID
    # SVCDATE
    # DAYSUPP
    # NDCNUM
    # GENERID
    # THERCLS
    # PAY

    ccaed = util2.create_ccaed(fa_input_files_path,
               fa_pharmacy_filename, ref_files_path)
    ccaed_gt = pd.read_csv(sample_output_files_path_gt + "ccaed.csv",
                             dtype=str)
    ccaed_gt.fillna("NA", inplace=True)
    ccaed.fillna("NA", inplace=True)

    check0 = ccaed_gt.shape[0] == ccaed.shape[0]

    row_count = ccaed.shape[0]

    check1 = sum(list(ccaed_gt["ENROLID"] == ccaed["ENROLID"])) == row_count
    check2 = sum(list(ccaed_gt["GENERID"] == ccaed["GENERID"])) == row_count
    check3 = sum(list(ccaed_gt["THERCLS"] == ccaed["THERCLS"])) == row_count
    check4 = sum(list(ccaed_gt["NDCNUM"] == ccaed["NDCNUM"])) == row_count
    check5 = sum(list(ccaed_gt["SVCDATE"] == ccaed["SVCDATE"])) == row_count
    check6 = sum(list(ccaed_gt["DAYSUPP"] == ccaed["DAYSUPP"])) == row_count

    df = pd.DataFrame(
        {'Field': ["row_count_match","ENROLID", "GENERID", "THERCLS",
                       "NDCNUM","SVCDATE", "DAYSUPP"],
         'Flag': [check0, check1, check2, check3,
                                              check4, check5, check6]
         })
    return(df)

test_ccaed(sample_output_files_path_gt, fa_input_files_path,
               "FA__output_pharmacy_file.csv", ref_files_path)

# GENERID and THERCLS do not match probably because FA used new version of
# redbook whereas the 2013 mktscan uses previous version of redbook.

def test_ccaea(sample_output_files_path_gt, fa_input_files_path,
               fa_enroll_filename):
    # ENROLID
    # AGE
    # SEX
    # MSA
    # RX
    # ENRIND 1 - 12
    # PLNTYP 1 - 12

    ccaea = util2.create_ccaea(fa_input_files_path, fa_enroll_filename)
    ccaea_gt = pd.read_csv(sample_output_files_path_gt + "ccaea.csv",
                             dtype=str)

    ccaea_gt.fillna("NA", inplace=True)
    ccaea.fillna("NA", inplace=True)

    check0 = ccaea_gt.shape[0] == ccaea.shape[0]

    row_count = ccaea.shape[0]


    check1 = sum(list(ccaea_gt["ENROLID"] == ccaea["ENROLID"])) == row_count
    check2 = sum(list(ccaea_gt["AGE"] == ccaea["AGE"])) == row_count
    check3 = sum(list(ccaea_gt["SEX"] == ccaea["SEX"])) == row_count

    df = pd.DataFrame(
        {'Field': ["row_count_match", "ENROLID", "AGE", "SEX"],
         'Flag': [check0, check1, check2, check3]
         })
    return df

test_ccaea(sample_output_files_path_gt, fa_input_files_path,
               "FA__output_enrollment_file.csv")

# Investigate whether we need to generate ENRIND 1 - 12 from DSTART and DEND ?
# num of enrolled months

def test_ccaes(sample_output_files_path_gt, fa_input_files_path,
               fa_medical_filename, precursor_analytics_file_path,
               svccat_filename):
    # ENROLID
    # SEQNUM
    # AGE
    # SEX
    # PROC1
    # % if & Prevyear.>= 2015 % then DXVER
    # DX1 - DX4
    # ADMTYP
    # SVCSCAT
    # SVCDATE

    ccaes = util2.create_ccaes(fa_input_files_path,
               fa_medical_filename, precursor_analytics_file_path,
               svccat_filename)

    ccaes_gt = pd.read_csv(sample_output_files_path_gt + "ccaes.csv",
                             dtype=str)

    ccaes_gt.fillna("NA", inplace=True)
    ccaes.fillna("NA", inplace=True)

    check0 = ccaes_gt.shape[0] == ccaes.shape[0]

    row_count = ccaes.shape[0]

    check1 = sum(list(ccaes_gt["ENROLID"] == ccaes["ENROLID"])) == row_count
    check2 = sum(list(ccaes_gt["AGE"] == ccaes["AGE"])) == row_count
    check3 = sum(list(ccaes_gt["SEX"] == ccaes["SEX"])) == row_count
    check4 = sum(list(ccaes_gt["DX1"] == ccaes["DX1"])) == row_count
    check5 = sum(list(ccaes_gt["DX2"] == ccaes["DX2"])) == row_count
    check6 = sum(list(ccaes_gt["DX3"] == ccaes["DX3"])) == row_count
    check7 = sum(list(ccaes_gt["DX4"] == ccaes["DX4"])) == row_count
    check8 = sum(list(ccaes_gt["PROC1"] == ccaes["PROC1"])) == row_count
    check9 = sum(list(ccaes_gt["ADMTYP"] == ccaes["ADMTYP"])) == row_count
    check10 = sum(list(ccaes_gt["SVCSCAT"] == ccaes["SVCSCAT"])) == row_count
    check11 = sum(list(ccaes_gt["SVCDATE"] == ccaes["SVCDATE"])) == row_count

    df = pd.DataFrame(
        {'Field': ["row_count_match", "ENROLID", "AGE", "SEX","DX1",
                   "SVCDATE", "DX3", "DX4", "PROC1", "ADMTYP", "SVCSCAT",
                   "SVCDATE"],
         'Flag': [check0, check1, check2, check3, check4, check5, check6,
                  check7, check8, check9, check10, check11]
         })
    return df

test_ccaes(sample_output_files_path_gt, fa_input_files_path,
               "FA_medical_output.csv", precursor_analytics_file_path,
           "FA__appadm_SVCCAT2.17_FA_medical_outputforFA_svcoutput_med.csv")

# Investigate why ADMTYPE is not matching.
# Include DXVER only for year > 2015.


def test_ccaeo(sample_output_files_path_gt, fa_input_files_path,
               fa_medical_filename):

    # ENROLID
    # FACPROF
    # SEQNUM
    # AGE
    # SEX
    # PROC1
    # DX1 - DX4
    # % if & Prevyear.>= 2015 % then DXVER
    # SVCSCAT
    # SVCDATE
    # MSCLMID
    # FACHDID
    # PROCGRP
    # DXCAT
    # STDPROV
    # PAY

    ccaeo = util2.create_ccaeo(fa_input_files_path, fa_medical_filename)

    ccaeo_gt = pd.read_csv(sample_output_files_path_gt + "ccaeo.csv",
                             dtype=str)

    ccaeo.reset_index(inplace=True)
    ccaeo_gt.fillna("NA", inplace=True)
    ccaeo.fillna("NA", inplace=True)

    check0 = ccaeo_gt.shape[0] == ccaeo.shape[0]

    row_count = ccaeo.shape[0]

    check1 = sum(list(ccaeo_gt["ENROLID"] == ccaeo["ENROLID"])) == row_count
    check2 = sum(list(ccaeo_gt["AGE"] == ccaeo["AGE"])) == row_count
    check3 = sum(list(ccaeo_gt["DX1"] == ccaeo["DX1"])) == row_count
    check4 = sum(list(ccaeo_gt["DX2"] == ccaeo["DX2"])) == row_count
    check5 = sum(list(ccaeo_gt["DX3"] == ccaeo["DX3"])) == row_count
    check6 = sum(list(ccaeo_gt["DX4"] == ccaeo["DX4"])) == row_count
    check7 = sum(list(ccaeo_gt["PROC1"] == ccaeo["PROC1"])) == row_count
    check8 = sum(list(ccaeo_gt["SVCSCAT"] == ccaeo["SVCSCAT"])) == row_count
    check9 = sum(list(ccaeo_gt["SVCDATE"] == ccaeo["SVCDATE"])) == row_count
    check10 = sum(list(ccaeo_gt["STDPROV"] == ccaeo["STDPROV"])) == row_count
    check11 = sum(list(ccaeo_gt["DXCAT"] == ccaeo["DXCAT"])) == row_count
    check12 = sum(list(ccaeo_gt["PROCGRP"] == ccaeo["PROCGRP"])) == row_count
    check13 = sum(list(ccaeo_gt["MSCLMID"] == ccaeo["MSCLMID"])) == row_count
    check14 = sum(list(ccaeo_gt["FACPROF"] == ccaeo["FACPROF"])) == row_count
    check15 = sum(list(ccaeo_gt["SEX"] == ccaeo["SEX"])) == row_count

    df = pd.DataFrame(
        {'Field': ["row_count_match", "ENROLID", "AGE", "DX1",
                   "SVCDATE", "DX3", "DX4", "PROC1", "SVCSCAT",
                   "SVCDATE", "STDPROV", "DXCAT", "PROCGRP",
                   "MSCLMID", "FACPROF", "SEX"],
         'Flag': [check0, check1, check2, check3, check4, check5, check6,
                  check7, check8, check9, check10, check11, check12,
                  check13, check14, check15]
         })
    return df

test_ccaeo(sample_output_files_path_gt, fa_input_files_path,
               "FA_medical_output.csv")

def test_ccaei(sample_output_files_path_gt, precursor_analytics_file_path,
               admissions_filename):

    # ENROLID
    # PDXCAT
    # ADMDATE
    # DISDATE
    # DRG
    # ADMTYP
    # TOTPAY
    # DSTATUS

    ccaei = create_ccaei(precursor_analytics_file_path,
                               admissions_filename)
    ccaei_gt = pd.read_csv(sample_output_files_path_gt + "ccaei.csv",
                             dtype=str)

    ccaei.reset_index(inplace=True)

    ccaei_gt.fillna("NA", inplace=True)
    ccaei.fillna("NA", inplace=True)

    #check0 = ccaei_gt.shape[0] == ccaei.shape[0]

    row_count = ccaei.shape[0]

    #req_cols = ['ENROLID', 'PDXCAT','ADMDATE', 'DISDATE', 'DRG', 'ADMTYP',
    #            'DSTATUS']

    req_cols = ['ENROLID', 'PDXCAT', 'ADMDATE', 'DISDATE', 'DRG']

    ccaei_gt = ccaei_gt[req_cols]
    ccaei = ccaei[req_cols]

    merged = ccaei.merge(ccaei_gt, on=req_cols, how='inner')

    return(merged.shape[0]/row_count * 100)

test_ccaei(sample_output_files_path_gt, precursor_analytics_file_path,
           "FA__appadm_MEG9.34_FA_medical_outputforFA_admissions.csv")

# Investigate why admission type and discharge status are both empty in
# admissions output.

# Different versions of ADM groups the claims are grouped different way.

def test_ccaef(sample_output_files_path_gt, fa_input_files_path,
               fa_medical_filename, precursor_analytics_file_path,
               adm_med_link_filename):

    # ENROLID
    # SVCDATE
    # TSVCDAT
    # DAYS
    # FACHDID
    # CASEID

    ccaef = util2.create_ccaef(fa_input_files_path,
               fa_medical_filename, precursor_analytics_file_path,
               adm_med_link_filename)


    ccaef_gt = pd.read_csv(sample_output_files_path_gt + "ccaef.csv",
                             dtype=str)
    req_cols_ccaef = ['ENROLID', 'SVCDATE', 'TSVCDAT', 'DAYS', 'FACHDID'
        , 'CASEID']

    num_records = ccaef.shape[0]
    ccaef = ccaef[req_cols_ccaef]
    ccaef_gt = ccaef_gt[req_cols_ccaef]

    #merged = ccaef.merge(ccaef_gt, on=['ENROLID', 'SVCDATE', 'TSVCDAT'],
    #                     how='inner')
    #merged_num_records = merged.shape[0]

    #print(num_records == merged_num_records)
    return (merged)


# why do we have negative numbers in LOS in MKTScan files ?


test_ccaef(sample_output_files_path_gt, fa_input_files_path,
           "FA_medical_output.csv",
               precursor_analytics_file_path, "FA__appadm_MEG9.34_FA_medical"
                                                "_outputforFA_admmedlink.csv")

#######################################
ccaef = create_ccaef(fa_input_files_path, "FA_medical_output.csv",
               precursor_analytics_file_path, "FA__appadm_MEG9.34_FA_medical"
                                                "_outputforFA_admmedlink.csv")


ccaef_gt = pd.read_csv(sample_output_files_path_gt + "ccaef.csv",
                       dtype=str)

req_cols_ccaef = ['ENROLID', 'SVCDATE', 'TSVCDAT', 'DAYS', 'FACHDID'
        , 'CASEID']

num_records = ccaef.shape[0]

ccaef = ccaef[req_cols_ccaef]
ccaef_gt = ccaef_gt[req_cols_ccaef]


################################################
# a = list(ccaed_test["GENERID"])
# b = list(ccaed["GENERID"])
# c = pd.DataFrame({'a': a, 'b' : b}, dtype= str)
# c.loc[~(c['a'] == c['b'])]

