<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:template match="/">
        <personCount>
            <xsl:value-of select="count(People/Person)"/>
        </personCount>
        <xsl:apply-templates select="People/Person" />
    </xsl:template>
    <xsl:template match="Person">
    <!-- New(xsl:result-document to output a new document) -->
        <xsl:result-document href="result_a_v10_Person{position()}.xml">
            <xsl:copy-of select="." />
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>