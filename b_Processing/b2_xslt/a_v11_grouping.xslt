<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <!-- New(xsl:for-each-group) -->
  <!-- New(select="employees/employee" , referring to input xml(a_v11_employees.xml), change tasks.json input xml) -->
  <!-- New( using current-group() and current-grouping-key() functions) -->
  <xsl:template match="/">
    <employeesByDepartment>
      <xsl:for-each-group select="employees/employee" group-by="@department">
        <!-- sort to process which <department> group first -->
        <xsl:sort select="@department" data-type="text" />
        <department name="{current-grouping-key()}">
          <xsl:apply-templates select="current-group()">
            <xsl:sort select="@lastName" data-type="text" />
            <xsl:sort select="@firstName" data-type="text" />
          </xsl:apply-templates>
        </department>
      </xsl:for-each-group>
    </employeesByDepartment>
  </xsl:template>
  
  <xsl:template match="employee">
    <employee jobTitle="{@jobTitle}">
      <xsl:value-of select="concat(@lastName, ', ', @firstName)"/>
    </employee>
  </xsl:template>
</xsl:stylesheet>