<aspx:AspxPage runat="server" Id="MyNewPage" title="<%#CustomLabels.Registration_SettingControlPanel%>">
<body>
    <div style="max-width:800px;">
        <div class="container-fluid">
            <h3>
                <%:CustomLabels.Registration_SettingControlPanel%>
            </h3>
        </div>
        <aspx:ViewMessages Runat="server" />
        <aspx:ViewSection runat='server' columns='one' showHeader='false' labelPosition='top'>
            <aspx:InputField runat='server' value='{!Model.CheckContactByEmail}' hint="Check contacts by email and if only one matching contact is found within the CRM, the contact will be activated as a user."/>
            <aspx:InputField runat='server' value='{!Model.ShowAccountList}'/>
            <aspx:InputField runat='server' value='{!Model.AlwaysCreateLeads}' hint="When enabled signup will create a lead record and allow the lead information to be reviewed and approved, otherwise a contact record will be created and the portal user will be activated right away."/>
            <aspx:FieldDropDown runat='server' value="{!Model.LeadSource}"/>
            <aspx:InputField runat='server' value='{!Model.NotifyAdministrator}' hint="Send email notification to the email list below for new registrations."/>
            <aspx:InputField runat='server' value='{!Model.AdministratorEmails}' hint="A comma-separated list of emails to be notified for new registrations."/>
            <aspx:InputField runat='server' value='{!Model.AdministratorLeadEmailTemplateId}' hint="Email template for new registrations (containing lead information)."/>
            <aspx:InputField runat='server' value='{!Model.AdministratorContactEmailTemplateId}' hint="Email template for new registrations (containing contact information)"/>
            <aspx:blankSpace runat='server'/>
            <aspx:InputField runat='server' value='{!Model.SendConfirmationEmail}' hint="Send a confirmation email to the registrant."/>
            <aspx:InputField runat='server' value='{!Model.ConfirmationEmailTemplateId}'/>
            <aspx:SectionItem runat='server' hideLabel="true">
                <button type="button" id="btnSaveSetting" class="btn btn-primary"><%:Resources.Global.Save%></button>
                <aspx:commandButton runat='server' action="Cancel" cssClass="btn btn-default" defaultReturnUrl="/aspx/admin" />
            </aspx:SectionItem>
        </aspx:ViewSection> 
        <div class="page_data" data-stage-picklist='<%# Text(DataBag.LeadSourcePicklist) %>'></div>
    </div>

    <script>
        $(function(){
            
            function updateUI() {
        
                if ($("#ShowAccountList").is(':checked')) {
                   $entityField("#AlwaysCreateLeads").showField();
                } else {
                    $entityField("#AlwaysCreateLeads").hideField();
                    $entityField("#AdministratorContactEmailTemplateId_tb").hideField();
                    $('#AlwaysCreateLeads').is(':checked');
                }
                
                if ($("#NotifyAdministrator").is(':checked')) {
                    $entityField("#AdministratorEmails").showField();
                    $entityField("#AdministratorLeadEmailTemplateId_tb").showField();
                    if (!$('#AlwaysCreateLeads').is(':checked')) {
                        $entityField("#AdministratorContactEmailTemplateId_tb").showField();
                    }
                } else {
                     $entityField("#AdministratorEmails").hideField();
                     $entityField("#AdministratorLeadEmailTemplateId_tb").hideField();
                     $entityField("#AdministratorContactEmailTemplateId_tb").hideField();
                }
                
                if ($("#AlwaysCreateLeads").is(':checked') && $("#NotifyAdministrator").is(':checked')) {
                     $entityField("#AdministratorContactEmailTemplateId_tb").hideField();
                }
                if (!$("#AlwaysCreateLeads").is(':checked') && $("#NotifyAdministrator").is(':checked')) {
                     $entityField("#AdministratorContactEmailTemplateId_tb").showField();
                }
                
                if ($("#SendConfirmationEmail").is(':checked')) {
                    $entityField("#ConfirmationEmailTemplateId_tb").showField();
                } else {
                     $entityField("#ConfirmationEmailTemplateId_tb").hideField();
                }
            }
            
            function validateEmail(email) {
                const re = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
                return re.test(String(email).toLowerCase());
            }
            
            function getEmails() {
                var email_list = $("#AdministratorEmails").val();
                var emails = [];
                var badEmails = [];
                if (email_list) {
                    $.each(email_list.replaceAll(",", ";").split(";"), function(i, email) {
                        if (!email) return;
                        email = email.trim();
                        if (!validateEmail(email)) {
                            badEmails.push(email);
                        } else {
                            emails.push(email);
                        }
                    });
                }

                if (badEmails.length > 0) {
                    $.openMessageBox({title:"Invalid emails", message:"Following emails are not valid: "+badEmails.join(", "), type:"warning" });
                    return null;
                }

                return emails;
            }
            
            updateUI();
            
            $("#btnSaveSetting").click(function() {
                
                if (!isFormValid()) {
                    return;
                }
                
                //validation email list
                if (getEmails()==null) {
                    return;
                }
                
                if ($("#NotifyAdministrator").is(":checked") && !$("#AdministratorEmails").val()) {
                    $.messageBox('Please provide at least one email address for registration notification.','warning','Note');
                    return;
                }
                
                if ($("#NotifyAdministrator").is(":checked") && $("#AlwaysCreateLeads").is(":checked") && !$("#AdministratorLeadEmailTemplateId_tb").val()) {
                    $.messageBox('Please select appropriate email template (containing lead information) for registration notification.','warning','Note');
                    return;
                }
                
                if ($("#NotifyAdministrator").is(":checked") && !$("#AlwaysCreateLeads").is(":checked") && (!$("#AdministratorLeadEmailTemplateId_tb").val() || !$("#AdministratorContactEmailTemplateId_tb").val() )){
                    $.messageBox('Please select appropriate email templates for registration notification.','warning','Note');
                    return;
                }
               
                if ($("#SendConfirmationEmail").is(":checked") && !$("#ConfirmationEmailTemplateId_tb").val()) {
                    $.messageBox('Please select appropriate email template for confirmation email.','warning','Note');
                    return;
                }

                __doPostBack("Save", { showBusy:true });
            });
            
            $.getRestScript(function() {
                var picklist = $(".page_data").attr("data-stage-picklist");
                var currVal = $("#LeadSource").val();
                
                REST2.exec({
                    url: "/rest/2.0/picklistmetadata",
                    data: { e: picklist },
                    type: "GET",
                    callback: function(response) {
                        if (REST2.isSuccess(response)) {
                            var entries = {};
                            entries.items = response.Result;
                            entries.textField = "Label";
                            entries.valueField = "Value";
                            entries.selected = currVal;
                            $("#LeadSource").dropDownOptions(entries);
                        }
                    }
                });
            },2);
            
            $("#ShowAccountList,#NotifyAdministrator,#SendConfirmationEmail,#AlwaysCreateLeads").click(updateUI);
            
        });
    </script>
</body>
</aspx:AspxPage>