""" feed_reader.py main control for the FeedReader application
"""

import urllib
import xml.sax
import list_reader 
import feed_handler
import feed

feedlist_filename = 'feeds.txt'

def main():
    """ Runs the application """
    FeedReader().read(feedlist_filename)
    
class FeedReader:
    """ Controls the reading of feeds """
    def __init__(self):
        """ Initializes the list of items """
        self.all_items = []
        
    def read(self, feedlist_filename):
        """ Reads each of the feeds listed in the file """
        parser = self.create_parser()
    
        feed_uris = self.get_feed_uris(feedlist_filename)
    
        for uri in feed_uris:
            print('Reading '+uri),
            handler = feed_handler.FeedHandler()
            parser.setContentHandler(handler)
            try:
                parser.parse(uri)
                print(' : ' + str(len(handler.feed.items)) + ' items')
                self.all_items.extend(handler.feed.items)
            except xml.sax.SAXParseException:
                print('\n XML error reading feed : '+uri)
                parser = self.create_parser()   
            except urllib.HTTPError:
                print('\n HTTP error reading feed : '+uri)
                parser = self.create_parser()
                
        self.print_items()

    def get_feed_uris(self, filename):
        """ Use the list reader to obtain feed addresses """
        lr = list_reader.ListReader()
        return lr.get_uris(filename)
            
    def create_parser(self):
        """ Creates a namespace-aware SAX parser """
        parser = xml.sax.make_parser()
        parser.setFeature(xml.sax.handler.feature_namespaces, 1)
        return parser

    def newer_than(self, itemA, itemB):
        """ Compares the two items """
        return cmp(itemB.date, itemA.date)
    
    def get_newest_items(self):
        """ Sorts items using the newer_than comparison """
        self.all_items.sort(self.newer_than)
        return self.all_items[:5]
    
    def print_items(self):
        """ Prints the filtered items to console """
        print('\n*** Newest 5 Items ***\n')
        for item in self.get_newest_items():
            print(item)

if __name__ == '__main__':
    """ Program entry point """
    main()

