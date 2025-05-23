public with sharing class TOTVSQuoteDTO {

    public String branchId;
    public String cifCity;
    public Integer codeCarrier;
    public Integer customerCoder;
    public String deliveryCode;
    public Decimal customerDiscount;
    public Integer paymentTerms;
    public Decimal percentageFreight;
    public String priceTableQuote;
    public Integer salesChannel;
    public Integer operationTypeCode;
    public Integer priceQuoteType;
    public Boolean useDiscountTable;
    public String shortName;
    public String transactionType;
    public Decimal valueFreight;
    public List<TOTVSQuoteItemDTO> quoteItems;

    public TOTVSQuoteDTO() {
        this.quoteItems = new List<TOTVSQuoteItemDTO>();
    }

    public void addItem(String itemCode, String priceTable, Decimal quantityBilling) {
        TOTVSQuoteItemDTO item = new TOTVSQuoteItemDTO(itemCode, priceTable, quantityBilling);
        this.quoteItems.add(item);
    }

    public class TOTVSQuoteItemDTO {
        public String itemCode;
        public String priceTable;
        public Decimal quantityBilling;

        public TOTVSQuoteItemDTO() {}

        public TOTVSQuoteItemDTO(String itemCode, String priceTable, Decimal quantityBilling) {
            this.itemCode = itemCode;
            this.priceTable = priceTable;
            this.quantityBilling = quantityBilling;
        }
    }
}