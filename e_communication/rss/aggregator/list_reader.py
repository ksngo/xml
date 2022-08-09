import re

class ListReader:
    """ Reads URIs from file """

    def get_uris(self, filename):
        """ Returns a list of the URIs contained in the named file """
        file = open(filename, 'r')
        text = file.read()
        file.close()

        # get the first block of a Netscape file
        text = text.split('</DL>')[0]

        # get the uris
        pattern = 'http://\S*\w' 
        return re.findall(pattern,text) 

