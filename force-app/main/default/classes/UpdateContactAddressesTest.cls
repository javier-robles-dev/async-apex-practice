@isTest
private class UpdateContactAddressesTest {
  @testSetup
  static void setup() {
    List<Account> accounts = new List<Account>();
    List<Contact> contacts = new List<Contact>();

    for (Integer i = 0; i < 10; i++) {
      accounts.add(
        new Account(
          Name = 'Account ' + i,
          BillingCity = 'New York',
          BillingCountry = 'USA'
        )
      );
    }
    insert accounts;

    for (Account a : [SELECT Id FROM Account]) {
      contacts.add(
        new Contact(FirstName = 'first', LastName = 'last', AccountId = a.Id)
      );
    }
    insert contacts;
  }

  @isTest
  static void test() {
    Test.startTest();
    UpdateContactAddresses uca = new UpdateContactAddresses();
    Id batchId = Database.executeBatch(uca);
    Test.stopTest();

    System.assertEquals(
      10,
      [
        SELECT COUNT()
        FROM Contact
        WHERE MailingCity = 'New York'
      ]
    );
  }
}
