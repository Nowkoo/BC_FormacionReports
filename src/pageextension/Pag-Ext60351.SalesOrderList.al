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
                    XmlParameters: Text;
                begin
                    //ReportMgmt.Run();
                    XmlParameters := Report.RunRequestPage(Report::"Grouped Orders V3");
                    Report.Execute(Report::"Grouped Orders V3", XmlParameters);
                end;
            }
        }
    }

    var
        myInt: Integer;
}