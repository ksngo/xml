## RPC
- remote procedure call
- one computer calling code on another computer.

## RPC Protocols (before webservices, technologies like DCOM, IIOP used for cross-network method requests)
1. DCOM (distributed component object model) , extension of earlier COM
   - COM(microsoft, small components that can share across an application or different applications, e.g. MS excel and words)
   - DCOM extends COM and enable application to call COM objects that reside on remote computers.
2. IIOP(internet inter-ORB Protocol), extension of earlier CORBA(common object request broker architecture)
   - CORBA is platform-neutral
   - COM is provided by Window OS but ORB provides the same functionality
   - IIOP enables communication between diffeerent ORBs
3. Jave RMI(remote method invocation)
   - java write once , run anywhere.

4. Web Services (new RPC protocol)
   - language independent and platform independent of creating distributed applications
   - Same Origin Policy
     - browser access webservice from same origin only by default
    - workaround
      - server-side proxy (server doesn't have same origin restriction, user server-side to pass request to another domain.)
      - script blocks are allowed to pulled from different domain. 
      ```javascript
      <script src="xxx">
      ```
      - IE from version 8 have native object XDomainRequest(similar to XMLHttpRequest) that enables cross-domain request if server has **Access-Control-Allow-Origin** that includes the domain name of request.
      - use Adobe's Flash component to make cross-domain request
      - use Microsoft IIS web server 
   - XML web services two main designs
     - XML-RPC (XML remote procedure)
       - name of method and parameters are wrapped in XML format
          ```xml
                <methodCall>
                  <methodName>MathService.Add</methodName>
                  <params>
                    <param>
                    <value>
                      <struct>
                        <member>
                        <name>Operand1</name>
                          <value>
                          <double>17</double>
                          </value>
          ```
        - can use HTTP POST to call RPC with body containing the xml.
     - document approach
      - XML document as input and format is predefined by an XML Schema
   - REST (another web services after the original XML-RPC web services)
     - representational state transfer, is a framework for creating web services that can, but do not have to, use XML.

## Other WebServices Protocol

- SOAP (Simple Object Access Protocol)
  - XML-based language
  - is more robust than XML-RPC because can use arbitrary XML.
  - has flexibility to represent complex messages that pass along a chain of computers rather than a simple client to server journey. (outshining REST or JSON in this respect.)
  - SOAP messages are basically XML documents, usually sent across HTTP
```xml
  <?xml version="1.0" encoding=“UTF-8"?>
  <SOAP:Envelope xmlns:SOAP="http://www.w3.org/2003/05/soap-envelope">
  <SOAP:Header></SOAP:Header>
  <SOAP:Body>
   <totals xmlns="http://www.wiley.com/SOAP/accounting">
    <dept id="2332">
     <gross>433229.03</gross>
      <net>23272.39</net>
    </dept>
   <dept id="4001">
     <gross>993882.98</gross>
     <net>388209.27</net>
   </dept>
   </totals>
  </SOAP:Body>
  </SOAP:Envelope>
```
  - Envelope is mandatory and is the payload and root element for the xml document.
  - Header is optional.
  - Body is mandatory and contains the main body of SOAP message.
  - WSDL (Web Services Description Language) to describe the SOAP
    - how to call the service
    - what to expect as response from the service
    - written in XML
      - definitions, defines the data to be sent and received.
      - types , allows defines XML schema for the SOAP request.
      - messages, defining the content
      - portType, describe the individual operation provided by the service.
      - binding
        - soap:binding, confirm that this is a SOAP message and transporting via HTTP
        - soap:operation
        - soap:body
      - service
        - specify where and how to send the information
    ```xml
    <?xml version="1.0"?>
      <definitions name="temperature"
        targetNamespace="http://www.example.com/temperature"
        xmlns:typens="http://www.example.com/temperature"
        xmlns:xsd="http://www.w3.org/2000/10/XMLSchema"
        xmlns:soap="http://schemas.xmlsoap.org/wsdl/soap/"
        xmlns="http://schemas.xmlsoap.org/wsdl/">

        <types>
          <xsd:schema xmlns=""
          xmlns:xsd="http://www.w3.org/2000/10/XMLSchema"
          targetNamespace="http://www.example.com/temperature">
            <xsd:complexType name="temperatureRequestType">
              <xsd:sequence>
                <xsd:element name="where" type="xsd:string" />
                <xsd:element name="when" type="xsd:date"/>
            </xsd:sequence>
            </xsd:complexType>
            <xsd:complexType name="temperatureResponseType">
              <xsd:sequence>
                <xsd:element name="temperature" type="xsd:integer"/>
              </xsd:sequence>
            </xsd:complexType>
          </xsd:schema>
        </types>

        <message name="TemperatureRequestMsg">
          <part name="getTemperature"       type="typens:temperatureRequestType"/>
        </message>
        <message name="TemperatureResponseMsg">
          <part name="temperatureResponse" type="typens:temperatureResponseType"/>
        </message>

        <portType name="TemperatureServicePortType">
          <operation name="GetTemperature">
          <input message="typens:TemperatureRequestMsg"/>
          <output message="typens:TemperatureResponseMsg"/>
          </operation>
        </portType>

        <binding name="TemperatureBinding"  type="typens:TemperatureServicePortType">
          <soap:binding style="rpc" transport="http://schemas xmlsoap.org/soap/http"/>
          <operation name="GetTemperature">
          <soap:operation />
          <input>
            <soap:body use="encoded"
            encodingStyle="http://www.w3.org/2003/05/soap-encoding"
            namespace="http://www.example.com/temperature" />
          </input>
          <output>
            <soap:body use="encoded"
            encodingStyle="http://www.w3.org/2003/05/soap-encoding"
            namespace="http://www.example.com/temperature" />
          </output>
          </operation>
        </binding>

        <service name="TemperatureService">
          <port name="TemperaturePort" binding="typens:TemperatureBinding">
          <soap:address location="http://www.example.com/temp/getTemp.asp"/>
          </port>
        </service>

      </definitions>
      
    
    ```
  - UDDI (Universal Discovery, Description and Integration) protocol
