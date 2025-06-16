//https://learn.microsoft.com/en-us/dynamics365/business-central/dev-itpro/developer/methods-auto/report/report-runrequestpage-method
codeunit 60351 "Report Mgmt"
{
    trigger OnRun()
    var
        ReportParameters: Record "Report Parameters";
        XmlParameters: Text;
        OStream: OutStream;
        IStream: InStream;
        CurrentUser: Code[100];
        Content: File;
        TempFileName: Text;
        TempBlob: Codeunit "Temp Blob";
    begin
        // Use the Report.RunRequestPage method to run the request page to get report parameters  
        XmlParameters := Report.RunRequestPage(Report::"Daily Customer Order Report");
        CurrentUser := UserId;

        // Save the request page parameters to the database table  
        if ReportParameters.Get(60351, CurrentUser) then
            ReportParameters.Delete();

        ReportParameters.SetAutoCalcFields(Parameters);
        ReportParameters.ReportId := 60351;
        ReportParameters.UserId := CurrentUser;
        ReportParameters.Parameters.CreateOutStream(OStream, TextEncoding::UTF8);
        OStream.WriteText(XmlParameters);

        ReportParameters.Insert();

        Clear(ReportParameters);
        XmlParameters := '';

        // Read the request page parameters from the database table  
        ReportParameters.SetAutoCalcFields(Parameters);
        ReportParameters.Get(60351, CurrentUser);
        ReportParameters.Parameters.CreateInStream(IStream, TextEncoding::UTF8);
        IStream.ReadText(XmlParameters);

        // Use the Report.SaveAs method to save the report as a PDF file  
        //Report.SaveAs(Report::"Report Mix", XmlParameters, ReportFormat::Pdf, OStream);

        // Use the Report.Execute method to preview the report  
        //Report.Execute(Report::"Report Mix", XmlParameters);

        // Use the Report.Print method to print the report  
        Report.Print(Report::"Daily Customer Order Report", XmlParameters);
    end;
}