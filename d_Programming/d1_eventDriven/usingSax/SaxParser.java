import org.xml.sax.*;
import org.xml.sax.helpers.*;
import java.io.*;

public class SaxParser extends DefaultHandler {
  private Locator docLocator = null;
  private StringBuffer buffer = new StringBuffer(); // create string buffer for collecting characters

  public void setDocumentLocator(Locator locator) {
    docLocator = locator;
  }

  public void startDocument() throws SAXException {
    System.out.println("SAX Event: START DOCUMENT");
  }

  public void endDocument() throws SAXException {
    System.out.println("SAX Event: END DOCUMENT");
  }

  public void startElement(String namespaceURI,
      String localName,
      String qName,
      Attributes attr) throws SAXException {
    int lineNumber = 0;
    if (docLocator != null) {
      lineNumber = docLocator.getLineNumber();
    }
    System.out.println("SAX Event: START ELEMENT[ " + localName + " ]");

    if (lineNumber != 0) {
      System.out.println("(Found at line number: " + lineNumber + ".)");
    }

    for (int i = 0; i < attr.getLength(); i++) {
      System.out.println(" ATTRIBUTE: " + attr.getLocalName(i) + " VALUE: "
          + attr.getValue(i));
    }

    buffer.setLength((0)); // clear string buffer
  }

  public void endElement(String namespaceURI,
      String localName,
      String qName) throws SAXException {
    System.out.print("SAX Event: CHARACTERS[ ");
    System.out.println(buffer.toString());
    System.out.println(" ]");
    System.out.println("SAX Event: END ELEMENT[ " + localName + " ]");
  }

  public void characters(char[] ch,
      int start, int length) throws SAXException {
    // System.out.print("SAX Event: CHARACTERS[ ");
    try {
      // OutputStreamWriter output = new OutputStreamWriter(System.out);
      // output.write(ch, start, length);
      // output.flush();
      // ^instead of collecting from stream and directly printing in console
      buffer.append(ch, start, length);
      // ^store characters into a variable
    } catch (Exception e) {
      e.printStackTrace();
    }
    // System.out.println(" ]");
  }

  public static void main(String[] argv) {
    String inputFile = argv[0];
    System.out.println("Processing '" + inputFile + "'.");
    System.out.println("SAX Events:");
    try {
      XMLReader reader = XMLReaderFactory.createXMLReader();
      SaxParser parser = new SaxParser();
      reader.setContentHandler(parser);
      // reader.setDTDHandler(parser); //for DTD
      // reader.setEntityResolver(parser); //for resolving external entity references
      // within the DTD
      // reader.setProperty("http://xml.org/sax/properties/lexical-handler",
      // lexHandler); //similar to setFeature but working on properties
      // properties like lexical handler and declhandler, DefaultHandler2 implements
      // additionally these extension unlike DefaultHandler(implements the core
      // interfaces)
      reader.setErrorHandler(parser);

      try {
        // to activate validation, set xml/sax/features/validation feature to true.
        reader.setFeature("http://xml.org/sax/features/validation", true);
      } catch (SAXException e) {
        System.err.println("Cannot activate validation");
      }

      reader.parse(new InputSource(
          new FileReader(inputFile)));
    } catch (Exception e) {
      e.printStackTrace();
    }
  }
}