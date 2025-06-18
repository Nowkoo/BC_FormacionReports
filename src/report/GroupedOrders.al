report 60352 "Grouped Orders"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = GroupedOrder;
    WordMergeDataItem = IntegerHeader;

    dataset
    {
        dataitem(SalesHeader; "Sales Header")
        {
            RequestFilterFields = "Document Date";
            PrintOnlyIfDetail = true;
            DataItemTableView = where("Document Type" = const(Order));

            /* column(ColumnName; SourceFieldName)
            {

            } */

            trigger OnPreDataItem()
            begin
                TempSalesHeaderBuffer.Reset();
                TempSalesHeaderBuffer.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            begin
                TempSalesHeaderBuffer.SetRange("No.", SalesHeader."Sell-to Customer No.");
                if not TempSalesHeaderBuffer.FindFirst() then begin
                    //TempSalesHeaderBuffer.Init();
                    TempSalesHeaderBuffer := SalesHeader;
                    TempSalesHeaderBuffer."No." := SalesHeader."Sell-to Customer No.";
                    TempSalesHeaderBuffer."Operation Description 2" := SalesHeader."No.";
                    TempSalesHeaderBuffer.Insert();
                end else begin
                    TempSalesHeaderBuffer."Operation Description 2" += '|' + SalesHeader."No.";
                    TempSalesHeaderBuffer.Modify();
                end;
            end;
        }

        dataitem(IntegerHeader; Integer)
        {
            DataItemTableView = sorting(Number);

            column(CustomerNo; TempSalesHeaderBuffer."No.")
            {

            }

            dataitem(SalesLine; "Sales Line")
            {
                DataItemTableView = where("Document Type" = const(Order));

                trigger OnPreDataItem()
                begin
                    SalesLine.SetFilter("Document No.", TempSalesHeaderBuffer."Operation Description 2");
                    TempSalesLineBuffer.Reset();
                    TempSalesLineBuffer.DeleteAll();
                end;

                trigger OnAfterGetRecord()
                begin
                    if not TempSalesLineBuffer.Get("Document Type"::Order, SalesLine."Document No.", SalesLine."Line No.") then begin
                        TempSalesLineBuffer := SalesLine;
                        TempSalesLineBuffer.Insert();
                    end
                end;
            }

            dataitem(IntegerLine; Integer)
            {
                DataItemTableView = sorting(Number);

                column(ItemNo; TempSalesLineBuffer."No.")
                {

                }

                trigger OnPreDataItem()
                begin
                    TempSalesLineBuffer.Reset();
                    SetRange(Number, 1, TempSalesLineBuffer.Count);
                end;

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempSalesLineBuffer.FindFirst()
                    else
                        TempSalesLineBuffer.Next();
                end;
            }

            trigger OnPreDataItem()
            begin
                TempSalesHeaderBuffer.Reset();
                SetRange(Number, 1, TempSalesHeaderBuffer.Count);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TempSalesHeaderBuffer.FindFirst()
                else
                    TempSalesHeaderBuffer.Next();
            end;
        }
    }

    rendering
    {
        layout(GroupedOrder)
        {
            Type = Word;
            LayoutFile = 'GroupedOrder.docx';
        }
    }

    var
        TempSalesHeaderBuffer: Record "Sales Header" temporary;
        TempSalesLineBuffer: Record "Sales Line" temporary;
}