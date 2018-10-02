import pandas as pd

def convert_dateformat_in_enrollment_file(input_enrollment_file):
	data_frame = pd.read_csv(input_enrollment_file, dtype=str)
        data_frame['ext_date'] = pd.to_datetime(data_frame['ext_date'], yearfirst=True, errors='coerce')
        data_frame['effective_from_date'] = pd.to_datetime(data_frame['effective_from_date'], yearfirst=True, errors='coerce')
        data_frame['ext_date'] = data_frame['ext_date'].astype(str).str.replace('-','')
        data_frame['effective_from_date'] = data_frame['effective_from_date'].astype(str).str.replace('-','')              	
	data_frame.to_csv('FA__output_enrollment_file.csv', index=False)
	
def convert_dateformat_in_pharmacy_file(input_pharmacy_file):
	data_frame = pd.read_csv(input_pharmacy_file, dtype=str)
        data_frame['claim_date'] = pd.to_datetime(data_frame['claim_date'], yearfirst=True, errors='coerce')
        data_frame['claim_date'] = data_frame['claim_date'].astype(str).str.replace('-','')        	
	data_frame.to_csv('FA__output_pharmacy_file.csv', index=False)
