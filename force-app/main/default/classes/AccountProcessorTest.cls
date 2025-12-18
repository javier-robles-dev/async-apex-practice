@isTest
private class AccountProcessorTest {
  @isTest
  static void testOneAccountWithNoContacts() {
    List<Account> accts = TestDataFactory.createAccountsWithContacts(1, 0);
    List<Id> acctIds = new List<Id>();
    for (Account a : accts) {
      acctIds.add(a.Id);
    }

    Test.startTest();
    AccountProcessor.countContacts(acctIds);
    Test.stopTest();

    Account resultingAcc = [
      SELECT Id, Number_Of_Contacts__c
      FROM Account
      LIMIT 1
    ];

    System.assertEquals(0, resultingAcc.Number_Of_Contacts__c);
  }

  @isTest
  static void testOneAccountWithOneContacts() {
    List<Account> accts = TestDataFactory.createAccountsWithContacts(1, 1);
    List<Id> acctIds = new List<Id>();
    for (Account a : accts) {
      acctIds.add(a.Id);
    }

    Test.startTest();
    AccountProcessor.countContacts(acctIds);
    Test.stopTest();

    Account resultingAcc = [
      SELECT Id, Number_Of_Contacts__c
      FROM Account
      LIMIT 1
    ];

    System.assertEquals(1, resultingAcc.Number_Of_Contacts__c);
  }

  @isTest
  static void testEmptyList() {
    Test.startTest();
    AccountProcessor.countContacts(new List<Id>());
    Test.stopTest();

    System.assert(true);
  }

  @isTest
  static void testNullList() {
    Test.startTest();
    AccountProcessor.countContacts(null);
    Test.stopTest();

    System.assert(true);
  }
}
