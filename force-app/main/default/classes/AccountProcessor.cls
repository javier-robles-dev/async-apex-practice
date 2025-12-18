public with sharing class AccountProcessor {
  @future
  public static void countContacts(List<Id> acctIdList) {
    if (acctIdList == null || acctIdList.isEmpty())
      return;

    List<Account> acctsToUpdate = new List<Account>();

    for (Account acc : [
      SELECT
        Id,
        Number_Of_Contacts__c,
        (
          SELECT Id
          FROM Contacts
        )
      FROM Account
      WHERE Id IN :acctIdList
    ]) {
      acc.Number_Of_Contacts__c = acc.Contacts.size();
      acctsToUpdate.add(acc);
    }

    if (acctsToUpdate.size() > 0) {
      update acctsToUpdate;
    }
  }
}
