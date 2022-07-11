<xsl:stylesheet version="2.0" 
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:myData="http://wrox.com/namespaces/embeddedData"
                xmlns:myFunc="http://wrox.com/namespaces/functions/datetime"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="myFunc">
    <!-- New( add XMLSchema namespace for xs:string, xs:integer), (compare with a_v8.xslt) -->
    <!-- New( create namespace for the new function ) -->
    <!-- New( exclude-result-prefixes will ensure that xmlns:myFunc name space does not appear in the output XML) -->
    <!-- rest of XSLT here -->
    <xsl:variable name="thisDocument" select="document('')" />
    <myData:Months>
        <Month index="1">January</Month>
        <Month index="2">February</Month>
        <Month index="3">March</Month>
        <Month index="4">April</Month>
        <Month index="5">May</Month>
        <Month index="6">June</Month>
        <Month index="7">July</Month>
        <Month index="8">August</Month>
        <Month index="9">September</Month>
        <Month index="10">October</Month>
        <Month index="11">November</Month>
        <Month index="12">December</Month>
    </myData:Months>
    
    
    <xsl:template match="/">
        <!-- basic output here -->
        <html>
            <head>
                <title>Famous People</title>
            </head>
            <body>
                <h1>Famous People</h1>
                <hr />
                <xsl:apply-templates select="People/Person" mode="menu">
                    <xsl:sort select="translate(@bornDate, '-', '')" data-type="number"/>
                </xsl:apply-templates>
                <hr />
        
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
                        <!-- <xsl:apply-templates select="People/Person" /> -->
                        <xsl:apply-templates select="People/Person" mode="details">
                            <xsl:sort
                                select="translate(@bornDate, '-', '')" data-type="number"/>
                        </xsl:apply-templates>
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
    
    <xsl:template match="Person" mode="menu">
        <a href="#Person{position()}">
            <xsl:value-of select="Name" />
        </a>
        <br />
    </xsl:template>
    
    <xsl:template match="Person" mode="details">
        <!-- match attribute is XSL pattern and not XPath expression -->
        <xsl:variable name="nameCSS">
            <xsl:if 
                test="number(substring(@bornDate, 1, 2)) = 19">color:red</xsl:if>
        </xsl:variable>
        
        <xsl:variable name="rowCSS">
            <xsl:choose>
                <xsl:when test="position() mod 2 = 0">color:#0000aa;</xsl:when>
                <xsl:otherwise>color:#006666;</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <tr style="{$rowCSS}">
            <td style="{$nameCSS}">
                <!-- <xsl:value-of select="Name" /> -->
                <a name="Person{position()}">
                    <xsl:value-of select="Name" />
                </a>
            </td>
            <td>
                <!-- <xsl:call-template name="iso8601DateToDisplayDate">
                    <xsl:with-param
                        name="iso8601Date" select="@bornDate" />
                </xsl:call-template> -->
                <!-- New(simply use function compared with old template style) -->
                <xsl:value-of select="myFunc:iso8601DateToDisplayDate(@bornDate)" />
            </td>
            <!-- call template(name="xxx") with param(name="iso8601Date") as @bornDate data -->
            <td>
                <!-- <xsl:call-template name="iso8601DateToDisplayDate">
                    <xsl:with-param 
                        name="iso8601Date" select="@diedDate" />
                </xsl:call-template> -->
                <xsl:value-of select="myFunc:iso8601DateToDisplayDate(@diedDate)" />
            </td>
            <!-- <td>
                 <xsl:value-of select="@diedDate" />
                 </td> -->
            <td>
                <xsl:value-of select="Description" />
            </td>
        </tr>
    </xsl:template>
    <!-- <xsl:template name="iso8601DateToDisplayDate">
         <xsl:param name="iso8601Date" />
         <xsl:variable name="yearPart" select="substring($iso8601Date, 1, 4)" />
         <xsl:variable name="monthPart" select="substring($iso8601Date, 6, 2)" />
         <xsl:variable name="monthName" select="$thisDocument/xsl:stylesheet/myData:Months/Month[@index = number($monthPart)]" />
         <xsl:variable name="datePart" select="substring($iso8601Date, 9, 2)" />
         <xsl:value-of select="concat($datePart, '/', $monthName, '/', $yearPart)" />
         </xsl:template> -->
    
    <!-- New(xsl:function instead of xsl:template) -->
    <!-- New(add myFunc namespace to name of function) -->
    <!-- New(declare the return type in as attribute) -->
    <xsl:function name="myFunc:iso8601DateToDisplayDate" as="xs:string">
        <xsl:param name="iso8601Date" as="xs:date" />
        <xsl:variable name="yearPart" select="year-from-date($iso8601Date)" as="xs:integer" />
        <xsl:variable name="monthPart" select="month-from-date($iso8601Date)" as="xs:integer" />
        <xsl:variable name="monthName" select="$thisDocument/xsl:stylesheet/myData:Months/Month[@index = number($monthPart)]"/>
        <xsl:variable name="datePart" select="day-from-date($iso8601Date)" as="xs:integer" />
        <xsl:value-of select="concat($datePart, ' ', $monthName, ' ', $yearPart)" />
    </xsl:function>
    <!-- end New -->
    </xsl:stylesheet>
    
    <!-- Configure task, choose xslt-js: Saxon-JS Transform (New) -->
    <!-- run build task (ctrl+shift+B), to run task in .vscode/tasks.json -->
    <!-- Executing task: C:\Program Files\nodejs\npx.cmd xslt3 
         -xsl: ..xml_repo\b_Processing\b2_xslt\a_v4.xslt 
         -s: ..xml_repo/b_Processing/b2_xslt/a.xml 
         -o: ..xml_repo/xslt-out/result1.xml  -->