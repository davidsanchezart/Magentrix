<aspx:AspxPage runat="server" Id="SignUpNewMemberPage" title="<%#CustomLabels.Registration_FormLabel%>">
<body>
    <div class="container">
            <aspx:ViewMessages Runat="server" />
            <div class="max700 registration panel panel-default">
                <div class="registrationForm">
                    <div class="form-heading panel-heading">
                        <h3><%:CustomLabels.Registration_ProvideInformationLabel%></h3>
                    </div>
                    <div class="form-layout panel-body tabPanel">
                        <aspx:LayoutModel runat='server' value='{!Model}' mode='edit' layoutId="Registration New Member"/>
                    </div>
                </div>
                <div class="form-button panel-footer right">
                    <button id="btnRegSubmit" type="button" class="btn btn-primary btn-lg"><%:Resources.Global.Submit%></button>
                </div>
            </div>
    </div>
        
    <style>
        .registration{margin-top:50px;}
    </style>

    <script>
        $(function() {
            $("#btnRegSubmit").click(function() {
                __doPostBack("SubmitSignupNewMember", { showBusy:true });
            });
        });
    </script>
</body>
</aspx:AspxPage>
