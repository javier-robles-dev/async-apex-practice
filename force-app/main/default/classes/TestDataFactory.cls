@isTest
public class TestDataFactory {
  /*
    Create N,M Accounts, Contacts
    */

  public static List<Account> createAccountsWithContacts(
    Integer numAcc,
    Integer numContactsPerAccount
  ) {
    // 1. Accounts
    List<Account> accts = new List<Account>();
    for (Integer i = 0; i < numAcc; i++) {
      accts.add(new Account(Name = 'Test Account ' + i));
    }

    insert accts;

    // 2. Contacts
    if (numContactsPerAccount > 0) {
      List<Contact> conList = new List<Contact>();
      for (Account a : accts) {
        for (Integer j = 0; j < numContactsPerAccount; j++) {
          conList.add(
            new Contact(LastName = 'Test Contact ' + j, AccountId = a.Id)
          );
        }
      }
      insert conList;
    }

    return accts;
  }
}
