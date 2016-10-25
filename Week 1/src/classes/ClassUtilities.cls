public without sharing class ClassUtilities 
{
	public static void routeCase(List<Case> newCases, Map<Id, Case> oldCaseMap)
	{
		// 0. See which cases need to be updated
		List<Case> casesToUpdate = new List<Case>();
		for(Case c: newCases)
		{
			Case oldCase = oldCaseMap.get(c.Id);
			if(oldCase == null || c.Type != oldCase.Type) // either it's a new case or the type value has changed
				casesToUpdate.add(c);
		}

		if(casesToUpdate.size() > 0)
		{
			// 1. Get the case routing records
			List<Case_Routing__c> caseRoutings = [SELECT Id, Case_Type__c, Queue_Name__c FROM Case_Routing__c];
			// Get all the queue names
			Map<String, String> typeToQueueNameMap = new Map<String, String>();
			for(Case_Routing__c c: caseRoutings)
				typeToQueueNameMap.put(c.Case_Type__c, c.Queue_Name__c);

			// 2. Get the queues
			Map<String, Id> queuesNameToQueueIdMap = new Map<String, Id>();
			for(Group g: [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND DeveloperName IN: typeToQueueNameMap.values()])
				queuesNameToQueueIdMap.put(g.DeveloperName, g.Id);

			// 3. Check the records
			for(Case c: casesToUpdate)
			{
				String queueName = typeToQueueNameMap.get(c.Type);
				if(String.isNotBlank(queueName))
				{
					Id eyeDee = queuesNameToQueueIdMap.get(queueName);
					if(String.isNotBlank(eyeDee))
					{
						c.OwnerId = eyeDee;
						System.debug('Assigning case to queue: ' + queueName);
						break;
					}
				}
			}
		}
	}

	public static void beforeCaseInsert(List<Case> newCases)
	{
		routeCase(newCases, new Map<Id, Case>());
	}

	public static void beforeCaseUpdate(List<Case> newCases, Map<Id, Case> oldCaseMap)
	{
		routeCase(newCases, oldCaseMap);
	}
}