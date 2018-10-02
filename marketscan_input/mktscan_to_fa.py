"""
VERSION CREATED: March 6, 2018
CONTACTS: prajit.m@ibm.com
This module contains utility functions that will be used during development,
will not be shipped with the build. It contains functions which are used to
create csv files that mimic FA input from MarketScan Tables for a given
analytic
"""
import pandas as pd
import datetime

def create_fa_inputs(output_file, market_scan_file, columns_map_file, analytic,
                     file_type, include_optional=False):
    """
       Generic functionality to create an FA input csv file from a market scan
       extract csv for FA input files that only require selecting from a
       single MarketScan extract,these will be used to mimic client input csv
       for FA

       Args:
           output_file (directory_path/filename): The output path and filename,
               where the csv file will be saved
           market_scan_file (directory_path/filename): The path for market scan
               file extract csv, this csv may contain additional columns that
               may not have a corresponding FA variable
           columns_map_file (csv_path): The path for csv with mapping between
               Market scan and FA fields, this csv is expected to have column
               names 'MarketScanColNames' and 'FA<file_type>ColNames' with
               corresponding field names and 'Required' column with 0 for
               optional and 1 for required fields used by the each analytic
               (e.g 'ROHRequired') would be the the column for ROH analytic
           analytic: The analytic to be used. "ROH" for ROH, "PopClass" for
               PopClass.
           file_type: (string) Identifies the type of output file to create
                'Enroll' or 'Pharam'
           include_optional (binary): True if the user wants optional fields to
               be included in the FA mapped csv, False if only required files
               (default False)

       """

    analytic_required = analytic + 'Required'
    fa_col_name = 'FA' + file_type + 'ColNames'
    ms_col_name = 'MarketScanColNames'

    cols_required = pd.Series([ms_col_name, fa_col_name,
                               analytic_required])

    try:
        columns_map = pd.read_csv(columns_map_file, usecols=cols_required,
                                  dtype=str)
    except ValueError:
        raise ValueError('Mapping file does not have expected columns')

    if not include_optional:
        columns_map = columns_map[columns_map[analytic_required] == '1']
    else:
        columns_map = columns_map[(columns_map[analytic_required] == '1') |
                                  (columns_map[analytic_required] == '0')]

    market_scan_cols = columns_map[ms_col_name]

    try:
        data_table = pd.read_csv(market_scan_file, usecols=market_scan_cols,
                                 dtype=str)
    except ValueError:
        raise ValueError('Market Scan Extract does not have expected '
                         'columns')

    columns_dict = columns_map.set_index(ms_col_name).to_dict()[
        fa_col_name]
    data_table.rename(columns=columns_dict, inplace=True)
    data_table.to_csv(output_file, index=False)


def create_fa_inputs_medical(output_path, market_scan_directory, analytic,
                             columns_map_path,
                             admissions=False, include_optional=False,
                             dxver_overwrite=False):
    """
    Create an FA medical input csv file from market scan extracts csv,
    these will be used to mimic client input csv for FA

    Args:
        output_path (csv_path): The output path, where the csv file will be
            saved
        market_scan_directory (directory_path): The path for the directory
        where market scan files are present, they SHOULD follow the below
        naming format
            ccaeo.csv - outpatient services file (required)
            ccaes.csv - inpatient services file (required)
            ccaei.csv - inpatient admissions summary file (optional) - required
            when admissions=True
            ccaef.csv - facility header file (optional) - required
            when facilty=True, when facility=True ccaeo, ccaes, ccaef tables
            SHOULD have a 'FACHDID' column on which the join takes place
        analytic: The analytic to be used. "ROH" for ROH, "PopClass" for
            PopClass
        columns_map_path (csv_path): The path for csv with mapping between
            Market scan and FA fields, this csv is expected to have column
            names 'MarketScanColNames' and 'FAMedicalColNames' with
            corresponding field names and '__Required' column with 0 for
            optional, 1 for required fields used by the each analytic, leave it
            blank if the analytic does not use the field and 'F' if the field
            is used in the facility header table OR to join the facility header
            table
            (e.g 'ROHRequired') would be the the column for ROH analytic
            *** Make sure that ccaeo, ccaes tables do not have any common
            column names with the ccaef table ***
        admissions (binary): True if user wants to output an admissions summary
            table, which is an output from ADM build (default False)
        include_optional (binary): True if the user wants optional fields to
            be included in the FA mapped csv, False if only required files
            (default False)
        dxver_overwrite (binary) : True if DXVER is a variable needed for the
            medical claims or admissions table and the market scan data is
            from years prior to 2015, since ccaeo, ccaes tables prior to 2015
            does not have 'DXVER' variable

    Returns:
        FA_medical_output.csv file in output_path folder with FA formatted
            columns for medical claims

        FA_ADM_output.csv file in output_path folder with admissions summary
            file in FA format, if admissions=TRUE

        """
    analytic_required = analytic + 'Required'
    cols_required = pd.Series(['MarketScanColNames', 'MarketScanTable',
                               'FAMedicalColNames', analytic_required])

    try:
        columns_map = pd.read_csv(columns_map_path, usecols=cols_required,
                                  dtype=str)
    except ValueError:
        raise ValueError('Mapping file does not have expected columns')

    if not include_optional:
        columns_map = columns_map[columns_map[analytic_required] == '1']
    elif include_optional:
        columns_map = columns_map[(columns_map[analytic_required] == '1') |
                                  (columns_map[analytic_required] == '0')]

    if admissions:
        columns_adm = columns_map[columns_map['MarketScanTable'] == 'ccaei']
        adm_path = market_scan_directory + '/ccaei.csv'
        dxver_adm = False
        if dxver_overwrite:
            if columns_adm['MarketScanColNames'].str.contains('DXVER').any():
                columns_adm = columns_adm[
                    columns_adm['MarketScanColNames'] != 'DXVER']
                dxver_adm = True

        market_scan_adm_cols = columns_adm['MarketScanColNames']

        try:
            data_table = pd.read_csv(adm_path,
                                     usecols=market_scan_adm_cols,
                                     dtype=str)
        except ValueError:
            raise ValueError('Market Scan Extract does not have expected '
                             'columns for admissions')

        col_adm_dict = columns_adm.set_index('MarketScanColNames').to_dict()[
            'FAMedicalColNames']

        data_table.rename(columns=col_adm_dict, inplace=True)
        if dxver_adm:
            data_table['icd_flag'] = '9'
        data_table.to_csv(output_path + '/FA_ADM_output.csv', index=False)
        del data_table

    columns_inpatient = columns_map[columns_map['MarketScanTable'] == 'ccaes']
    columns_outpatient = columns_map[columns_map['MarketScanTable'] == 'ccaeo']
    dxver_med = False
    if dxver_overwrite:
        if columns_inpatient['MarketScanColNames'].str.contains('DXVER').any():
            columns_inpatient = columns_inpatient[
                columns_inpatient['MarketScanColNames'] != 'DXVER']
            dxver_med = True
        if columns_outpatient['MarketScanColNames'].str.contains('DXVER').any():
            columns_outpatient = columns_outpatient[
                columns_outpatient['MarketScanColNames'] != 'DXVER']
            dxver_med = True

    market_scan_inpatient_cols = columns_inpatient['MarketScanColNames']
    market_scan_outpatient_cols = columns_outpatient['MarketScanColNames']
    inpatient_path = market_scan_directory + '/ccaes.csv'
    outpatient_path = market_scan_directory + '/ccaeo.csv'

    try:
        data_inpatient = pd.read_csv(inpatient_path,
                                     usecols=market_scan_inpatient_cols,
                                     dtype=str)
    except ValueError:
        raise ValueError('Market Scan Extract does not have expected '
                         'columns for inpatient services')

    try:
        data_outpatient = pd.read_csv(outpatient_path,
                                      usecols=market_scan_outpatient_cols,
                                      dtype=str)
    except ValueError:
        raise ValueError('Market Scan Extract does not have expected '
                         'columns for outpatient services')

    # read in facility data
    columns_facility = columns_map[
        columns_map['MarketScanTable'] == 'ccaef']
    market_scan_fac_cols = columns_facility['MarketScanColNames']
    if not market_scan_fac_cols.str.contains('FACHDID').any():
        raise ValueError('FACHDID column missing in mapping csv')
    facility_path = market_scan_directory + '/ccaef.csv'

    try:
        data_facility = pd.read_csv(facility_path,
                                    usecols=market_scan_fac_cols,
                                    dtype=str)
    except ValueError:
        raise ValueError('Market Scan Extract does not have expected '
                         'columns for facility header')
    data_inpatient = data_inpatient.merge(data_facility,
                                          how='left', on=['FACHDID',
                                                          'ENROLID'])

    data_inpatient.drop('FACHDID', axis=1, inplace=True)
    data_outpatient = data_outpatient.merge(data_facility,
                                            how='left', on=['FACHDID',
                                                            'ENROLID'])
    data_outpatient.drop('FACHDID', axis=1, inplace=True)
    del data_facility
    columns_inpatient = columns_map[
        ((columns_map['MarketScanTable'] == 'ccaes') |
         (columns_map['MarketScanTable'] == 'ccaef')) &
        (columns_map['MarketScanColNames'] != 'FACHDID')]
    columns_outpatient = columns_map[
        ((columns_map['MarketScanTable'] == 'ccaeo') |
         (columns_map['MarketScanTable'] == 'ccaef')) &
        (columns_map['MarketScanColNames'] != 'FACHDID')]

    columns_inpatient_dict = columns_inpatient.set_index(
        'MarketScanColNames').to_dict()['FAMedicalColNames']
    columns_outpatient_dict = columns_outpatient.set_index(
        'MarketScanColNames').to_dict()['FAMedicalColNames']

    data_inpatient.rename(columns=columns_inpatient_dict, inplace=True)
    data_outpatient.rename(columns=columns_outpatient_dict, inplace=True)
    data_inpatient['rec_type'] = 'I'
    data_outpatient['rec_type'] = 'O'
    fa_df = data_inpatient.append(data_outpatient, ignore_index=True)
    if dxver_med:
        fa_df['icd_flag'] = '9'
    if fa_df.columns.str.contains('record_identifier').any():
        fa_df['record_identifier'] = fa_df.index + 1
    del data_inpatient
    del data_outpatient

    # Calculate the Length of Stay (los)
    fa_df['end_date'] = pd.to_datetime(fa_df['end_date'], yearfirst=True, errors='coerce')
    fa_df['svc_date'] = pd.to_datetime(fa_df['svc_date'], yearfirst=True, errors='coerce')
    fa_df['los'] = fa_df['end_date'].sub(fa_df['svc_date'], axis=0)
    fa_df['los'] = fa_df['los'].dt.days
    fa_df['end_date'] = fa_df['end_date'].astype(str).str.replace('-','')
    fa_df['svc_date'] = fa_df['svc_date'].astype(str).str.replace('-','')

    # Change the sex column 1 == M and 2 == F
    fa_df.loc[fa_df['sex'] == '2', 'sex'] = 'F'
    fa_df.loc[fa_df['sex'] == '1', 'sex'] = 'M'


    # Add columns that have no data
    empty_cols = columns_map[columns_map['MarketScanTable'] == \
                             'none']['FAMedicalColNames']
    for i in empty_cols:
        fa_df[i] = ''

    fa_df.to_csv(output_path + '/FA_medical_output.csv', index=False)


if __name__ == '__main__':
    create_fa_inputs_medical(output_path='.',
                             market_scan_directory='.',
                             analytic='PopClass',
                             columns_map_path='mapping_FAmedical_marketscan.csv',
                             include_optional=True,
                             admissions=False,
                             dxver_overwrite=True)
