using System;
using System.Xml;
using System.Xml.Schema;
namespace ValidationDemo
{
  internal class Program
  {
    private static void Main(string[] args)
    {
      var xmlUri = "People.xml";
      var targetNamespace =
      "http://wrox.com/namespaces/BeginningXml/People";
      var schemaUri = "PeopleWithNamespace.xsd";
      ValidateDocument(xmlUri, targetNamespace, schemaUri);
      Console.ReadLine();
    }
    private static void ValidateDocument(string uri,
    string targetNamespace,
    string schemaUri)
    {
      var schemaSet = new XmlSchemaSet();
      schemaSet.Add(targetNamespace, schemaUri);
      var settings = new XmlReaderSettings();
      settings.ValidationType = ValidationType.Schema;
      settings.Schemas = schemaSet;
      settings.ValidationEventHandler += ValidationCallback;
      //callback runs whenever validation error occurs
      var reader = XmlReader.Create(uri, settings);
      //instead of returning just a XmlTextReader, with the additional settings
      // will get an XmlValidatingReader
      while (reader.Read()) ; // to start the reading rolling
      Console.WriteLine("Validation complete.");
    }
    private static void ValidationCallback(object sender,
    ValidationEventArgs e)
    {
      Console.WriteLine(
 "Validation Error: {0}\n\tLine number {1}, position {2}.",
 e.Message,
 e.Exception.LineNumber,
 e.Exception.LinePosition);
    }
  }
}