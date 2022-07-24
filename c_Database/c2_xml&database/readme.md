# 1. MySQL

- opensource has limited xml functions
- store xml as string in mysql and parse using following function
- use ExtractValue
``` SELECT PostId, ExtractValue(Post, '/post/title') Title FROM BlogPost ```
- use UpdateXML
```sql 
UPDATE BlogPost 
SET Post = UpdateXml(Post, '/post/title',     '<title>Faster Than Light?</title>') 
WHERE PostId = 2 
```
- output mysql can be in xml using --xml option
``` mysql -u root -p --xml ```

# 2. microsoft SQL server
## 2.1 FOR XML instruction (returning XML from sql query)
### 2.1.1 FOR XML RAW
```sql
SELECT [PurchaseOrderID],[RevisionNumber],[Status] 
FROM [Purchasing].[PurchaseOrderHeader] 
WHERE [TotalDue] > 300000 
FOR XML RAW
```
```xml
<!-- attribute-centric XML -->
<row PurchaseOrderID="4007" RevisionNumber="13" Status="2">
```
```sql
FOR XML RAW, ELEMENTS;
```
```xml
<!-- element-centric -->
<row>
 <PurchaseOrderID>4007</PurchaseOrderID>
 <RevisionNumber>13</RevisionNumber>
 <Status>2</Status>
</row>
```
```sql
FOR XML RAW, ELEMENTS, ROOT('orders');
```
```xml
<!-- orders element around row element -->
<orders><row>... </row></orders>
```
```sql
FOR XML RAW('order'), ELEMENTS, ROOT('orders');
```
```xml
<!-- change default row to order -->
<orders><order>... </order></orders>
```
```sql
FOR XML RAW('order'), ELEMENTS XSINIL, ROOT('orders');
```
```xml
<!-- using schema instance namespace for nil to ensure elements that have null value are output -->
<orders xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <order>
  <ShipDate xsi:nil="true" />
```
```sql
FOR XML RAW('order'), ELEMENTS XSINIL, ROOT('orders'), XMLSCHEMA;
```
```xml
<!-- ability to add XML schema in output -->
<orders xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
 <xsd:schema targetNamespace="urn:schemas-microsoft-com:sql:SqlRowSet1"
 xmlns:xsd="http://www.w3.org/2001/XMLSchema"
 xmlns:sqltypes="http://schemas.microsoft.com/sqlserver/2004/sqltypes"
 elementFormDefault="qualified">
 <xsd:import namespace="http://schemas.microsoft.com/sqlserver/2004/sqltypes"
 schemaLocation="http://schemas.microsoft.com/sqlserver/2004/sqltypes/sqltypes.xsd" />
 <xsd:element name="order">
 <xsd:complexType>
 <xsd:sequence>
 <xsd:element name="PurchaseOrderID" type="sqltypes:int" nillable="1" />
 <xsd:element name="RevisionNumber" type="sqltypes:tinyint" nillable="1"/>
 <xsd:element name="Status" type="sqltypes:tinyint" nillable="1" />
 <xsd:element name="EmployeeID" type="sqltypes:int" nillable="1" />
 <xsd:element name="VendorID" type="sqltypes:int" nillable="1" />
 <xsd:element name="ShipMethodID" type="sqltypes:int" nillable="1" />
 <xsd:element name="OrderDate" type="sqltypes:datetime" nillable="1" />
 <xsd:element name="ShipDate" type="sqltypes:datetime" nillable="1" />
 <xsd:element name="SubTotal" type="sqltypes:money" nillable="1" />
 <xsd:element name="TaxAmt" type="sqltypes:money" nillable="1" />
 <xsd:element name="Freight" type="sqltypes:money" nillable="1" />
 <xsd:element name="TotalDue" type="sqltypes:money" nillable="1" />
 <xsd:element name="ModifiedDate" type="sqltypes:datetime" nillable="1" />
 </xsd:sequence>
 </xsd:complexType>
 </xsd:element>
 </xsd:schema>
 <order xmlns="urn:schemas-microsoft-com:sql:SqlRowSet1">
 <PurchaseOrderID>4007</PurchaseOrderID>
 <RevisionNumber>14</RevisionNumber>
 <Status>2</Status>
 <EmployeeID>251</EmployeeID>
 <VendorID>1594</VendorID>
 <ShipMethodID>3</ShipMethodID>
 <OrderDate>2008-04-01T00:00:00</OrderDate>
 <ShipDate xsi:nil="true" />
 <SubTotal>554020.0000</SubTotal>
 <TaxAmt>44321.6000</TaxAmt>
 <Freight>11080.4000</Freight>
 <TotalDue>609422.0000</TotalDue>
 <ModifiedDate>2009-09-12T12:25:46.407</ModifiedDate>
 </order>
 <!-- rest of order elements -->
</orders>
```

### 2.1.2 FOR XML AUTO

```sql
SELECT POH.[PurchaseOrderID],POH.[RevisionNumber],POH.[Status]
 FROM [Purchasing].[PurchaseOrderHeader] POH
 INNER JOIN Purchasing.PurchaseOrderDetail POD
 ON POH.PurchaseOrderID = POD.PurchaseOrderID
 WHERE [TotalDue] > 300000
 FOR XML AUTO, ROOT('orders');
```
```xml
<!-- FOR XML AUTO allows two joined tables output with a table being nested in XML-->
<orders>
 <POH PurchaseOrderID="4007" RevisionNumber="16" Status="2">
  <POD OrderQty="5000" ProductID="849" UnitPrice="24.7500" />
  <POD OrderQty="5000" ProductID="850" UnitPrice="24.7500" />
  <POD OrderQty="5000" ProductID="851" UnitPrice="24.7500" />
  <POD OrderQty="750" ProductID="852" UnitPrice="30.9400" />
 </POH>
 <!-- more POH elements -->
</orders>
```

### 2.1.3 FOR XML EXPLICIT (recommend PATH)

### 2.1.4 FOR XML PATH
```sql
 SELECT [PurchaseOrderID] [@PurchaseOrderID]
 ,[Status] [@Status]
 ,[EmployeeID] [@EmployeeID]
 ,[VendorID]
 ,[ShipMethodID]
 FROM [Purchasing].[PurchaseOrderHeader] POH
 WHERE [TotalDue] > 300000
 FOR XML PATH('order'), ROOT('orders'); 
```
```xml
<!-- XML PATH allows mix of attribute-centric and element-centric -->
<orders>
 <order PurchaseOrderID="4007" Status="2" EmployeeID="251">
 <VendorID>1594</VendorID>
 <ShipMethodID>3</ShipMethodID>
 </order>
 <!-- more order elements -->
</orders>
```
```sql
SELECT [POH].[PurchaseOrderID] [@PurchaseOrderID]
 ,[POH].[Status] [@Status]
 ,[POH].[EmployeeID] [@EmployeeID]
 ,[POH].[VendorID] [@VendorID]
 ,(
  SELECT [POD].[OrderQty]
  ,[POD].[ProductID]
  ,[POD].[UnitPrice] 
  FROM [Purchasing].[PurchaseOrderDetail] POD
  WHERE POH.[PurchaseOrderID] = POD.[PurchaseOrderID]
  ORDER BY POD.[PurchaseOrderID]
  FOR XML PATH('orderDetail'), TYPE
 )
FROM [Purchasing].[PurchaseOrderHeader] POH
WHERE [POH].[TotalDue] > 300000
FOR XML PATH('order'), ROOT('orders');
```
```xml
<!-- rather than using SQL JOIN for two tables, can use subquery to show nested elements(from another table) -->
<!-- TYPE ensures data is inserted as XML instead of string -->
<orders>
 <order PurchaseOrderID="4007" Status="2" EmployeeID="251" VendorID="1594">
  <orderDetail>
    <OrderQty>5000</OrderQty>
    <ProductID>849</ProductID>
    <UnitPrice>24.7500</UnitPrice>
  </orderDetail>
  <orderDetail>
    <OrderQty>5000</OrderQty>
    <ProductID>850</ProductID>
    <UnitPrice>24.7500</UnitPrice>
  </orderDetail>
  <!-- more orderDetail elements -->
 </order>
 <!-- more order elements -->
</orders>
```
```sql
SELECT [POH].[PurchaseOrderID] [@PurchaseOrderID]
 ,[POH].[Status] [@Status]
 ,[POH].[EmployeeID] [@EmployeeID]
 ,[POH].[VendorID] [@VendorID]
 ,[POH].[OrderDate] [Dates/Order]
 ,[POH].[ShipDate] [Dates/Ship]
 ,(
  SELECT [POD].[OrderQty]
  ,[POD].[ProductID]
  ,[POD].[UnitPrice] 
  FROM [Purchasing].[PurchaseOrderDetail] POD
  WHERE POH.[PurchaseOrderID] = POD.[PurchaseOrderID]
  ORDER BY POD.[PurchaseOrderID]
  FOR XML PATH('orderDetail'), TYPE
 )
FROM [Purchasing].[PurchaseOrderHeader] POH
WHERE [POH].[TotalDue] > 300000
FOR XML PATH('order'), ROOT('orders');
```
```xml
 <!-- create <Dates><Order>  -->
<orders>
 <order PurchaseOrderID="4008" Status="2" EmployeeID="258" VendorID="1676">
  <Dates>
    <Order>2008-05-23T00:00:00</Order>
    <Ship>2008-06-17T00:00:00</Ship>
  </Dates>
  <orderDetail>
    <OrderQty>700</OrderQty>
    <ProductID>858</ProductID>
    <UnitPrice>9.1500</UnitPrice>
  </orderDetail>
  <!-- more orderDetail elements -->
 </order>
  <!-- more order elements -->
</orders>
```

## 2.2 storing XML within microsoft sql server table 
### 2.2.1 xml data type (ability for sql to store xml data type instead of plain strings)
- in sql server, the XML data modification language(DML)
- example with **modify()** method, (delete, insert, replace value of)
- Note XQuery1.0 is limited to querying XML only. It cannot delete or insert.
- SQL Query, XML DML allows delete, insert, replace value of.
```DML
DECLARE @NewName NVARCHAR(100);
SET @NewName = N'Joseph';
DECLARE @myDoc XML;
SET @myDoc = '<Person><FirstName>Joe</FirstName><LastName>Fawcett</LastName></Person>'
SELECT @myDoc;
SET @myDoc.modify(' replace value of (/Person/FirstName/text())[1] with sql:variable("@NewName") ');
SELECT @myDoc;
```

- example with **query()** method
- syntax follows XQuery syntax
```dml
SELECT XMLDoc.query
('for $p in /Person return
 <Name>{$p/LastName/text()}, {$p/FirstName/text()}</Name>')
FROM Docs;
```

- example with **value()** method
```dml
SELECT * FROM Docs
WHERE XmlDoc.value('(/*/FirstName)[1]', 'nvarchar(100)') = 'Joe';

SELECT DocId, XmlDoc.value('(/*/LastName)[1]', 'nvarchar(100)') LastName 
FROM Docs;
```
- example with **exist()** method
```dml
SELECT * FROM Docs
WHERE XmlDoc.exist('/*/FirstName[. = "Joe"]') = 1;
```
- example with nodes() method
- present XML document as SQL table
- nodes method retrieved the person elements from stored XML
- and saved to TableName(ColumnName). Person is table. FirstName is column in table. 
```dml
DECLARE @People xml;
SET @People = 
'<people><person>Joe</person>
 <person>Danny</person>
 <person>Liam</person></people>'
SELECT FirstName.value('text()[1]', 'nvarchar(100)') FirstName FROM @People.nodes('/*/person') Person(FirstName);
```

### 2.2.2 xml schema (specify schema alongside XML data type)

- advantage 1: schema allows validation check
- advantage 2: queries against the XML will return type data specified from schema instead of generic text.
- SQL server may not recognise W3X XML Schema document(e.g. using references, names types or anonymous types)
- annotations and comments no stored in SQL Server. Need to store serialised XML Schema document in column of type xml or varchar(max) in separate table
```dml
CREATE XML SCHEMA COLLECTION EmployeesSchemaCollection AS 
'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" targetNamespace=
"http://wiley.com/namespaces/Person" xmlns="http://wiley.com/namespaces/Person">
 <xsd:element name="Person">
 <xsd:complexType>
 <xsd:sequence>
 <xsd:element name="FirstName" />
 <xsd:element name="LastName" />
 </xsd:sequence>
 </xsd:complexType>
 </xsd:element>
</xsd:schema>'

DROP XML SCHEMA COLLECTION EmployeesSchemaCollection 

ALTER XML SCHEMA COLLECTION EmployeesSchemaCollection ADD
'<xsd:schema>
 <!--new schema inserted here -->
</xsd:schema>'

CREATE TABLE [dbo].[Docs](
 [DocID] [int] IDENTITY(1,1) PRIMARY KEY,
 [XMLDoc] [xml] (EmployeesSchemaCollection))
```

### 2.2.3 specify namespaces in SQL Server

- **WITH XMLNAMESPACES** statement

- using explicit prefix, x
```dml
DECLARE @NamespacedData xml;
SET @NamespacedData = '<x:data xmlns:x="http://wrox.com/namespaces/examples">
 <x:item id="1">One</x:item>
 <x:item id="2">Two</x:item>
 <x:item id="1">Three</x:item>
 </x:data>';
WITH XMLNAMESPACES ('http://wrox.com/namespaces/examples' as x)
SELECT @NamespacedData.value('(/x:data/x:item[@id = 2])[1]', 'nvarchar(10)') Item;
```
- default namespace
```dml
DECLARE @NamespacedData xml;
SET @NamespacedData = '<data xmlns="http://wrox.com/namespaces/examples">
 <item id="1">One</item>
 <item id="2">Two</item>
 <item id="1">Three</item>
 </data>';
WITH XMLNAMESPACES (DEFAULT 'http://wrox.com/namespaces/examples')
SELECT @NamespacedData.value((/data/item[@id = 2])[1]', 'nvarchar(10)') Item;
```

# 3. eXist XML database 

- designed from ground up to store and manage large numbers of XML