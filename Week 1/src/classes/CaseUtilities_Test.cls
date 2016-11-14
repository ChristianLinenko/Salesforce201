@isTest
private class CaseUtilities_Test 
{
	
	@isTest static void testSetsOwnerToQueueOnInsert()
	{
		// arrange
		Case_Routing__c cr = new Case_Routing__c(
			Case_Type__c = 'Mechanical',
			Queue_Name__c = 'Mechanical'

		);
		insert cr;
		Case c = new Case(
			Subject = 'Blah blah, doesnt matter',
			Description = 'Some description of something thats broken',
			Type = 'Mechanical'
		);

		// act
		Test.startTest();
		insert c;
		Test.stopTest();

		// assert
		List<Case> cases = [SELECT Id, OwnerId FROM Case];
		List<Group> groups = [SELECT Id FROM Group WHERE Name = 'Mechanical' AND Type = 'Queue'];
		System.assert(cases.size() == 1, 'Should have created 1 case');
		System.assert(cases[0].OwnerId == groups[0].Id, 'Should have assigned the case to the queue: ' + cases[0].OwnerID + ' - ' + groups[0].Id);
	}
	
	@isTest static void testDoesntSetOwnerToQueue()
	{
		// arrange
		Case_Routing__c cr = new Case_Routing__c(
			Case_Type__c = 'Mechanical',
			Queue_Name__c = 'Mechanical'

		);
		insert cr;
		Case c = new Case(
			Subject = 'Blah blah, doesnt matter',
			Description = 'Some description of something thats broken',
			Type = 'Not Mechanical'
		);

		// act
		Test.startTest();
		insert c;
		Test.stopTest();

		// assert
		List<Case> cases = [SELECT Id, OwnerId FROM Case];
		List<Group> groups = [SELECT Id FROM Group WHERE Name = 'Mechanical' AND Type = 'Queue'];
		System.assert(cases.size() == 1, 'Should have created 1 case');
		System.assert(cases[0].OwnerId != groups[0].Id, 'Should have assigned the case to the queue: ' + cases[0].OwnerID + ' - ' + groups[0].Id);
	}

	@isTest static void testSetsOwnerToQueueOnUpdate()
	{
		// arrange
		Case_Routing__c cr = new Case_Routing__c(
			Case_Type__c = 'Mechanical',
			Queue_Name__c = 'Mechanical'

		);
		insert cr;
		Case c = new Case(
			Subject = 'Blah blah, doesnt matter',
			Description = 'Some description of something thats broken',
			Type = 'Mechanical'
		);
		insert c;
		c.Type = 'Mechanical';

		// act
		Test.startTest();
		update c;
		Test.stopTest();

		// assert
		List<Case> cases = [SELECT Id, OwnerId FROM Case];
		List<Group> groups = [SELECT Id FROM Group WHERE Name = 'Mechanical' AND Type = 'Queue'];
		System.assert(cases.size() == 1, 'Should have created 1 case');
		System.assert(cases[0].OwnerId == groups[0].Id, 'Should have assigned the case to the queue: ' + cases[0].OwnerID + ' - ' + groups[0].Id);
	}

	@isTest static void testSetsOwnerToQueueOnInsertBulk()
	{
		// arrange
		Case_Routing__c cr = new Case_Routing__c(
			Case_Type__c = 'Mechanical',
			Queue_Name__c = 'Mechanical'

		);
		insert cr;
		List<Case> cases = new List<Case>();
		for(Integer i = 0; i < 200; i++)
		{
			Case c = new Case(
				Subject = 'Blah blah, doesnt matter',
				Description = 'Some description of something thats broken',
				Type = 'Mechanical'
			);
			cases.add(c);
		}

		// act
		Test.startTest();
		insert cases;
		Test.stopTest();

		// assert
		List<Group> groups = [SELECT Id FROM Group WHERE Name = 'Mechanical' AND Type = 'Queue'];
		cases = [SELECT Id, OwnerId FROM Case WHERE OwnerId = :groups[0].Id];
		System.assert(cases.size() == 200, 'Should have updated the case owners: ' + cases.size());
	}
	
}