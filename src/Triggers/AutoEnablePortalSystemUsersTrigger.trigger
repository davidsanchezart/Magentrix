public class AutoEnablePortalSystemUsersTrigger : ActiveTrigger<User>
{
	public override void Execute(TransactionContext<User> trigger)
	{
	    if (trigger.IsAfter && (trigger.IsInsert || trigger.IsUpdate))
        {   
            var manageTeamSetting = ManageTeamSetting.Load();
            var communityRoleField = manageTeamSetting.CommunityRoleField;
            var communityUserField = manageTeamSetting.CommunityUserField;
            
            if (IsEmpty(communityRoleField) || IsEmpty(communityUserField))
                return;
            
            var contactsToUpdate = new List<Contact>();
            
            var roles = GetRoles();
            var contactIds = trigger.Records.Select(a => a.New.ContactId).ToList();
            var contacts = GetAllContacts(contactIds);
            
            foreach (var record in trigger.Records)
            {
                var user = record.New;
                string contactId = user.ContactId;
                string roleId = user.RoleId;
                bool enableCommunityUser = user.IsActive == true;
    
                var contact = contacts.FirstOrDefault(a => a.Id == contactId);
                var role = roles.FirstOrDefault(f => f.Id == roleId);
                    
                if (contact == null || role == null)
                    continue;

                bool changed = false;
                if (((bool?)contact.Get(communityUserField)) != enableCommunityUser)
                {
                    contact.Set(communityUserField, enableCommunityUser);
                    changed = true;
                }
                    
                if ((string)contact.Get(communityRoleField) != role.Name)
                {
                    //Only, if the User is active in Magentrix, The Role in the CRM Contact will be updated.
                    if (enableCommunityUser)
                    {
                        contact.Set(communityRoleField, role.Name);
                        changed = true;
                    }
                }
                    
                if (changed)
                    contactsToUpdate.Add(contact);
                    
                if (contactsToUpdate.Count >= 150)
                {
                    try
                    {
                        Edit(contactsToUpdate, new {SystemMode = true}); 
                    }    
                    catch (Exception ex)
                    {   
                        SystemInfo.Error($"1. [AutoEnablePortalSystemUsersTrigger] [Editing Contacts: {JsonHelper.ToJson(contactsToUpdate)}] [Error: {ex.Message}]");
                    } 
                    contactsToUpdate.Clear();
                }        
            }

            if (contactsToUpdate.Count > 0)
            {
                try
                {
                    Edit(contactsToUpdate, new {SystemMode = true}); 
                }    
                catch (Exception ex)
                {   
                    SystemInfo.Error($"2. [AutoEnablePortalSystemUsersTrigger] [Editing Contacts: {JsonHelper.ToJson(contactsToUpdate)}] [Error: {ex.Message}]");
                }   
            }   
    	}
	}
	
	private List<Role> GetRoles()
	{
	    var roles = Database.Query<Role>()
                    .Where(f=> f.Type == 1 || f.Type == 3)
                    .Select(f => new { f.Id, f.Name })
                    .ToListAsAdmin();
                        
        return roles;                
	}
	
	private List<Contact> GetAllContacts(List<string> contactIds)
	{
	    int chunkSize = 200;
	    List<Contact> allContactsRecords = new List<Contact>();
	    List<List<string>> chunkContactIds = new List<List<string>>();

	    while (contactIds.Count > 0)
        {
            int count = contactIds.Count > chunkSize ? chunkSize : contactIds.Count;
            chunkContactIds.Add(contactIds.GetRange(0, count));
            contactIds.RemoveRange(0, count);
        }
        
        foreach (var itemChunkContactIds in chunkContactIds)
        {
            var contacts = GetContactsByIds(itemChunkContactIds);
            
            if (contacts.Count > 0)
                allContactsRecords.AddRange(contacts);
        }
                           
        return allContactsRecords;                   
	}
	
	private List<Contact> GetContactsByIds(List<string> contactIds)
	{
	    var contacts = Database.Query<Contact>()
                       .Where(a => contactIds.Contains(a.Id))
                       .ToListAsAdmin();
                           
        return contacts;                   
	}
	
}