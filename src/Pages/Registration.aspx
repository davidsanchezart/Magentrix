<aspx:AspxPage runat="server" Id="MyNewPage" title="<%#CustomLabels.Registration_SignUpTitle%>">
<body>
    <div class="max700">
        <aspx:ViewMessages runat="server"/>
        <div class="reg-panel panel panel-default" runat="server" visible="<%# !Bool(DataBag.ShowOptions) %>">
            <div id="enterEmailSection" class="email-panel">
                <div class="panel-heading">
                    <h1 class="regisration-title"><%:CustomLabels.Registration_SignUpTitle%></h1>
                    <br />
                    <p class="text-muted lead regisration-email-request"><%:CustomLabels.Registration_EmailRequest%>:</p>
                    <div class="panel-body tabPanel">
                        <div class="input-group input-group-lg">
                            <span class="input-group-addon" id="email-address">@</span>
                            <input id="partner-company-email" name = "partnerEmail" class="form-control input-required" value='<%=AttributeEncode(Request["email"]) %>' 
                                placeholder="<%:CustomLabels.Registration_EmailRequestPlaceHolder%>" aria-describedby="email-address" 
                                onkeypress="keyTrigger(event,function(){ $('#partner_reg_btn').click(); })"/>
                            <span class="input-group-btn">
                                <button id="partner_reg_btn" type="button" class="btn btn-primary btn-orange"><%:Resources.Global.Next%></button>
                            </span>
                        </div>
                    </div>
                    <br/>
                </div>
            </div>
        </div>
        
        <div id="showAccountsSection" class="accountListSection panel panel-default" runat="server" visible="<%# Bool(DataBag.ShowOptions) %>">
            <div class="accountList panel-body tabPanel">
                <h1><%:CustomLabels.Registration_CompanySelection%></h1>
                <p class="text-muted lead"><%:CustomLabels.Registration_ReviewListofCompanies%>:</p>
                <div class="radio">
                    <label style="font-weight:bold;">
                        <input type="radio" name="Type" value="employee" /> <%:CustomLabels.Registration_EmployeeofExistingCompanies%>:
                    </label>
                </div>
                <div id="AccountsWrapper" style="padding-left:40px;">
                    <aspx:Repeater runat="server" value="{!Model}" var="item">
                        <body>
                            <div class="radio">
                                <label>
                                    <input type="radio" name="AccountId" value="{!item.Id}" />
                                    <div style="font-weight:bold;">{!item.Name}</div>
                                    <p>{!item.Address}</p>
                                </label>
                            </div>
                        </body>
                    </aspx:Repeater>
                </div>
                
                <div class="radio">
                    <label style="font-weight:bold;">
                        <input type="radio" name="Type" value="newPartner" /> <%:CustomLabels.Registration_NotEmployeeofExistingCompanies%>.
                    </label>
                </div>
            </div>
            <div class="form-button panel-footer right">
                <button id="btnRegGoNext" type="button" class="btn btn-primary btn-lg"><%:Resources.Global.Next%></button>    
            </div>
        </div>
    </div>
    
    <input type="hidden" id="accountId" name ="partnerAccountId" value=""/>
    <input type="hidden" id="dbemail" name ="dbpartnerEmail" value='<%# AttributeEncode(DataBag.Email) %>' />
    <br/>
    <aspx:IncludeStandardScript runat='server' scriptType="REST" version="2"/>
    
    <ul id="page_custom_labels" style="display:none">
        <li id="msg_enter_company_email"><%:CustomLabels.Registration_EmailRequest%>.</li>
        <li id="msg_select_company"><%:CustomLabels.Registration_ReviewListofCompanies%></li>
        <li id="msg_employee_notemployee"><%:CustomLabels.Registration_EmployeeOrNot%></li>
    </ul>
    
    <script>
        $(function() {
            var labels = {};
            $("#page_custom_labels li").each(function() {
                labels[$(this).attr("id")] = $(this).text();
            });
            
            $('#partner-company-email').focus();
            var accountId = $("input[name='AccountId']:checked").val();
            $("#accountId").val(accountId);
            $("input[name='Type']").click(function() { 
                var options = $("input[name='AccountId']");
                if ($(this).val()=="employee" && options.length==1) {
                    options.setChecked(true);
                    accountId = $("input[name='AccountId']:checked").val();
                    $("#accountId").val(accountId);
                }
                else if ($(this).val()=="newPartner") {
                    options.setChecked(false);
                    $("#accountId").val("");
                }
            });
            $("input[name='AccountId']").change(function() {
                $("input[value='employee']").setChecked(true);
                accountId = $("input[name='AccountId']:checked").val();
                $("#accountId").val(accountId);
            });
            
            function emailValidation()
            {
                if ($("#partner-company-email").val()) {
                    __doPostBack('ValidateEmail');
                }
                else
                    $.messageBox(labels.msg_enter_company_email, "warning", "Note");
            }
                
            function goNext() {
                var selectedType = $("input[name='Type']:checked").val();
                var accountId = $("input[name='AccountId']:checked").val();
                
                if (!selectedType && !accountId) {
                    $.messageBox(labels.msg_employee_notemployee,"warning","Note");
                    return;
                }
                else if (selectedType == "employee") {
                    if (!accountId) {
                       $.messageBox(labels.msg_select_company,"warning","Note");
                       return;
                    }
                    else {
                        __doPostBack('SignupExistingContact');
                    }
                }
                else
                    __doPostBack('SignupNewMember');
            }
            
            $("#btnRegGoNext").click(goNext);
            $("#partner_reg_btn").click(emailValidation);
        });
        
        
    </script>
    <style>
        .reg-panel,.accountListSection{margin-top:50px}
        .regisration-title,.regisration-email-request {padding:0 15px;}
    </style>
</body>
</aspx:AspxPage>