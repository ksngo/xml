""" feed_handler.py - handles SAX events,
    extracting data from feed
    contains class FeedHandler
"""

import xml.sax
import xml.sax.saxutils
import feed
import re
import codecs

# Maximum length of item content
TRIM_LENGTH = 100

# Parser state
IN_NONE = 0
IN_ITEM = 1
IN_CONTENT = 2

# Regular expressions for cleaning data
TAG_PATTERN = re.compile("<(.|\n)+?>")
NEWLINE_PATTERN = re.compile("(<br.*>)|(<p.*>)")
    
# Subclass from ContentHandler in order to gain default behaviors
class FeedHandler(xml.sax.ContentHandler):
    """ Extracts data from feeds, in response to SAX events """
    def __init__(self):
        "Initialize feed object, interpreter state and content"
        self.feed = feed.Feed()
        self.state = IN_NONE
        self.text = ''
        return

# Note: this will also be called by (xhtml) elements in content
    def startElementNS(self, name, qname, attributes): 
        "Identifies nature of element in feed (called by SAX parser)"
        (namespace, localname) = name
        # print attributes
        if self.state != IN_CONTENT:
            self.text = '' # new element, not in content
            
        if localname == 'item' or localname == "entry": # RSS or Atom
            self.current_item = self.feed.create_item()
            self.state = IN_ITEM
            return

        if self.state == IN_ITEM:
            if self.is_content_element(localname):
                self.state = IN_CONTENT
        return

    def characters(self, text): 
        "Accumulates text (called by SAX parser)"
        self.text = self.text + text

    def endElementNS(self, name, qname): 
        "Collects element content, switches state as appropriate (called by SAX parser)"
        (namespace, localname) = name
        
        if localname == 'item' or localname == 'entry': # end of item
            self.state = IN_NONE
            return
        
        if self.state == IN_CONTENT:
            if self.is_content_element(localname): # end of content
                self.current_item.content = self.cleanup_text(self.text) 
                self.state = IN_ITEM
            return # whatever

        # cleanup text - we probably want it
        text = self.cleanup_text(self.text)
        
        if self.state != IN_ITEM: # feed title
            if localname == "title":
                self.feed.title = self.text
            return
    
        # Other children of <item> 


        if localname == "title":
            self.current_item.title = text
            return
                
        if localname == "date" or localname == "updated": # maybe dc:date or atom:updated
            self.current_item.set_w3cdtf_time(text)
            return
        
        if localname == "pubDate": # maybe RSS 2.0
            self.current_item.set_rfc2822_time(text)
            return

# Extension 1
        if localname == "source": # dc:source
            self.current_item.source = '('+self.current_item.source+') '+ text
            return

## Extension 2
        if (localname == "creator" or # dc:creator
            localname == "author" or # RSS 0.9x/2.0
            (localname == "name" and
             namespace == "http://purl.org/atom/ns#") or  
            (localname == "name" and
             namespace == "http://xmlns.com/foaf/0.1/")):
            self.current_item.author = text            
            
    def is_content_element(self, localname):
        "Checks if element may contain item/entry content"
        return (localname == "description" or # most RSS x.x
            localname == "encoded" or # RSS 1.0 content:encoded
            localname == "body" or # RSS 2.0 xhtml:body 
            localname == "content") # Atom 

    def cleanup_text(self, text):
        "Strips material that won't look good in plain text"
        text = text.strip()
        text = text.replace('\n', ' ')
        text = xml.sax.saxutils.unescape(text)
        text = self.process_tags(text)
        text = text.encode('ascii','ignore')
        text = self.trim(text)
        return text

    def process_tags(self, string):
        """ Turns <br/> into \n then removes all <tags> """
        re.sub(NEWLINE_PATTERN, '\n', string)
        return re.sub(TAG_PATTERN, ' ', string)

    def trim(self, text):
        "Trim string length neatly"
        end_space = text.find(' ', TRIM_LENGTH)
        if end_space != -1:
            text = text[:end_space] + " ..."
        else:
            text = text[:TRIM_LENGTH] # hard cut
        return text
            
        

        

