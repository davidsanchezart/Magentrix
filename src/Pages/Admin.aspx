<aspx:AspxPage runat="server" Id="AdminPage" title="Admin Center">
<body>
    <div>
        <h1 class="h2">Admin Center</h1>
        <p class="admin-description">Access quick links to various features within the portal.</p>
        <div class="horizontalLine"></div>
    </div>
    
    <div class="flexbox-container justify-between">
        <div class="admin-section">
            <h2 class="h3">Users</h2>
            <ul class="item-links">
                <li><a href="/user" target="_self" class="mng-sys-link std-v-padding">View Users</a></li>
                <li><a href="/user/create" target="_self" class="mng-sys-link std-v-padding">New Employee User</a></li>
                <li><a href="/user/newportaluser" target="_self" class="mng-sys-link std-v-padding">New Community User</a></li>
            </ul>
        </div>       
        
        <div class="admin-section">
            <h2 class="h3">Security Roles</h2>
            <ul class="item-links">
                <li><a href="/sys/role" target="_self" class="mng-sys-link std-v-padding">View Security Roles</a></li>
                <li><a href="/sys/role/create" target="_self" class="mng-sys-link std-v-padding">New Security Roles</a></li>  
            </ul>
        </div>    
        
        <!-- Display if Salesforce environment -->
        <div class="admin-section" runat="server" visible="<%# Bool(DataBag.ShowSalesforceEntityPanel) %>">
            <h2 class="h3">Salesforce</h2>
            <ul class="item-links">
                <li><a href="/sfdc" target="_self" class="mng-sys-link std-v-padding">View Salesforce</a></li>
                <li><a href="/sfdc/create" target="_self" class="mng-sys-link std-v-padding">Import Object</a></li>
            </ul>
        </div>
        <!-- Display if Dynamics environment -->
        <div class="admin-section" runat="server" visible="<%# Bool(DataBag.ShowDynamicsEntityPanel) %>">
            <h2 class="h3">Dynamics</h2>
            <ul class="item-links">
                <li><a href="/dynamicscrm/msdc" target="_self" class="mng-sys-link std-v-padding">View Dynamics</a></li>
                <li><a href="/dynamicscrm/msdc/create" target="_self" class="mng-sys-link std-v-padding">Import Object</a></li>
            </ul>
        </div>
        <!-- Display if Standard environment -->
        <div class="admin-section" runat="server" visible="<%# Bool(DataBag.ShowStandardEntityPanel) %>">
            <h2 class="h3">Entities</h2>
            <ul class="item-links">
                <li><a href="/setup/entity" target="_self" class="mng-sys-link std-v-padding">View Entities</a></li>
                <li><a href="/setup/entity/create" target="_self" class="mng-sys-link std-v-padding">Create Entity</a></li>
            </ul>
        </div>
        
       <div class="admin-section">
            <h2 class="h3">Events</h2>
            <ul class="item-links">
                <li><a href="/publiceventcategory" target="_self" class="mng-sys-link std-v-padding">View Event Categories</a></li>
                <li><a href="/publiceventcategory/create" target="_self" class="mng-sys-link std-v-padding">New Event Category</a></li>
            </ul>
        </div>
        
        <div class="admin-section">
            <h2 class="h3">Articles</h2>
            <ul class="item-links">
                <li><a href="/blog/index" target="_self" class="mng-sys-link std-v-padding">View Article Types</a></li>
                <li><a href="/blog/create" target="_self" class="mng-sys-link std-v-padding">New Article Type</a></li>
                <li><a href="/bloglist/index" target="_self" class="mng-sys-link std-v-padding">Article Lists</a></li>
            </ul>
        </div>
        
        <div class="admin-section">
            <h2 class="h3">Playbooks</h2>
            <ul class="item-links">
                <li><a href="/playbooksetting" target="_self" class="mng-sys-link std-v-padding">View Playbooks</a></li>
                <li><a href="/playbooksetting/create" target="_self" class="mng-sys-link std-v-padding">New Playbook</a></li>
                <li><a href="/playbooksetting/filters" target="_self" class="mng-sys-link std-v-padding">Manage Filters</a></li>
            </ul>
        </div>
        
        <div class="admin-section">
            <h2 class="h3">Carousels</h2>
            <ul class="item-links">
                <li><a href="/carousel" target="_self" class="mng-sys-link std-v-padding">View Carousels</a></li>
                <li><a href="/carousel/create" target="_self" class="mng-sys-link std-v-padding">New Carousel</a></li>
            </ul>
        </div>
        
        <div class="admin-section">
            <h2 class="h3">Engagement Pages</h2>
            <ul class="item-links">
                <li><a href="/magicpagesetting" target="_self" class="mng-sys-link std-v-padding">View Engagement Pages</a></li>
                <li><a href="/magicpagesetting/create" target="_self" class="mng-sys-link std-v-padding">New Engagement Page</a></li>
            </ul>
        </div>
        
        <div class="admin-section">
            <h2 class="h3">Training</h2>
            <ul class="item-links">
                <li><a href="/lms/dashboard" target="_self" class="mng-sys-link std-v-padding">Dashboard</a></li>
                <li><a href="/lms/courses" target="_self" class="mng-sys-link std-v-padding">Courses</a></li>
                <li><a href="/lms/learningpaths" target="_self" class="mng-sys-link std-v-padding">Learning Path</a></li>
                <li><a href="/lms/reports" target="_self" class="mng-sys-link std-v-padding">Reports</a></li>
                <li><a href="/lms/lmssetting" target="_self" class="mng-sys-link std-v-padding">Settings</a></li>
            </ul>
        </div>
        
        <div class="admin-section">
            <h2 class="h3">Settings</h2>
            <ul class="item-links">
                <li><a href="/setup/home/moresettings" target="_self" class="mng-sys-link std-v-padding">View Community Settings</a></li>
                <li runat="server" visible="<%# Bool(DataBag.ShowArticleSyncSettingPage) %>"><a href="/aspx/articlesyncsetting" target="_self" class="mng-sys-link std-v-padding">View Article Sync Settings</a></li>
                <li runat="server" visible="<%# Bool(DataBag.ShowUserGroupsegmentationRuleSettingPage) %>"><a href="/aspx/usergroupsegmentationrulesettings" target="_self" class="mng-sys-link std-v-padding">View User Group Segmentation Rule Settings</a></li>
                <li runat="server" visible="<%# Bool(DataBag.ShowMdfSettingsPage) %>"><a href="/aspx/mdfsettings" target="_self" class="mng-sys-link std-v-padding">View MDF Settings</a></li>
                <li runat="server" visible="<%# Bool(DataBag.ShowOpportunityAddProductsSettingPage) %>"><a href="/aspx/opportunityaddproductssetting" target="_self" class="mng-sys-link std-v-padding">View Opportunity Add Products Settings</a></li>
                <li runat="server" visible="<%# Bool(DataBag.ShowRegistrationSettingControlPanelSettingPage) %>"><a href="/aspx/registrationsettingcontrolpanel" target="_self" class="mng-sys-link std-v-padding">View Registration Settings</a></li>
                <li runat="server" visible="<%# Bool(DataBag.ShowManageTeamSettingPage) %>"><a href="/aspx/manageteamsettings" target="_self" class="mng-sys-link std-v-padding">View Manage Team Settings</a></li>
            </ul>
        </div>
    </div>

    <style>
        .admin-description { font-size: 16px; }
        .flexbox-container { flex-direction: column;flex-wrap: wrap;align-items: normal; }
        .flexbox-container .admin-section { flex: initial;margin-bottom: 30px; }
        .flexbox-container .admin-section .item-links { list-style: none;margin: 0;padding: 0; }
        .flexbox-container.admin-section .item-links>li { padding: 0; }
        .flexbox-container .admin-section .item-links>li>a { display: block;border-bottom: 1px solid var(--mag-element-border-color); }
        .flexbox-container .admin-section .item-links>li>a:hover { text-decoration: none;color: var(--mag-primary-hover-color);border-bottom: 2px solid var(--mag-primary-hover-color);margin-bottom: -1px; }
        .flexbox-container .admin-section .item-links>li>a:focus { text-decoration: none; }

        @media (min-width: 768px) {
            .flexbox-container { flex-direction: row; }
            .flexbox-container .admin-section { flex: 0 0 45%;margin-right: 15px; }
        }
    </style>
</body>
</aspx:AspxPage>