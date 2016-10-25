trigger CaseTrigger on Case (before insert, before update, before delete, after insert, after update, after delete, after undelete) 
{
	if(trigger.isBefore && trigger.isInsert)
		ClassUtilities.beforeCaseInsert(trigger.new);
	if(trigger.isBefore && trigger.isUpdate)
		ClassUtilities.beforeCaseUpdate(trigger.new, trigger.oldMap);
}