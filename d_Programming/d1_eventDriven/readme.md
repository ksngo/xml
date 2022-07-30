
Instead of loading file to memory completely, file is processes in sequence.  
Processing a file sequentially with event-driven paradigm.  

Two ways:  
1. SAX (simple api for XML) => java 
- SAX relies on events(e.g. startDocument, startElement)(events that are provided by SAX) being fired as content is ecountered when a document is read sequentially.  
2. .Net XMLReader => .Net
- also read document sequentially, but does not fire events, but developer can pinpoint a target(e.g. reader.NodeType = XmlNodeType.Element && reader.Name == "Person")  

Running SAX:  
javac SaxParser.java => compile to binary class file  
java SaxParser People.xml => runs binary file with argument of xml file  

Running XMLReader
C:\Windows\Microsoft.NET\Framework\v4.0.30319\csc program.cs => compile to binary file  
./program => to run .exe file  