<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml">
  <xsl:output method="html" indent="yes"/>
  <xsl:template match="rss">
    <xsl:text disable-output-escaping="yes">
\&lt;!DOCTYPE html PUBLIC “-//W3C//DTD XHTML 1.0 Strict//EN"
“http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"\&gt;
</xsl:text>
    <html>
      <xsl:apply-templates />
    </html>
  </xsl:template>
  <xsl:template match="channel">
    <head>
      <title>
        <xsl:value-of select="title" />
      </title>
    </head>
    <body>
      <xsl:apply-templates />
    </body>
  </xsl:template>
  <xsl:template match="item">
    <h1><xsl:value-of select="title" /></h1>
    <p><xsl:value-of select="description" /></p>
  </xsl:template>
  <xsl:template match="text()" />
</xsl:stylesheet>