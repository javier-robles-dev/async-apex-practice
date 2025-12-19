public class LeadProcessor implements Database.Batchable<SObject> {
  // 1. Start
  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator('SELECT Id, LeadSource FROM Lead');
  }

  // 2. Execute
  public void execute(Database.BatchableContext bc, List<Lead> scope) {
    List<Lead> leadList = new List<Lead>();
    for (Lead l : scope) {
      l.LeadSource = 'Dreamforce';
      leadList.add(l);
    }
    if (leadList.size() > 0) {
      update leadList;
    }
  }

  // 3. Finish
  public void finish(Database.BatchableContext bc) {
    System.debug('LeadSource updated on all leads');
  }
}
