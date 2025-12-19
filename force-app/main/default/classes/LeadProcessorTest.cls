@isTest
private class LeadProcessorTest {
  @testSetup
  static void setup() {
    List<Lead> leadList = new List<Lead>();

    for (Integer i = 0; i < 200; i++) {
      leadList.add(
        new Lead(
          LastName = 'Test Lead ' + i,
          Status = 'Open - Not Contacted',
          Company = 'Test Company'
        )
      );
    }

    insert leadList;
  }

  @isTest
  static void test() {
    Test.startTest();
    LeadProcessor lp = new LeadProcessor();
    Id batchId = Database.executeBatch(lp);
    Test.stopTest();

    System.assertEquals(
      200,
      [
        SELECT COUNT()
        FROM Lead
        WHERE LeadSource = 'Dreamforce'
      ]
    );
  }
}
