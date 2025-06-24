report 60352 "Grouped Orders V2"
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

            trigger OnPreDataItem()
            begin
                TempSalesHeaderBuffer.Reset();
                TempSalesHeaderBuffer.DeleteAll();
            end;

            trigger OnAfterGetRecord()
            var
                SalesPost: Codeunit "Sales-Post";
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

            //COMPANY
            column(CompanyAddress1; CompanyAddr[1])
            {
            }
            column(CompanyAddress2; CompanyAddr[2])
            {
            }
            column(CompanyAddress3; CompanyAddr[3])
            {
            }
            column(CompanyAddress4; CompanyAddr[4])
            {
            }
            column(CompanyAddress5; CompanyAddr[5])
            {
            }
            column(CompanyAddress6; CompanyAddr[6])
            {
            }
            column(CompanyAddress7; CompanyAddr[7])
            {
            }
            column(CompanyAddress8; CompanyAddr[8])
            {
            }

            column(CompanyHomePage; CompanyInfo."Home Page")
            {
            }
            column(CompanyEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(CompanyPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyVATRegistrationNo; CompanyInfo.GetVATRegistrationNumber())
            {
            }

            //SELL TO
            column(CustomerAddress1; CustAddr[1])
            {
            }
            column(CustomerAddress2; CustAddr[2])
            {
            }
            column(CustomerAddress3; CustAddr[3])
            {
            }
            column(CustomerAddress4; CustAddr[4])
            {
            }
            column(CustomerAddress5; CustAddr[5])
            {
            }
            column(CustomerAddress6; CustAddr[6])
            {
            }
            column(CustomerAddress7; CustAddr[7])
            {
            }
            column(CustomerAddress8; CustAddr[8])
            {
            }
            column(SellToContactPhoneNo; SellToContact."Phone No.")
            {
            }
            column(SellToContactMobilePhoneNo; SellToContact."Mobile Phone No.")
            {
            }
            column(SellToContactEmail; SellToContact."E-Mail")
            {
            }
            column(VATRegistrationNo; TempSalesHeaderBuffer.GetCustomerVATRegistrationNumber())
            {
            }

            //SHIP TO
            column(ShipToAddress1; ShipToAddr[1])
            {
            }
            column(ShipToAddress2; ShipToAddr[2])
            {
            }
            column(ShipToAddress3; ShipToAddr[3])
            {
            }
            column(ShipToAddress4; ShipToAddr[4])
            {
            }
            column(ShipToAddress5; ShipToAddr[5])
            {
            }
            column(ShipToAddress6; ShipToAddr[6])
            {
            }
            column(ShipToAddress7; ShipToAddr[7])
            {
            }
            column(ShipToAddress8; ShipToAddr[8])
            {
            }
            column(ShipmentDate; Format(TempSalesHeaderBuffer."Shipment Date", 0, 4))
            {
            }
            column(ShipToPhoneNo; TempSalesHeaderBuffer."Ship-to Phone No.")
            {
            }

            //DOCUMENT
            column(DocumentDate; Format(TempSalesHeaderBuffer."Document Date", 0, 4))
            {
            }
            column(Document_No; FormatNos(TempSalesHeaderBuffer."Operation Description 2"))
            {

            }
            column(Document_Type; TempSalesHeaderBuffer."Document Type")
            {

            }

            column(Document_Date; TempSalesHeaderBuffer."Document Date")
            {

            }
            column(Payment_Method; TempSalesHeaderBuffer."Payment Method Code")
            {

            }
            column(PaymentMethodDescription; PaymentMethod.Description)
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
                var
                    NextLineNo: Integer;
                begin
                    TempSalesLineBuffer.SetFilter("Document No.", TempSalesHeaderBuffer."No.");
                    if TempSalesLineBuffer.FindLast() then
                        NextLineNo := TempSalesLineBuffer."Line No." + 10000
                    else
                        NextLineNo := 10000;

                    if not TempSalesLineBuffer.Get("Document Type"::Order, SalesLine."Document No.", SalesLine."Line No.") then begin
                        TempSalesLineBuffer := SalesLine;
                        TempSalesLineBuffer."Document No." := TempSalesHeaderBuffer."No.";
                        TempSalesLineBuffer."Line No." := NextLineNo;
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
                column(Description; TempSalesLineBuffer.Description)
                {

                }
                column(Quantity; TempSalesLineBuffer.Quantity)
                {

                }
                column(Unit_of_Measure_Code; TempSalesLineBuffer."Unit of Measure Code")
                {

                }
                column(Unit_of_Measure; TempSalesLineBuffer."Unit of Measure")
                {

                }
                column(Unit_Price; TempSalesLineBuffer."Unit Price")
                {

                }
                column(Line_Discount_Pct; TempSalesLineBuffer."Line Discount %")
                {

                }
                column(Amount; TempSalesLineBuffer.Amount)
                {

                }
                column(Line_Discount_Amount; TempSalesLineBuffer."Line Discount Amount")
                {

                }
                column(Line_VAT_Pct; TempSalesLineBuffer."VAT %")
                {

                }
                column(Amount_Including_VAT; TempSalesLineBuffer."Amount Including VAT")
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

                    TotalQuantity += TempSalesLineBuffer.Quantity;
                    TotalDiscountAmount += TempSalesLineBuffer."Line Discount Amount";
                    TotalAmountExcludingVAT += TempSalesLineBuffer.Amount;
                end;
            }

            dataitem(VATAmountLine; "VAT Amount Line")
            {
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;

                column(VAT_Identifier; "VAT Identifier")
                {

                }

                column(VAT_Base; "VAT Base")
                {

                }

                column(VAT_Pct; "VAT %")
                {

                }
                column(EC_Pct; "EC %")
                {

                }
                column(VAT_Amount; "VAT Amount")
                {

                }
                column(EC_Amount; "EC Amount")
                {

                }

                trigger OnPreDataItem()
                var
                    SalesHeader: Record "Sales Header" temporary;

                begin
                    VATAmountLine.DeleteAll();
                    TempSalesLineBuffer.CalcVATAmountLines(0, TempSalesHeaderBuffer, TempSalesLineBuffer, VATAmountLine);
                    TempSalesLineBuffer.UpdateVATOnLines(0, TempSalesHeaderBuffer, TempSalesLineBuffer, VATAmountLine);
                end;

                trigger OnAfterGetRecord()
                begin
                    TotalVATBase += VATAmountLine."VAT Base";
                    TotalVATAmount += VATAmountLine."VAT Amount";
                    TotalAmountIncludingVAT += VATAmountLine."Amount Including VAT";
                end;
            }

            dataitem(Totals; Integer)
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(TotalVATBaseAmount; TotalVATBase)
                {

                }
                column(TotalVATAmounts; TotalVATAmount)
                {

                }
                column(TotalAmountIncludingVAT; TotalAmountIncludingVAT)
                {

                }
                column(TotalQuantity; TotalQuantity)
                {

                }
                column(TotalDiscountAmount; TotalDiscountAmount)
                {

                }
                column(TotalAmountExcludingVAT; TotalAmountExcludingVAT)
                {

                }
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

                FormatAddr.GetCompanyAddr(TempSalesHeaderBuffer."Responsibility Center", RespCenter, CompanyInfo, CompanyAddr);
                FormatAddr.SalesHeaderBillTo(CustAddr, TempSalesHeaderBuffer);
                FormatAddr.SalesHeaderShipTo(ShipToAddr, CustAddr, TempSalesHeaderBuffer);
                if SellToContact.Get(TempSalesHeaderBuffer."Sell-to Contact No.") then;
                FormatDocument.SetPaymentMethod(PaymentMethod, TempSalesHeaderBuffer."Payment Method Code", TempSalesHeaderBuffer."Language Code");
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

    labels
    {
        CompanyInformationLbl = 'Company information';
        ShippingAddressLbl = 'Shipping address';
        DocumentLbl = 'Document';
        NumberLbl = 'Number';
        DateLbl = 'Date';
        PaymentMethodLbl = 'Payment Method';
        CustomerLbl = 'Customer';
        BillingAddressLbl = 'Billing address';
        LineNoLbl = 'Code';
        LineDescriptionLbl = 'Description';
        LineQuantityLbl = 'Cantidad';
        LinePriceLbl = 'Price';
        LineDiscountPercentageLbl = 'Discount %';
        LineAmountIncludingVATLbl = 'Amount including VAT';
        LineDiscountLbl = 'Discount';
        LineAmountLbl = 'Amount';
        VATLbl = 'VAT';
        TotalQuantityLbl = 'Total quantity';
        TotalDiscountLbl = 'Total discount';
        TotalAmountLbl = 'Total amount';
        VATBaseAmountLbl = 'VAT base amount';
        VATAmountLbl = 'VAT amount';
        VATPercentageLbl = 'VAT %';
        ECPercentageLbl = 'EC %';
        ECAmountLbl = 'EC Amount';
        TotalVATBaseAmountLbl = 'Total VAT base amount';
        TotalVATAmountLbl = 'Total VAT amount';
        TotalAmountIncludingVATLbl = 'Total amount including VAT';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.SetAutoCalcFields(Picture);
        CompanyInfo.Get();
    end;

    local procedure FormatNos(NoFilter: Text): Text
    var
        Character: Text;

    begin
        exit(NoFilter.Replace('|', ', '));

    end;

    var
        TempSalesHeaderBuffer: Record "Sales Header" temporary;
        TempSalesLineBuffer: Record "Sales Line" temporary;
        CompanyInfo: Record "Company Information";
        RespCenter: Record "Responsibility Center";
        SellToContact: Record Contact;
        PaymentMethod: Record "Payment Method";
        FormatAddr: Codeunit "Format Address";
        FormatDocument: Codeunit "Format Document";
        CompanyAddr: array[8] of Text[100];
        ShipToAddr: array[8] of Text[100];
        CustAddr: array[8] of Text[100];
        TotalVATBase: Decimal;
        TotalVATAmount: Decimal;
        TotalAmountIncludingVAT: Decimal;
        TotalQuantity: Integer; //suma Quantity
        TotalDiscountAmount: Decimal; //suma Line Discount Amount
        TotalAmountExcludingVAT: Decimal; //suma de Amount
}
