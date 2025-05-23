@isTest
private class TOTVSQuoteDTOTest {

    @isTest
    static void testCreateAndAddItem() {


        TOTVSQuoteDTO dto = new TOTVSQuoteDTO();

        dto.branchId = 'BR001';
        dto.cifCity = 'São Paulo';
        dto.codeCarrier = 123;
        dto.customerCoder = 456;
        dto.deliveryCode = 'PADRÃO';
        dto.customerDiscount = 5.5;
        dto.paymentTerms = 30;
        dto.percentageFreight = 2.0;
        dto.priceTableQuote = 'Standard';
        dto.salesChannel = 10;
        dto.operationTypeCode = 20;
        dto.priceQuoteType = 1;
        dto.useDiscountTable = true;
        dto.shortName = 'Cliente Teste';
        dto.transactionType = 'Venda';
        dto.valueFreight = 100;

        dto.addItem('ITEM001', '20', 2);

        System.assertEquals('BR001', dto.branchId, 'A branch id deve ser a mesma definida no dto.');
        System.assertEquals('São Paulo', dto.cifCity, 'A cif city deve ser a mesma definida no dto.');
        System.assertEquals(123, dto.codeCarrier, 'O code carrier deve ser a mesma definida no dto.');
        System.assertEquals(456, dto.customerCoder, 'O customer coder deve ser a mesma definida no dto.');
        System.assertEquals('PADRÃO', dto.deliveryCode, 'A delivery code deve ser a mesma definida no dto.');
        System.assertEquals(5.5, dto.customerDiscount, 'O customer discount deve ser a mesma definida no dto.');
        System.assertEquals(30, dto.paymentTerms, 'O payment terms deve ser a mesma definida no dto.');
        System.assertEquals(2.0, dto.percentageFreight, 'O percentage freight deve ser a mesma definida no dto.');
        System.assertEquals('Standard', dto.priceTableQuote, 'O price table quote deve ser a mesma definida no dto.');
        System.AssertEquals(10, dto.salesChannel, 'O sales channel deve ser a mesma definida no dto.');
        System.AssertEquals(20, dto.operationTypeCode, 'A operation type code deve ser a mesma definida no dto.');
        System.AssertEquals(1, dto.priceQuoteType, 'A price quote type deve ser a mesma definida no dto.');
        System.AssertEquals(true, dto.useDiscountTable, 'A use discount table deve ser a mesma definida no dto.');
        System.AssertEquals('Cliente Teste', dto.shortName, 'O short name deve ser a mesma definida no dto.');
        System.AssertEquals('Venda', dto.transactionType, 'A transaction type deve ser a mesma definida no dto.');
        System.AssertEquals(100, dto.valueFreight, 'O value freight deve ser a mesma definida no dto.');
        System.assertEquals(1, dto.quoteItems.size(), 'A lista de itens deve conter ao menos 1 elemento.');

        TOTVSQuoteDTO.TOTVSQuoteItemDTO item = dto.quoteItems[0];
        System.assertEquals('ITEM001', item.itemCode, 'O item code deve ser o mesmo passado como primeiro parâmetro na função addItem.');
        System.assertEquals('20', item.priceTable, 'O price table deve ser o mesmo passado como segundo parâmento na função addItem');
        System.assertEquals(2, item.quantityBilling, 'O quantity deve ser o mesmo passado como terceiro parâmetro na função addItem');
    }
}