<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:html="http://www.w3.org/1999/xhtml"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="tei html"
    version="2.0">
    <!-- import base conversion style -->
    <!--xsl:import href="../default/html/to.xsl"/-->
    <xsl:import href="../../Stylesheets/profiles/default/html/to.xsl"/>

   <!-- Indent only for debugging! -->
   <xsl:output method="xhtml" indent="no" omit-xml-declaration="yes"/>
   <xsl:preserve-space elements="head p li span hi"/>

   <!-- Use local copy -->
   <xsl:param name="cssFile">tei.css</xsl:param>
   <xsl:param name="cssPrintFile">tei-print.css</xsl:param>
   <!--xsl:param name="cssFile">https://www.tei-c.org/release/xml/tei/stylesheet/tei.css</xsl:param-->
   <!--xsl:param name="cssPrintFile">https://www.tei-c.org/release/xml/tei/stylesheet/tei-print.css</xsl:param-->

   <xsl:param name="homeURL">https://github.com/clarinsi/siius</xsl:param>
   <xsl:param name="homeLabel">SI-IUS</xsl:param>
   <xsl:param name="documentationLanguage">sl</xsl:param>

   <xsl:param name="STDOUT">true</xsl:param>
   <!--xsl:param name="STDOUT">false</xsl:param>
   <xsl:param name="outputDir">../docs</xsl:param>
   <xsl:param name="outputName">parla-clarin</xsl:param-->
   <xsl:param name="outputEncoding">utf-8</xsl:param>
   <xsl:param name="splitLevel">-1</xsl:param>
   <xsl:param name="class_toc">toc</xsl:param>
   <xsl:param name="class_subtoc">subtoc</xsl:param>
   <xsl:param name="autoToc">true</xsl:param>
   <xsl:param name="tocFront">true</xsl:param>
   <xsl:param name="tocBack">true</xsl:param>
   <xsl:param name="tocDepth">1</xsl:param>
   <xsl:param name="subTocDepth">5</xsl:param>
   <xsl:param name="numberHeadings">false</xsl:param>
   <xsl:param name="numberFigures">false</xsl:param>
   <xsl:param name="footnoteBackLink">true</xsl:param>
   <xsl:param name="topNavigationPanel">true</xsl:param>
   <xsl:param name="autoEndNotes">true</xsl:param>
   <xsl:param name="pagebreakStyle">visible</xsl:param>
</xsl:stylesheet>
