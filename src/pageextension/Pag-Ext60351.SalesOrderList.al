pageextension 60351 "Sales Order List" extends "Sales Order List"
{
    layout
    {
        // Add changes to page layout here
    }

    actions
    {
        addafter(Action12)
        {
            action(DailyOrders)
            {
                ApplicationArea = All;
                Caption = 'Daily Orders';
                Image = Report;

                trigger OnAction()
                var
                    //XmlParameters: Text;
                    ReportMgmt: Codeunit "Report Mgmt";
                begin
                    //XmlParameters := Report.RunRequestPage(Report::"Report Mix");
                    ReportMgmt.Run();
                end;
            }
        }
    }

    var
        myInt: Integer;
}