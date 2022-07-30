using System;
using System.Xml;
namespace XmlReaderBasics
{
  internal class Program
  {
    private static void Main(string[] args)
    {
      var xmlUri = "People.xml";
      var reader = DisplayRootElement(xmlUri);
      reader = DisplayPeopleWithDates(reader);
      Console.ReadLine();
    }
    private static XmlReader DisplayRootElement(string uri)
    {
      //XmlReader is abstract class and therefore cannot have an instance
      // var settings = new XmlReaderSettings(); //can add settings when reading
      // settings.IgnoreComments = true;
      // var reader = XmlReader.Create(xmlUri, settings);
      var reader = XmlReader.Create(uri);
      reader.MoveToContent();
      //^ MoveToContent positions the reader's cursor to first content it can find
      var rootElementName = reader.Name;
      Console.WriteLine("Root element name is: {0}", rootElementName);
      return reader;
    }
    private static XmlReader DisplayPeopleWithDates(XmlReader reader)
    {
      while (reader.Read()) //Read() to move through the nodes within XML
      {
        if (reader.NodeType == XmlNodeType.Element
        && reader.Name == "Person")
        {
          DateTime bornDate = new DateTime();
          DateTime diedDate = new DateTime();
          var personName = string.Empty;
          while (reader.MoveToNextAttribute())
          {
            switch (reader.Name)
            {
              case "bornDate":
                bornDate = reader.ReadContentAsDateTime();
                break;
              case "diedDate":
                diedDate = reader.ReadContentAsDateTime();
                break;
            }
          }
          while (reader.Read())
          {
            if (reader.NodeType == XmlNodeType.Element
            && reader.Name == "Name")
            {
              personName = reader.ReadElementContentAsString();
              break;
            }
          }
          Console.WriteLine("{0} was born in {1} and died in {2}",
             personName,
             bornDate.ToShortDateString(),
             diedDate.ToShortDateString());
        }
      }
      return reader;
    }
  }
}