public class UpdateContactAddresses implements Database.Batchable<SObject>, Database.Stateful {
  // 0. Instance member to retain state accross transactions
  public Integer recordsProcessed = 0;
  // 1. Start method executes once and returns the group of records to be processed
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      'SELECT Id, BillingStreet, BillingCity, BillingState, ' +
        'BillingPostalCode, (SELECT Id, MailingStreet, MailingCity, ' +
        'MailingState, MailingPostalCode FROM Contacts) FROM Account ' +
        'WHERE BillingCountry = \'USA\''
    );
  }

  //  2. Execute Method, runs once for every batch
  public void execute(Database.BatchableContext bc, List<Account> scope) {
    // process each batch of records
    List<Contact> contacts = new List<Contact>();
    for (Account account : scope) {
      for (Contact contact : account.Contacts) {
        contact.MailingStreet = account.BillingStreet;
        contact.MailingCity = account.BillingCity;
        contact.MailingState = account.BillingState;
        contact.MailingPostalCode = account.BillingPostalCode;
        // Add contact to list to be updated
        contacts.add(contact);
        // Increment the instance member counter
        recordsProcessed++;
      }
    }
    if (contacts.size() > 0) {
      update contacts;
    }
  }
  //  3. Finish method
  public void finish(Database.BatchableContext bc) {
    System.debug(recordsProcessed + ' records processed!');
    AsyncApexJob job = [
      SELECT
        Id,
        Status,
        NumberOfErrors,
        JobItemsProcessed,
        TotalJobItems,
        CreatedBy.Email
      FROM AsyncApexJob
      WHERE Id = :bc.getJobId()
    ];

    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

    mail.setToAddresses(new List<String>{ UserInfo.getUserEmail() });
    mail.setSubject('Batch UpdateContactAddresses finished');
    mail.setPlainTextBody(
      'Batch completed.\n' + 'Records processed: ' + recordsProcessed
    );

    Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{ mail });
  }
}
