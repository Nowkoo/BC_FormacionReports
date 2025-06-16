table 60352 "Report Parameters"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ReportId; Integer)
        {
            DataClassification = ToBeClassified;

        }
        field(2; UserId; Code[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; Parameters; Blob)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Pk; ReportId, UserId)
        {

        }
    }
}