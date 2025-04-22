<?xml version='1.0' encoding='UTF-8'?>
<!-- Dump text -->
<xsl:stylesheet version='2.0' 
  xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:et="http://nl.ijs.si/et"
  exclude-result-prefixes="fn tei et">

  <xsl:output method="text"/>
  
  <xsl:template match="/">
    <xsl:apply-templates select=".//tei:text//tei:ab"/>
  </xsl:template>

  <xsl:template match="tei:ab">
    <xsl:value-of select="normalize-space(.)"/>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

</xsl:stylesheet>
