public with sharing class TOTVSQOPService {
  @future(callout=true)
  public static void sendQuote(Id quoteId) {
    Quote quote = [
      SELECT
        Id,
        TipoFrete__c,
        Account.Transportadora__c,
        Account.Codigo_do_cliente__c,
        Account.Desconto_do_cliente__c,
        CondicoesPagamento__c,
        PriceBook2.PriceBookCode__c,
        Account.Name,
        Account.Natureza_de_Operacao__c
      FROM Quote
      WHERE Id = :quoteId
      LIMIT 1
    ];

    List<QuoteLineItem> items = [
      SELECT
        Id,
        Quantity,
        Product2.ProductCode,
        PricebookEntry.PriceBook2.PriceBookCode__c
      FROM QuoteLineItem
      WHERE QuoteId = :quoteId
    ];

    TOTVSQuoteDTO dto = new TOTVSQuoteDTO();

    dto.branchId = '20';
    dto.cifCity = 'Destino';
    dto.codeCarrier = 92;
    dto.customerCoder = 569;
    dto.deliveryCode = 'Padrão';
    dto.customerDiscount = 10;
    dto.paymentTerms = 130;
    dto.percentageFreight = 0;
    dto.priceTableQuote = '0022412B';
    dto.salesChannel = 2;
    dto.operationTypeCode = 1;
    dto.priceQuoteType = 2;
    dto.useDiscountTable = true;
    dto.shortName = 'Auto K';
    dto.transactionType = '511021';
    dto.valueFreight = 0;

    for (QuoteLineItem qli : items) {
      dto.addItem(
        '9.056.05.001CW', // Product Code TOTVS
        '0022412', // Price Table
        1 // Quantity
      );
    }

    String bodyDto = JSON.serialize(dto);

    TOTVS_QOP_Config_mdt__mdt cfg = [
      SELECT Base_URL_c__c, Endpoint_c__c, Password_c__c
      FROM TOTVS_QOP_Config_mdt__mdt
      WHERE DeveloperName = 'QOP_Production'
      LIMIT 1
    ];

    HttpRequest req = new HttpRequest();
    req.setEndpoint(cfg.Base_URL_c__c + cfg.Endpoint_c__c);
    req.setMethod('POST');
    req.setHeader('Content-Type', 'application/json; charset=UTF-8');
    req.setBody(bodyDto);

    HttpResponse res;
    try {
      res = (new Http()).send(req);
      System.debug('STATUS: ' + res.getStatus());
      System.debug('BODY  : ' + res.getBody());
    } catch (Exception e) {
      logError(quoteId, dto, e);
    }
  }

  public static String simulateQuote(TOTVSQuoteDTO dto) {
    try {
      String payload = JSON.serialize(dto);

      TOTVS_QOP_Config_mdt__mdt cfg = [
        SELECT Base_URL_c__c, Endpoint_c__c
        FROM TOTVS_QOP_Config_mdt__mdt
        WHERE DeveloperName = 'QOP_Production'
        LIMIT 1
      ];

      HttpRequest req = new HttpRequest();
      req.setEndpoint(cfg.Base_URL_c__c + cfg.Endpoint_c__c);
      req.setMethod('POST');
      req.setHeader('Content-Type', 'application/json; charset=UTF-8');
      req.setBody(payload);

      HttpResponse res = (new Http()).send(req);
      return res.getBody();
    } catch (Exception e) {
      System.debug('simulateQuote ERROR: ' + e.getMessage());
      return null;
    }
  }

  private static void logError(Id quoteId, TOTVSQuoteDTO dto, Exception e) {
    try {
      insert new Integration_Log__c(
        Quote__c = quoteId,
        Name = 'Erro integração - ' + String.valueOf(Datetime.now()),
        PayloadSent__c = JSON.serialize(dto),
        PayloadReceived__c = e.getMessage()
      );
    } catch (Exception ignored) {
    }
    System.debug('Erro na integração de cotação: ' + e.getMessage());
  }
}
