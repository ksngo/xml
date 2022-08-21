## RSS
- RDF(resource description framework) Site Summary
- Rich Site Summary
- Really simple syndication
-  RSS 1.0 is based on RDF using the RDF/XML syntax.
-  RSS 2.0 is now more prevalent and uses a simpler XML model.
<rss version="2.0"> suggests RSS2.0 
<rdf:RDF xmlns="http://purl.org/rss/1.0/"> suggests RSS 1.0

## Atoms
-  Atom is the most recent XML feed format and is designed according to known best 
practices on the Web.
<feed> gives away this is Atom

## Syndication Systems
- publish-subscribe pattern
- subscriber tool periodically poll the URL for latest published.

## Aggregator
- Can use aggregator to use SAX (simple api for XML, java or other languages)to parse XML. An Aggregator polls different feeds and merges the entries into a single displays

## transform RSS with XSLT
- XSLT transformations can be used to convert between RSS and another format (XHTML)

RSS 1.0: http://purl.org/rss/1.0/spec  
RSS 2.0: http://blogs.law.harvard.edu/tech/rss  
Atom: www.ietf.org/rfc/rfc4287.txt  
Atom Wiki: www.intertwingly.net/wiki/pie/FrontPage  


