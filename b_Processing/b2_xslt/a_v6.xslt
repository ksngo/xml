<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    <!-- to ensure output is in xml and that are indented -->
    <!-- but, tasks.json resultPath of html comes above this rule  -->
    <xsl:template match="/">
        <People>
            <xsl:apply-templates select="People/Person" />
        </People> 
    </xsl:template>
    <xsl:template match="Person">
    <!-- xsl:value-of select attribute can be an attribute of <Person> ==> @bornDate -->
    <!-- xsl:value-of select attribute can be <Person>'s child's value ==> <Name>xxx</Name> -->
    <!-- xsl:value-of select attribute is "." ==> values in <Person> and its children without attributes -->
        <valueOf>
            <xsl:value-of select="." />
        </valueOf>
        <!-- xsl:copy is just shallow copy <Person> -->
        <copy>
        <!-- NEW (xsl:copy )-->
            <xsl:copy />
        </copy>
        <!-- xsl:copy is deep copy <Person> -->
        <copyOf>
        <!-- NEW (xsl:copy-of) -->
            <xsl:copy-of select="."/>
        </copyOf>
    </xsl:template> 
</xsl:stylesheet>

