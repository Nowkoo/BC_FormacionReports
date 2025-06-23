//https://harikiran-in-nav.blogspot.com/2020/01/why-and-when-do-we-need-to-use-integer.html

report 60351 "Daily Customer Order Report"
{
    Caption = 'Daily Customer Order Report';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultRenderingLayout = CustomInvoiceWord;

    dataset
    {
        dataitem(CompanyInfo; "Company Information")
        {
            DataItemTableView = sorting("Primary Key");

            column(Name; Name) { }
            column(Name_2; "Name 2")
            {

            }
            column(Address; Address)
            {

            }
            column(Address_2; "Address 2")
            {

            }
            column(City; City)
            {

            }
            column(Post_Code; "Post Code")
            {

            }
            column(Country_Region_Code; "Country/Region Code")
            {

            }
            column(VAT_Registration_No_; "VAT Registration No.")
            {

            }
        }

        dataitem(IntegerHeaders; Integer)
        {
            DataItemTableView = sorting(Number);

            column(Sell_To_CustomerName; TemporaryHeaderValues."Sell-to Customer Name")
            {

            }

            column(Sell_To_CustomerName_2; TemporaryHeaderValues."Sell-to Customer Name 2")
            {

            }

            column(Sell_To_Phone_Number; TemporaryHeaderValues."Sell-to Phone No.")
            {

            }

            column(Sell_To_Address; TemporaryHeaderValues."Sell-to Address")
            {

            }
            column(Sell_To_Address2; TemporaryHeaderValues."Sell-to Address 2")
            {

            }
            column(Sell_To_City; TemporaryHeaderValues."Sell-to City")
            {

            }
            column(Sell_To_Post_Code; TemporaryHeaderValues."Sell-to Post Code")
            {

            }
            column(Sell_To_Country_Region_Code; TemporaryHeaderValues."Sell-to Country/Region Code")
            {

            }

            column(Bill_To_Name; TemporaryHeaderValues."Bill-to Name")
            {

            }

            column(Bill_To_Name_2; TemporaryHeaderValues."Bill-to Name 2")
            {

            }

            column(Bill_To_Address; TemporaryHeaderValues."Bill-to Address")
            {

            }
            column(Bill_To_Address_2; TemporaryHeaderValues."Bill-to Address 2")
            {

            }
            column(Bill_To_City; TemporaryHeaderValues."Bill-to City")
            {

            }
            column(Bill_To_Post_Code; TemporaryHeaderValues."Bill-to Post Code")
            {

            }
            column(Bill_To_Country_Region_Code; TemporaryHeaderValues."Bill-to Country/Region Code")
            {

            }

            column(Ship_To_CustomerName; TemporaryHeaderValues."Ship-to Name")
            {

            }

            column(Ship_To_CustomerName_2; TemporaryHeaderValues."Ship-to Name 2")
            {

            }

            column(Ship_To_Phone_Number; TemporaryHeaderValues."Ship-to Phone No.")
            {

            }

            column(Ship_To_Address; TemporaryHeaderValues."Ship-to Address")
            {

            }
            column(Ship_To_Address2; TemporaryHeaderValues."Ship-to Address 2")
            {

            }
            column(Ship_To_City; TemporaryHeaderValues."Ship-to City")
            {

            }
            column(Ship_To_Post_Code; TemporaryHeaderValues."Ship-to Post Code")
            {

            }
            column(Ship_To_Country_Region_Code; TemporaryHeaderValues."Ship-to Country/Region Code")
            {

            }

            column(Document_No; TemporaryHeaderValues."No.")
            {

            }
            column(Document_Type; TemporaryHeaderValues."Document Type")
            {

            }

            column(Document_Date; TemporaryHeaderValues."Document Date")
            {

            }
            column(Payment_Method; TemporaryHeaderValues."Payment Method Code")
            {

            }
            column(Salesperson_Code; TemporaryHeaderValues."Salesperson Code")
            {

            }

            trigger OnPreDataItem()
            begin
                FillTemporaryHeaders();
                CountAmount := TemporaryHeaderValues.Count;
                SetRange(Number, 1, CountAmount);
            end;

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    TemporaryHeaderValues.FindFirst()
                else
                    TemporaryHeaderValues.Next();
            end;
        }

        dataitem(IntegerLines; Integer)
        {
            DataItemTableView = sorting(Number);

            column(ItemNo; TemporaryLineValues."No.")
            {

            }
            column(Description; TemporaryLineValues.Description)
            {

            }
            column(Quantity; TemporaryLineValues.Quantity)
            {

            }
            column(Unit_of_Measure_Code; TemporaryLineValues."Unit of Measure Code")
            {

            }
            column(Unit_of_Measure; TemporaryLineValues."Unit of Measure")
            {

            }
            column(Unit_Price; TemporaryLineValues."Unit Price")
            {

            }
            column(Line_Discount_Pct; TemporaryLineValues."Line Discount %")
            {

            }
            column(Amount; TemporaryLineValues.Amount)
            {

            }
            column(Line_Discount_Amount; TemporaryLineValues."Line Discount Amount")
            {

            }
            column(VAT_Pct; TemporaryLineValues."VAT %")
            {

            }
            column(Amount_Including_VAT; TemporaryLineValues."Amount Including VAT")
            {

            }

            trigger OnPreDataItem()
            begin

                FillTemporaryLines();
                CountAmount := TemporaryLineValues.Count;
                SetRange(Number, 1, CountAmount);
            end;

            trigger OnAfterGetRecord()
            var
                VATAmount: Decimal;
            begin
                if Number = 1 then
                    TemporaryLineValues.FindFirst()
                else
                    TemporaryLineValues.Next();

                //ir añadiendo a los totales
                TotalQuantity += TemporaryLineValues.Quantity;
                TotalDiscountAmount += TemporaryLineValues."Line Discount Amount";
                TotalAmountExcludingVAT += TemporaryLineValues.Amount;

                VATAmount := TemporaryLineValues."Amount Including VAT" - TemporaryLineValues."VAT Base Amount";
                if not TemporaryVATValues.Get(TemporaryLineValues."VAT Identifier") then begin
                    TemporaryVATValues.Init();
                    TemporaryVATValues.Code := TemporaryLineValues."VAT Identifier";
                    TemporaryVATValues.VATPct := TemporaryLineValues."VAT %";
                    TemporaryVATValues.ECPct := TemporaryLineValues."EC %";
                    TemporaryVATValues.Insert();
                end;

                TemporaryVATValues.VATBaseAmount += TemporaryLineValues."VAT Base Amount";
                TemporaryVATValues.VATAmount += VATAmount;
                TemporaryVATValues.ECDifference += TemporaryLineValues."EC Difference";
                TemporaryVATValues.Modify();
            end;
        }

        dataitem(IntegerVATValues; Integer)
        {
            DataItemTableView = sorting(Number);

            column(Code; TemporaryVATValues.Code)
            {

            }
            column(VATBaseAmount; TemporaryVATValues.VATBaseAmount)
            {

            }
            column(VATPct; TemporaryVATValues.VATPct)
            {

            }
            column(VATAmount; TemporaryVATValues.VATAmount)
            {

            }
            column(ECPct; TemporaryVATValues.ECPct)
            {

            }
            column(ECDifference; TemporaryVATValues.ECDifference)
            {

            }

            trigger OnPreDataItem()
            begin

                CountAmount := TemporaryVATValues.Count;
                SetRange(Number, 1, CountAmount);
            end;

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    TemporaryVATValues.FindFirst()
                else
                    TemporaryVATValues.Next();
            end;
        }

        dataitem(Totals; "Integer")
        {
            DataItemTableView = sorting(Number) where(Number = const(1));
            column(TotalQuantity; TotalQuantity)
            {
            }
            column(TotalDiscountAmount; TotalDiscountAmount)
            {
            }
            column(TotalAmount; TotalAmountExcludingVAT)
            {
            }
            column(TotalVATBaseAmount; TotalVATBaseAmount)
            {
            }
            column(TotalVATAmount; TotalVATAmount)
            {
            }
            column(TotalAmountIncludingVAT; TotalAmountIncludingVAT)
            {
            }

            trigger OnPreDataItem()
            var
                AmountIncludingVAT: Decimal;
            begin
                if TemporaryVATValues.FindSet() then
                    repeat
                        TotalVATBaseAmount += TemporaryVATValues.VATBaseAmount;
                        TotalVATAmount += TemporaryVATValues.VATAmount;
                        AmountIncludingVAT := TotalVATBaseAmount + TotalVATAmount;
                        TotalAmountIncludingVAT += AmountIncludingVAT;
                    until TemporaryVATValues.Next() = 0;
            end;
        }
    }


    requestpage
    {
        AboutTitle = 'Teaching tip title';
        AboutText = 'Teaching tip content';
        SaveValues = true;

        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    Caption = 'Filter by Customer and Date';
                    field(SelectedCustomer; SelectedCustomer)
                    {
                        ApplicationArea = All;
                        Caption = 'Customer';
                        TableRelation = Customer;
                    }
                    field(SelectedDate; SelectedDate)
                    {
                        ApplicationArea = All;
                        Caption = 'Date';
                    }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(LayoutName)
                {

                }
            }
        }
    }

    rendering
    {
        layout(CustomInvoiceWord)
        {
            Type = Word;
            LayoutFile = 'CustomInvoice.docx';
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

    end;

    local procedure FillTemporaryHeaders()
    var
        SalesHeader: Record "Sales Header";
    begin
        TemporaryHeaderValues.DeleteAll();

        SalesHeader.SetRange("Sell-to Customer No.", SelectedCustomer);
        SalesHeader.SetRange("Document Date", SelectedDate);
        SalesHeader.SetRange("Document Type", TemporaryHeaderValues."Document Type"::Order);

        if SalesHeader.FindSet() then
            repeat
                TemporaryHeaderValues := SalesHeader;
                TemporaryHeaderValues.Insert();


            until SalesHeader.Next() = 0;

    end;

    local procedure FillTemporaryLines()
    var
        SalesLine: Record "Sales Line";
        RepeatedSalesLine: Record "Sales Line";
    begin
        TemporaryLineValues.DeleteAll();

        if TemporaryHeaderValues.FindSet() then
            repeat
                SalesLine.SetRange("Document No.", TemporaryHeaderValues."No.");
                SalesLine.SetRange("Document Type", SalesLine."Document Type"::Order);
                if SalesLine.FindSet() then
                    repeat
                        TemporaryLineValues := SalesLine;
                        TemporaryLineValues.Insert();
                    until SalesLine.Next() = 0;
            until TemporaryHeaderValues.Next() = 0;

        //GroupLines(TemporaryLineValues);
    end;

    local procedure GroupLines(var TemporaryLineValues: Record "Sales Line")
    var
        GroupedLines: Record "Sales Line" temporary;
    begin
        if TemporaryLineValues.FindSet() then
            repeat
                if GroupedLines.FindSet() then
                    repeat
                        if not IsSameSalesLine(TemporaryLineValues, GroupedLines) then begin
                            if IsSameGroup(TemporaryLineValues, GroupedLines) then begin
                                GroupedLines.Quantity += TemporaryLineValues.Quantity;
                                GroupedLines."Line Discount Amount" += TemporaryLineValues."Line Discount Amount";
                                GroupedLines.Amount += TemporaryLineValues.Amount;
                                GroupedLines."Amount Including VAT" += TemporaryLineValues."Amount Including VAT";
                                GroupedLines.Modify();
                            end
                            else begin
                                GroupedLines.TransferFields(TemporaryLineValues);
                                GroupedLines.Insert();
                            end;
                        end;
                    until GroupedLines.Next() = 0;
            until TemporaryLineValues.Next() = 0;

        TemporaryLineValues.Reset();
        if GroupedLines.FindSet() then
            repeat
                TemporaryLineValues.TransferFields(GroupedLines);
                TemporaryLineValues.Insert();
            until GroupedLines.Next() = 0;
    end;

    local procedure IsSameGroup(SalesLine1: Record "Sales Line"; SalesLine2: Record "Sales Line"): Boolean
    begin
        exit((SalesLine1."No." = SalesLine2."No.") and (SalesLine1."Line Discount %" = SalesLine2."Line Discount %") and (SalesLine1."VAT %" = SalesLine2."VAT %"))
    end;

    local procedure IsSameSalesLine(SalesLine1: Record "Sales Line"; SalesLine2: Record "Sales Line"): Boolean
    begin
        exit((SalesLine1."Document Type" = SalesLine2."Document Type") and (SalesLine1."Document No." = SalesLine2."Document No.") and (SalesLine1."Line No." = SalesLine2."Line No."))
    end;


    protected var
        TemporaryHeaderValues: Record "Sales Header" temporary;
        TemporaryLineValues: Record "Sales Line" temporary;
        TemporaryVATValues: Record "Temporary VAT Values";
        SelectedCustomer: Code[20];
        SelectedDate: Date;
        LanguageMgt: Codeunit Language;
        CountAmount: Integer;
        PaymentMethodDescription: Text[100];
        TotalQuantity: Integer; //suma Quantity
        TotalDiscountAmount: Decimal; //suma Line Discount Amount
        TotalAmountExcludingVAT: Decimal; //suma de Amount
        TotalVATBaseAmount: Decimal;
        TotalVATAmount: Decimal;
        TotalAmountIncludingVAT: Decimal;
}