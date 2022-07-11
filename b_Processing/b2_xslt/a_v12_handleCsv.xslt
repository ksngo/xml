<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema">
  <xsl:param name="dataPath" select="'file:///C:/Users/User/Desktop/new StuffsAfter 24May22/xml_repo/b_Processing/b2_xslt/a_v12.csv'" as="xs:string"/>
  <xsl:variable name="employeesText" select="unparsed-text($dataPath)"
                as="xs:string" />
  <xsl:template name="main">
    <xsl:variable name="lines" select="tokenize($employeesText, '\r?\n')"
                  as="xs:string*" />
    <employees>
      <xsl:for-each select="$lines">
        <employee>
          <xsl:variable name="employeeData" select="tokenize(., ',\s*')"
                        as="xs:string+" />
          <lastName>
            <xsl:value-of select="$employeeData[1]"/>
          </lastName>
          <firstName>
            <xsl:value-of select="$employeeData[2]"/>
          </firstName>
          <jobTitle>
            <xsl:value-of select="$employeeData[3]"/>
          </jobTitle>
        </employee>
      </xsl:for-each>
    </employees>
  </xsl:template>
</xsl:stylesheet>
<!-- "initialTemplate": "main" in tasks.json must be set -->
<!-- New( create param to store the input csv) -->
<!-- New( create variable and use unparsed-text() function ) -->
<!-- New( tokenize() the unparsedText with delimiter '\r?\n' into multiple lines) -->
<!-- New( tokenize() each line with delimiter ',\s*' into [lastName,firstname,jobTitle]) -->

<!-- java saxon.net.sf.Transform 
-it:main 
-xsl:a_v12.xslt 
 dataPath=a_v12.csv 
 -o:output.xml -->