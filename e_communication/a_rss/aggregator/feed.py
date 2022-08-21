""" feed.py - models syndication feed data
    contains classes Feed, Item
"""

__version__ = '0.1'
__needs__ = '2.3'
__author__ = "D. Ayers"

import email.Utils
import dateutil.parser
import time

BAD_TIME_HANDICAP = 43200

class Feed:
    """ Simple model of a syndication feed data file """
    def __init__(self):
        """ Initialize storage """
        self.items = []
        self.title = ''

    def create_item(self):
        """ Returns a new Item object """
        item = Item()
        item.source = self.title
        self.items.append(item)
        return item

    def __str__(self):
        """ Custom 'toString()' method to pretty-print """ 
        string =''
        for item in self.items:
            string.append(item.__str__())
        return string
        
class Item:
    """ Simple model of a single item within a syndication feed """
    def __init__(self):
        """ Initialize properties to defaults """
        self.title = ''
        self.content = ''
        self.source = '' 
        self.date = time.time() - BAD_TIME_HANDICAP # seconds from the Epoch

        self.author = '' ## Extension 2
        
    def set_rfc2822_time(self, old_date):
        """ Set email-format time """
        try:
            temp = email.Utils.parsedate_tz(old_date)
            self.date = email.Utils.mktime_tz(temp)

        except ValueError:
            print("Bad date : %s" % (old_date))
            
    def set_w3cdtf_time(self, new_date):
        """ Set web-format time """
        try:
            self.date =  time.mktime(dateutil.parser.parse(new_date).timetuple())
        except ValueError:
            print("Bad date : %s" % (new_date))

    def get_formatted_date(self):
        """ Returns human-readable date string """
        return email.Utils.formatdate(self.date, True)
    # RFC 822 date, adjusted to local time

    def __str__(self):
        """ Custom 'toString()' method to pretty-print """ 
        return (self.source + ' : '
            + self.title +'\n'
            + self.content + '\n'
            + self.author + '\n' ## Extension
            + self.get_formatted_date() + '\n')
