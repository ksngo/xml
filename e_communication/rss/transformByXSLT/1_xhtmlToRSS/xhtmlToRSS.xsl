<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:xhtml="http://www.w3.org/1999/xhtml">
<xsl:output method="xml" indent="yes"/>
<xsl:template match="/xhtml:html">
<rss version="2.0">
<channel>
<description>This will not change</description>
<link>http://example.org</link>
<xsl:apply-templates />
</channel>
</rss>
</xsl:template>
<xsl:template match="xhtml:title">
<title>
<xsl:value-of select="." />
</title>
</xsl:template>
<xsl:template match="xhtml:body/xhtml:h1">
<item>
<title>
<xsl:value-of select="." />
</title>
<description>
<xsl:value-of select="following-sibling::xhtml:p" />
</description>
</item>
</xsl:template>
<xsl:template match="text()" />
</xsl:stylesheet>