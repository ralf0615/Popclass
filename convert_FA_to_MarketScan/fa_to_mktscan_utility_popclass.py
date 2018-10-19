# -*- coding: utf-8 -*-

"""
VERSION CREATED: Oct 4, 2018
CONTACTS: ujwal.reddy.moramganti@ibm.com, yuchen.li@ibm.com
This module contains utility functions that will be used during development,
will not be shipped with the build. It contains functions which are used to
create csv files that mimic Market Tables input from FA and Precursor
Analytic Tables  for a given analytic
"""

import pandas as pd


def date_format(date):
    # Date formatting e.g. : 20130114 - 01/14/2013
    year = date[0:4]
    month = date[4:6]
    day = date[6:8]
    date_formatted = month + "/" + day + "/" + year
    return date_formatted


def create_ccaea(fa_input_files_path, fa_enroll_filename):

    # ENROLID
    # AGE
    # SEX
    # MSA
    # RX
    # ENRIND 1 - 12
    # PLNTYP 1 - 12

    ccaea = pd.read_csv(fa_input_files_path + fa_enroll_filename , dtype=str)

    ccaea.rename(columns={"patient_id": "ENROLID",
                          "effective_from_date": "DTSTART",
                          "ext_date": "DTEND",
                          "age": "AGE",
                          "sex": "SEX",
                          "enrmon": "ENRMON"}, inplace=True)

    ccaea["DTSTART"] = ccaea["DTSTART"].apply(lambda x: date_format(x))
    ccaea["DTEND"] = ccaea["DTEND"].apply(lambda x: date_format(x))

    ccaea["MSA"] = ""
    ccaea["RX"] = ""

    ccaea["PLNTYP1"] = ""
    ccaea["PLNTYP2"] = ""
    ccaea["PLNTYP3"] = ""
    ccaea["PLNTYP4"] = ""
    ccaea["PLNTYP5"] = ""
    ccaea["PLNTYP6"] = ""
    ccaea["PLNTYP7"] = ""
    ccaea["PLNTYP8"] = ""
    ccaea["PLNTYP9"] = ""
    ccaea["PLNTYP10"] = ""
    ccaea["PLNTYP11"] = ""
    ccaea["PLNTYP12"] = ""

    ccaea["ENRIND1"] = ""
    ccaea["ENRIND2"] = ""
    ccaea["ENRIND3"] = ""
    ccaea["ENRIND4"] = ""
    ccaea["ENRIND5"] = ""
    ccaea["ENRIND6"] = ""
    ccaea["ENRIND7"] = ""
    ccaea["ENRIND8"] = ""
    ccaea["ENRIND9"] = ""
    ccaea["ENRIND10"] = ""
    ccaea["ENRIND11"] = ""
    ccaea["ENRIND12"] = ""

    return ccaea


def create_ccaed(fa_input_files_path,
                 fa_pharmacy_filename,
                 ref_files_path):

    # ENROLID
    # SVCDATE
    # DAYSUPP
    # NDCNUM
    # GENERID
    # THERCLS
    # PAY

    ref_drug_table = pd.read_csv(ref_files_path +
                                 "redbook_extract_popclass.csv", dtype=str)
    pharmacy_file = pd.read_csv(fa_input_files_path + fa_pharmacy_filename
                                , dtype=str)

    pharmacy_file["ndc_nbr"] = pharmacy_file["ndc_nbr"].\
        apply(lambda x: x.zfill(11))

    ccaed = pd.merge(pharmacy_file, ref_drug_table, left_on=[
        'ndc_nbr'], right_on=["ndc"], how="left")

    ccaed.drop("ndc", inplace=True, axis=1)

    ccaed.rename(columns={"generid": "GENERID",
                          "therCls": "THERCLS",
                          "patient_id": "ENROLID",
                          "ndc_nbr": "NDCNUM",
                          "claim_date": "SVCDATE",
                          "days_supply_cnt": "DAYSUPP"}, inplace=True)

    ccaed["PAY"] = 0
    ccaed['SVCDATE'] = ccaed['SVCDATE'].apply(lambda x: date_format(x))

    return ccaed


def create_ccaes(fa_input_files_path, fa_medical_filename,
                 precursor_analytics_file_path,
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

    ccaes = pd.read_csv(fa_input_files_path + fa_medical_filename, dtype=str)
    ccaes = ccaes[ccaes.rec_type == "I"]

    svccat_file = pd.read_csv(precursor_analytics_file_path +
                              svccat_filename, dtype=str)

    svc_adm_type = svccat_file[["record_identifier", "admit_type_cd"]]

    ccaes = pd.merge(ccaes, svc_adm_type, on=["record_identifier"],
                     how="left")

    ccaes = ccaes[["patient_id", "age", "sex", "dx1", "dx2", "dx3", "dx4",
                   "icd_proc1", "icd_flag", "admit_type_cd", "svc_cat",
                   "svc_date", "record_identifier"]]

    ccaes.rename(columns={"patient_id": "ENROLID",
                          "age": "AGE",
                          "sex": "SEX",
                          "dx1": "DX1",
                          "dx2": "DX2",
                          "dx3": "DX3",
                          "dx4": "DX4",
                          "icd_proc1": "PROC1",
                          "icd_flag": "DXVER",
                          "admit_type_cd": "ADMTYP",
                          "svc_cat": "SVCSCAT",
                          "svc_date": "SVCDATE",
                          "record_identifier": "FACHID"}, inplace=True)

    ccaes.loc[ccaes['SEX'] == 'F', 'SEX'] = '2'
    ccaes.loc[ccaes['SEX'] == 'M', 'SEX'] = '1'

    ccaes["SVCDATE"] = ccaes["SVCDATE"].apply(lambda x: date_format(x))

    return ccaes


def create_ccaeo(fa_input_files_path,
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

    ccaeo = pd.read_csv(fa_input_files_path + fa_medical_filename , dtype=str)
    ccaeo = ccaeo[ccaeo.rec_type == "O"]

    ccaeo = ccaeo[["patient_id", "age", "sex", "dx1", "dx2", "dx3", "dx4",
                   "proc_code", "icd_flag",  "svc_cat", "svc_date",
                   "record_identifier", "pay", "std_prov",
                   "dx_cat", "proc_group_cd", "claim_id", "fac_prof"]]

    ccaeo.rename(columns={"patient_id": "ENROLID",
                          "age": "AGE",
                          "sex": "SEX",
                          "dx1": "DX1",
                          "dx2": "DX2",
                          "dx3": "DX3",
                          "dx4": "DX4",
                          "proc_code": "PROC1",
                          "icd_flag": "DXVER",
                          "svc_cat": "SVCSCAT",
                          "svc_date": "SVCDATE",
                          "record_identifier": "FACHDID",
                          "pay": "PAY",
                          "std_prov": "STDPROV",
                          "dx_cat": "DXCAT",
                          "proc_group_cd": "PROCGRP",
                          "claim_id": "MSCLMID",
                          "fac_prof": "FACPROF"}, inplace=True)

    ccaeo.loc[ccaeo['SEX'] == 'F', 'SEX'] = '2'
    ccaeo.loc[ccaeo['SEX'] == 'M', 'SEX'] = '1'

    ccaeo["SVCDATE"] = ccaeo["SVCDATE"].apply(lambda x: date_format(x))

    return ccaeo


def create_ccaei(precursor_analytics_file_path,
                 admissions_filename):

    # ENROLID
    # PDXCAT
    # ADMDATE
    # DISDATE
    # DRG
    # ADMTYP
    # TOTPAY
    # DSTATUS

    admissions_data_input = pd.read_csv(precursor_analytics_file_path +
                                        admissions_filename, dtype = str)

    admissions_data_input['admit_date'] = admissions_data_input[
        'admit_date'].apply(lambda x: date_format(x))
    admissions_data_input['discharge_date'] = admissions_data_input[
        'discharge_date'].apply(lambda x: date_format(x))

    ccaei = admissions_data_input[['patient_id', 'dxcat', 'admit_date',
                                   'discharge_date', 'calculated_drg',
                                   'admit_type', 'allow_pay', 'discharge',
                                   'admission_id', 'icd_flag']]

    ccaei.rename(columns = {'patient_id': 'ENROLID',
                            'dxcat': 'PDXCAT',
                            'admit_date': 'ADMDATE',
                            'discharge_date': 'DISDATE',
                            'calculated_drg': 'DRG',
                            'admit_type': 'ADMTYP',
                            'allow_pay': 'TOTPAY',
                            'discharge': 'DSTATUS',
                            'admission_id': 'CASEID',
                            'icd_flag': 'DXVER'},
                 inplace=True)

    ccaei['SEQNUM'] = ''

    return ccaei


def create_ccaef(fa_input_files_path,
                 fa_medical_filename,
                 precursor_analytics_file_path,
                 adm_med_link_filename):
    # ENROLID
    # SVCDATE
    # TSVCDAT
    # DAYS
    # FACHDID
    # CASEID

    fa_medical_claims = pd.read_csv(fa_input_files_path +
                                    fa_medical_filename, dtype = str)

    facility = fa_medical_claims[fa_medical_claims.fac_prof == "F"]

    facility = facility[["patient_id", "svc_date", "end_date", "los",
                         "record_identifier"]]

    adm_med_link = pd.read_csv(precursor_analytics_file_path +
                               adm_med_link_filename, dtype = str)

    ccaef = facility.merge(adm_med_link, how = "left",
                                 on = ["record_identifier"])

    ccaef.rename(columns={"patient_id_x": "ENROLID",
                          "svc_date": "SVCDATE",
                          "end_date": "TSVCDAT",
                          "los": "DAYS",
                          "record_identifier": "FACHDID",
                          "admission_id": "CASEID",
                          }, inplace=True)

    ccaef['SVCDATE'] = ccaef['SVCDATE'].apply(lambda x: date_format(x))
    ccaef['TSVCDAT'] = ccaef['TSVCDAT'].apply(lambda x: date_format(x))

    ccaef['DAYS'] = ccaef['DAYS'].apply(lambda x: x.split(".")[0])
    ccaef.loc[ccaef.DAYS == "0", "DAYS"] = np.nan

    ccaef.drop(['patient_id_y', 'admission_number', 'record_nbr'], axis=1,
               inplace = True)

    return ccaef


def fa_to_mktscan_popclass(fa_input_files_path,
                           fa_medical_filename,
                           fa_pharmacy_filename,
                           fa_enroll_filename,
                           precursor_analytics_file_path,
                           admissions_filename,
                           adm_med_link_filename,
                           svccat_filename,
                           ref_files_path,
                           output_files_path):
    """
       The function creates Market scan files from FA input files in a
       format required by the PopClass SAS code.

       Args:
           fa_input_files_path (directory_path): The directory path to the
           FA input file names.
           fa_medical_filename (filename): Filename of the FA medical claims
           file.
           fa_pharmacy_filename (filename): Filename of the FA pharmacy
           claims file.
           fa_enroll_filename (filename): Filename of the FA enrollment file.
           precursor_analytics_file_path (directory_path): The directory path
           to the FA input file names.
           admissions_filename (filename): Filename of the FA ADM output.
           adm_med_link_filename (filename): Filename of the FA ADM output.
           svccat_filename (filename): Filename of the FA ADM output.
           ds_filename (filename): Filename of the FA ADM output.
           ref_files_path (directory) : The directory path to the
           reference files.
           output_files_path (directory_path): The directory path to the
           output the function generates.

        output: The function outputs six marketscan tables : ccaea, ccaed,
        ccaeo, ccaei, ccaef, ccaes


       """
    ccaea = create_ccaea(fa_input_files_path,
                         fa_enroll_filename)

    ccaed = create_ccaed(fa_input_files_path,
                         fa_pharmacy_filename,
                         ref_files_path)

    ccaes = create_ccaes(fa_input_files_path,
                         fa_medical_filename,
                         precursor_analytics_file_path,
                         svccat_filename)

    ccaeo = create_ccaeo(fa_input_files_path,
                         fa_medical_filename)

    ccaei = create_ccaei(precursor_analytics_file_path,
                         admissions_filename)

    ccaef = create_ccaef(fa_input_files_path,
                         fa_medical_filename,
                         precursor_analytics_file_path,
                         adm_med_link_filename)

    ccaea.to_csv(output_files_path + "ccaea.csv", index=False)
    ccaed.to_csv(output_files_path + "ccaed.csv", index=False)
    ccaes.to_csv(output_files_path + "ccaes.csv", index=False)
    ccaeo.to_csv(output_files_path + "ccaeo.csv", index=False)
    ccaei.to_csv(output_files_path + "ccaei.csv", index=False)
    ccaef.to_csv(output_files_path + "ccaef.csv", index=False)

    return ccaea, ccaed, ccaes, ccaeo, ccaei, ccaef
