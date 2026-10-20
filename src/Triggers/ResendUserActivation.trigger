public class ResendUserActivation : ActiveTrigger<User>
{
	public override void Execute(TransactionContext<User> trigger)
    {
        if (trigger.IsBefore && trigger.IsUpdate && trigger.Records != null)
        {
            foreach (var record in trigger.Records)
            {
                if (record.New == null || record.Old == null) continue;
                if (record.New.IsActive == true && record.New.Resend_Activation_Email__c == true)
                {
                    PortalManager.SendActivation(record.New);
                    record.New.Resend_Activation_Email__c = false;
                }
            }
        }
    }
}