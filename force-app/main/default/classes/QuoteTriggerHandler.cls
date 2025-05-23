public class QuoteTriggerHandler {

    public static void handleAfterInsert(List<Quote> newQuotes) {
        triggerIntegration(newQuotes);
    }

    public static void handleAfterUpdate(List<Quote> newQuotes, Map<Id, Quote> oldQuoteMap) {
        triggerIntegration(newQuotes);
    }

    private static void triggerIntegration(List<Quote> quotes) {

        Set<Id> quoteIds = new Set<Id>();
        for(Quote q : quotes) {
            quoteIds.add(q.Id);
        }

        Map<Id, Integer> quoteItemCount = new Map<Id, Integer>();
        for(AggregateResult ar : [SELECT QuoteId, COUNT(Id) quantity FROM QuoteLineItem WHERE QuoteId IN :quoteIds GROUP BY QuoteId]) {
            quoteItemCount.put((Id)ar.get('QuoteId'), (Integer)ar.get('quantity'));
        }

        for(Quote q : quotes) {
            if(quoteItemCount.containsKey(q.Id) && quoteItemCount.get(q.Id) > 0) {
                TOTVSQOPService.sendQuote(q.Id);
            }
        }
    }
}