<aspx:AspxPage runat="server" Id="NewPartnerEmployeePage" title="<%#CustomLabels.Registration_FormLabel%>">
<body>
    <div class="container">
        <aspx:ViewMessages Runat="server" />
            <div class="max700 registration panel panel-default">
                <div class="registrationForm">
                    <div class="form-heading panel-heading">
                        <h3><%:CustomLabels.Registration_ProvideInformationLabel%></h3>
                    </div>
                    <div class="form-layout panel-body tabPanel">
                        <div class="create-contact" runat="server" visible="<%# !Bool(DataBag.CreateLeads)%>">
                            <aspx:LayoutModel runat='server' value='{!Model}' mode='edit' layoutId="Registration Existing Member"/>
                        </div>
                        
                        <div class="create-lead" runat="server" visible="<%# Bool(DataBag.CreateLeads)%>">
                           <aspx:LayoutModel runat='server' value='{!Model}' mode='edit' layoutId="Registration Existing Member"/>
                        </div>
                    </div>
                </div>
                <div class="form-button panel-footer right">
                    <button id="btnRegSubmit" type="button" class="btn btn-primary btn-lg"><%:Resources.Global.Submit%></button>
                </div>
        </div>
    </div>
    <input type="hidden" id="createLead" name="createLead" value='<%# Bool(DataBag.CreateLeads) %>'/>
        
    <script>
        $(function() {
            $("#btnRegSubmit").click(function() {
                var recordType= $("#createLead").val();
                if (recordType=="True")
                    __doPostBack("SubmitSignupExistingLead", { showBusy:true });
                else
                    __doPostBack("SubmitSignupExistingContant", { showBusy:true });
            });
        });
    </script>
    <style>
        .registration{margin-top:50px;}
    </style>
</body>
</aspx:AspxPage>
