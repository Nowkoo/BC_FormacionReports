table 60353 "Temporary VAT Values"
{
    DataClassification = CustomerContent;
    TableType = Temporary;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = CustomerContent;
        }
        field(2; VATBaseAmount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(3; VATPct; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(4; VATAmount; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(5; ECPct; Decimal)
        {
            DataClassification = CustomerContent;
        }
        field(6; ECDifference; Decimal)
        {
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }
}