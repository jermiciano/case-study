/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup cgroup = new CollaborationGroup();
        cgroup.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        cgroup.CollaborationType = 'Public';
        cgroup.IsArchived = false;
        cgroup.IsAutoArchiveDisabled = false;
        return cgroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        List<Product2> productList = new List<Product2>();
        List<Schema.PickListEntry> pEntries = Constants.PRODUCT_FAMILY; 
        Integer pVal = 0;
        for(Integer i=0; i<cnt; i++){
            Product2 pd2 = new Product2();
            pd2.Name = 'Product ' + i;
            pd2.IsActive = true;
            pd2.Initial_Inventory__c = 10;
            if(pVal == 4){
                pVal = 0;
            }
            pd2.Family = pEntries.get(pVal).getValue();
            pVal++;
            productList.add(pd2);
        }
        return productList;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PriceBookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PriceBookEntry> pbeList = new List<PriceBookEntry>();
        for(Product2 pd2 : prods){
            PriceBookEntry pbe = new PriceBookEntry();
            pbe.IsActive = true;
            pbe.UnitPrice = 100;
            pbe.Product2Id = pd2.Id;
            pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            pbeList.add(pbe);
        }
        return pbeList;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> accList = new List<Account>();
        for(Integer i=0; i<cnt; i++){
            Account acc = new Account();
            acc.Name = 'Account ' + i;
            accList.add(acc);
        }
        return accList;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
       List<Contact> conList = new List<Contact>();
        for(Integer i=0; i<cnt; i++){
            Contact con = new Contact();
            con.LastName = 'Contact ' + i;
            con.AccountId = accts.get(i).Id;
            conList.add(con);
        }
        return conList;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> ordList = new List<Order>();
        for(Integer i=0; i<cnt; i++){
            Order ord = new Order();
            ord.Name = 'Order ' + i;
            ord.AccountId = accts.get(i).Id;
            ord.EffectiveDate = Date.Today();
            ord.Status = Constants.DRAFT_ORDER_STATUS;
            ord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            ordList.add(ord);
        }
        return ordList;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> orderItems = new List<OrderItem>();
        for(Integer i=0; i<cnt; i++){
            OrderItem oItem = new OrderItem();
            oItem.OrderId = ords.get(i).Id;
            oItem.PricebookEntryId = pbes.get(i).Id;
            oItem.Quantity = Constants.DEFAULT_ROWS;
            oItem.UnitPrice = 10;
            orderItems.add(oItem);
        }
        return orderItems;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        list<Account> accounts = ConstructAccounts(cnt);
        Insert accounts;
        
        list<Contact> contacts = ConstructContacts(cnt, accounts);
        insert contacts;
        
        list<Product2> prods= ConstructProducts(cnt);
        insert prods;
        
        list<PriceBookEntry> entries = ConstructPricebookEntries(prods);
        insert entries;
        
        list<Order> orders = ConstructOrders(cnt, accounts);
        insert orders;
        
        list<OrderItem> ordItems = ConstructOrderItems(cnt, entries, orders);
        insert ordItems;
    }
    
    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered){
        Integer sumQuantity = Integer.valueOf(originalProduct.Quantity_Ordered__c) + qtyOrdered;
        System.assertEquals(updatedProduct.Quantity_Ordered__c, sumQuantity);
        
    }
    
}