<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" />
  <xsl:template match="addresses">
    <addresses>
      <xsl:apply-templates select="address" />
    </addresses>
  </xsl:template>
  <xsl:template match="address">
    <address name="{@name}">
      <xsl:analyze-string select="."
          regex="^\s*([^,]+)\s*,\s*([^,]+)\s*,\s*([A-Z]{{2}})\s*(\d{{5}}(\-\d{{4}})?)\s*$">
        <xsl:matching-substring>
          <addressLine1><xsl:value-of select="regex-group(1)"/></addressLine1>
          <city><xsl:value-of select="regex-group(2)"/></city>
          <state><xsl:value-of select="regex-group(3)"/></state>
          <zip><xsl:value-of select="regex-group(4)"/></zip>
        </xsl:matching-substring>
        <xsl:non-matching-substring>
          <xsl:value-of select="." />
        </xsl:non-matching-substring>
      </xsl:analyze-string>
    </address>
  </xsl:template>
</xsl:stylesheet>

<!-- New( xsl:analyze-string) -->
<!-- New( xsl:matching-substring if regex succeeds) -->