from mktscan_to_fa import create_fa_inputs
from dateformat_conversion import convert_dateformat_in_enrollment_file
from dateformat_conversion import convert_dateformat_in_pharmacy_file

create_fa_inputs(output_file='/Users/ronakdpatel/Desktop/mktscan/fa_pharmacy.csv',
                 market_scan_file='/Users/ronakdpatel/Desktop/mktscan/ccaed.csv',
                 columns_map_file='/Users/ronakdpatel/Desktop/mktscan/mapping_FApharmacy_marketscan.csv',
                 analytic='PopClass',
                 file_type='Pharma') 
                 
create_fa_inputs(output_file='/Users/ronakdpatel/Desktop/mktscan/fa_enrollment.csv',
                 market_scan_file='/Users/ronakdpatel/Desktop/mktscan/combineddata.csv',
                 columns_map_file='/Users/ronakdpatel/Desktop/mktscan/mapping_FAenrollment_marketscan.csv',
                 analytic='PopClass',
                 file_type='Enroll') 
                 
convert_dateformat_in_enrollment_file(input_enrollment_file='/Users/ronakdpatel/Desktop/mktscan/fa_enrollment.csv') 

convert_dateformat_in_pharmacy_file(input_pharmacy_file='/Users/ronakdpatel/Desktop/mktscan/fa_pharmacy.csv')                