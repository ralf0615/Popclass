from pyspark.sql.types import (StructType, StructField, StringType)
from popclass.cast_dtypes import cast_dtypes


def test_no_defined_schema(spark_session):
    """
    Args:
        spark_session: spark session

    Returns:
        assert True for each column type in base data
    """
    data = [(501, 'Z3800', '49392', 0, 'E0424'),
            (502, 'M5022', '7862', 0, 'E0483'),
            (503, '51882', 'J0325', 0, 'A4619'),
            (504, '49320', '5589', 0, 'K0741'),
            (505, 'D440', '25013', 0, 'C1300')]

    schema = ['patient_id', 'dx1', 'dx2', 'icd_flag', 'proc_code']
    base_data = spark_session.createDataFrame(data=data, schema=schema)

    tst = cast_dtypes(base_data)

    assert isinstance(tst.schema['patient_id'].dataType, StringType)
    assert isinstance(tst.schema['dx1'].dataType, StringType)
    assert isinstance(tst.schema['dx2'].dataType, StringType)
    assert isinstance(tst.schema['icd_flag'].dataType, StringType)
    assert isinstance(tst.schema['proc_code'].dataType, StringType)

def test_defined_schema(spark_session):
    """
    Args:
        spark_session: spark session

    Returns:
        assert True for each column type in base data
    """
    data = [(501, 'Z3800', '49392', 0, 'E0424'),
            (502, 'M5022', '7862', 0, 'E0483'),
            (503, '51882', 'J0325', 0, 'A4619'),
            (504, '49320', '5589', 0, 'K0741'),
            (505, 'D440', '25013', 0, 'C1300')]

    schema_v2 = StructType([
        StructField('patient_id', StringType()),
        StructField('dx1', StringType()),
        StructField('dx2', StringType()),
        StructField('icd_flag', StringType()),
        StructField('proc_code', StringType())
        ])

    base_data_v2 = spark_session.createDataFrame(data=data, schema=schema_v2)

    tst_v2 = cast_dtypes(base_data_v2)

    assert isinstance(tst_v2.schema['patient_id'].dataType, StringType)
    assert isinstance(tst_v2.schema['dx1'].dataType, StringType)
    assert isinstance(tst_v2.schema['dx2'].dataType, StringType)
    assert isinstance(tst_v2.schema['icd_flag'].dataType, StringType)
    assert isinstance(tst_v2.schema['proc_code'].dataType, StringType)
