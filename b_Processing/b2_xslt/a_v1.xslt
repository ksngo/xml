<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <!-- rest of XSLT here -->
    <xsl:template match="/">
        <!-- basic output here -->
        <html>
            <head>
                <title>Famous People</title>
            </head>
            <body>
                <h1>Famous People</h1>
                <hr />
                <ul>
                    <xsl:apply-templates select="People/Person" />
                    <!-- select attribute is XPath expression -->
                    <!--  
                    (1) alternatively of push processing by xsl:apply-templates(to draw data from People/Person) and xsl:template match(pushing data in)
                    (2) following is pull processing(pulling into xsl:for-each) without need of further xsl: template match
                    <xsl:for-each select=”People/Person”>
                        <li>
                            <xsl:value-of select=”Name” />
                        </li>
                    </xsl:for-each>
                    -->
                </ul>
            </body>
        </html>
    </xsl:template>
    <xsl:template match="Person">
    <!-- match attribute is XSL pattern and not XPath expression -->
        <li>
            <xsl:value-of select="Name" />
        </li>
    </xsl:template>
</xsl:stylesheet>

<!-- Configure task, choose xslt-js: Saxon-JS Transform (New) -->
<!-- run build task (ctrl+shift+B), to run task in .vscode/tasks.json -->
<!-- Executing task: C:\Program Files\nodejs\npx.cmd xslt3 
-xsl: ..xml_repo\b_Processing\b2_xslt\a_v1.xslt 
-s: ..xml_repo/b_Processing/b2_xslt/a.xml 
-o: ..xml_repo/xslt-out/result1.xml  -->