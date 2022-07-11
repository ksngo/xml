<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:myData="http://wrox.com/namespaces/embeddedData">
    <!-- rest of XSLT here -->
    <!-- NEW( xsl:include , modularise xslt ) -->
    <xsl:include href="a_v7_1.xslt" />
  
    <xsl:template match="/">
        <!-- basic output here -->
        <html>
            <head>
                <title>Famous People</title>
            </head>
            <body>
                <table>
                    <caption>Famous People</caption>
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Born</th>
                            <th>Died</th>
                            <th>Description</th>
                        </tr>
                    </thead>
                    <tbody>
                        <xsl:apply-templates select="People/Person" />
                    </tbody>
                </table>
                
                <!-- select attribute is XPath expression -->
                <!--  
                     (1) alternatively of push processing by xsl:apply-templates(to draw data from People/Person) and xsl:template match(pushing data in)
                     (2) following is pull processing(pulling into xsl:for-each) without need of further xsl: template match
                     <xsl:for-each select="People/Person">
                     <li>
                     <xsl:value-of select="Name" />
                     </li>
                     </xsl:for-each>
                -->
            </body>
        </html>
    </xsl:template>
    <xsl:template match="Person">
        <!-- match attribute is XSL pattern and not XPath expression -->
        <!-- NEW -->
        <xsl:variable name="nameCSS">
            <xsl:if 
                test="number(substring(@bornDate, 1, 2)) = 19">color:red</xsl:if>
        </xsl:variable>
        
        <!-- NEW -->
        <xsl:variable name="rowCSS">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">color:#0000aa;</xsl:when>
                <xsl:otherwise>color:#006666;</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <tr style="{$rowCSS}">
            <td style="{$nameCSS}">
                <xsl:value-of select="Name" />
            </td>
            <td>
                <xsl:call-template name="iso8601DateToDisplayDate">
                    <xsl:with-param
                        name="iso8601Date" select="@bornDate" />
                </xsl:call-template>
            </td>
            <!-- call template(name="xxx") with param(name="iso8601Date") as @bornDate data -->
            <td>
                <xsl:call-template name="iso8601DateToDisplayDate">
                    <xsl:with-param 
                        name="iso8601Date" select="@diedDate" />
                </xsl:call-template>
            </td>
            <!-- <td>
                 <xsl:value-of select="@diedDate" />
                 </td> -->
            <td>
                <xsl:value-of select="Description" />
            </td>
        </tr>
    </xsl:template>
</xsl:stylesheet>

<!-- Configure task, choose xslt-js: Saxon-JS Transform (New) -->
<!-- run build task (ctrl+shift+B), to run task in .vscode/tasks.json -->
<!-- Executing task: C:\Program Files\nodejs\npx.cmd xslt3 
     -xsl: ..xml_repo\b_Processing\b2_xslt\a_v4.xslt 
     -s: ..xml_repo/b_Processing/b2_xslt/a.xml 
     -o: ..xml_repo/xslt-out/result1.xml  -->