Feature: Average score reporting

  @story-1
  Rule: Service1 reports the average of the catalog Service2 currently serves, as a whole number

    Scenario: Averaging the full catalog
      Given Service2 is serving its full catalog of 10 scored records
      When a User requests the average score from Service1
      Then Service1 returns an average score of 35

  @story-2 @negative
  Rule: A request to a path Service1 does not serve is refused with a structured 404 body

    Scenario: Requesting an unsupported path
      When a User requests a path that Service1 does not serve
      Then Service1 responds with a structured 404 error body
