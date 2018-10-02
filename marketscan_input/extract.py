from mktscan_to_fa import create_fa_inputs_medical

create_fa_inputs_medical(output_path='/Users/ronakdpatel/Desktop/mktscan',
                         market_scan_directory='/Users/ronakdpatel/Desktop/mktscan',
                         analytic='PopClass',
                         columns_map_path='/Users/ronakdpatel/Desktop/mktscan/mapping_FAmedical_marketscan.csv',
                         include_optional=True, admissions=True,
                         dxver_overwrite=True)

