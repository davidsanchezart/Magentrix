public class AutoEnablePortalUsersTrigger : ActiveTrigger<Contact>
{
	public override void Execute(TransactionContext<Contact> trigger)
	{
        //Auto Enable Portal User 
        if (trigger.IsAfter && (trigger.IsInsert || trigger.IsUpdate))
        {
            var manageTeamSetting = ManageTeamSetting.Load();
            var communityRoleField = manageTeamSetting.CommunityRoleField;
            var communityUserField = manageTeamSetting.CommunityUserField;

            if (IsEmpty(communityRoleField) || IsEmpty(communityUserField))
                return;
                
            var roles = GetRoles();
            var records = trigger.Records;
            var contactIds = records.Select(a => a.New.Id).ToList();
            
            var users = Database.Query<User>()
                        .Where(a => contactIds.Contains(a.ContactId))
                        .ToListAsAdmin();
            
            var contactEmails = records
                .Where(a => !string.IsNullOrEmpty(a.New.Email))
                .Select(a => a.New.Email.Trim())
                .ToList();
                
            var usersByEmail = Database.Query<User>()
                               .Where(a => contactEmails.Contains(a.Username))
                               .ToListAsAdmin();

            var accounts = new List<Account>();
            var editedRecords = new List<Contact>();
            var ownerContacts = new List<ContactEx>();
            
            if (trigger.IsUpdate)
            {
                var accountIds = trigger.Records
                    .Where(a => !string.IsNullOrEmpty(a.New.AccountId))
                    .Select(a => a.New.AccountId)
                    .Distinct()
                    .ToList();
                    
                accounts = Database.Query<Account>()
                           .Where(a => accountIds.Contains(a.Id))
                           .Select(a => new { a.Id, a.OwnerId })
                           .ToListAsAdmin();
            }

            foreach (var record in records)
            {
                try
                {
                    var contact = record.New;
                    bool enableTheUser = ((bool?)contact.Get(communityUserField)) == true;
                    var currentUser = users.FirstOrDefault(a => a.ContactId == contact.Id);
                    var role = roles.FirstOrDefault(f => f.Name == (string)contact.Get(communityRoleField));

                    bool isNewUser = currentUser == null;
                    if (isNewUser && enableTheUser)
                    {
                        if (IsEmpty(contact.Firstname) || IsEmpty(contact.Lastname) || IsEmpty(contact.Email)) 
                            continue;
                        
                        var userByEmail = usersByEmail.FirstOrDefault(a => a.Username == contact.Email.Trim());
                        if (userByEmail != null)
                        {
                            SystemInfo.Warning($"[AutoEnablePortalUsersTrigger] [Skipping portal user creation for ContactId: {contact.Id}. A user with name: {contact.Email} already exists]");
                            continue;
                        }
                        
                        //To Note and do for developers: 
                        //Depending on the client, you may need to set the language, currency from Contact/Account of a user in the following code lines when creating a new user.
                        currentUser = PrepareUserObject(contact, role);
                        
                        SystemInfo.Info($"[AutoEnablePortalUsersTrigger] [Creating Portal User for ContactId: {contact.Id} with email: {contact.Email}]");
                        
                        //Contact is not a Portal User. Enable the user as a Portal User.
                        bool triggerEmail =  true;
                        Create(currentUser, new {SystemMode = true, TriggerUserEmail = triggerEmail});
                    }
                    
                    if (!isNewUser && currentUser != null)
                    {
                        bool changed = false;
                        if (currentUser.IsActive != enableTheUser)
                        {
                            currentUser.IsActive = enableTheUser;
                            changed = true;
                        }
                        
                        if (role != null && currentUser.RoleId != role.Id)
                        {
                            currentUser.RoleId = role.Id;
                            changed = true;
                        }
                        
                        if (changed)
                        {
                            Edit(currentUser, new {SystemMode = true});
                        }
                    }
                }
                catch (Exception ex)
                {   
                    SystemInfo.Error($"[AutoEnablePortalUsersTrigger] [Creating/Editing Portal User for ContactId: {record.New.Id} with email: {record.New.Email}] [Error: {ex.Message}");
                    EventLogProvider.Current.WriteException(ex);
                }
            }
    	}
	}

    private User PrepareUserObject(Contact contact, Role role)
	{
	    var user = new User { 
                        Firstname = contact.Firstname, 
                        Lastname = contact.Lastname,
                        Username = contact.Email.Trim(),
                        RoleId = role.Id,
                        Email = contact.Email.Trim(),
                        ContactId = contact.Id,
                        AccountId = contact.AccountId,
                        IsActive = true
                   };
                   
        return user;           
	}
	
	private List<Role> GetRoles()
	{
	    var roles = Database.Query<Role>()
                    .Where(f=> f.Type == 1 || f.Type == 3)
                    .Select(f => new { f.Id, f.Name })
                    .ToListAsAdmin();
	
	    return roles;
	}
	
	public class ContactEx
	{
	    public string Id { get; set; }
	    public string Name { get; set; }
	}
    
}