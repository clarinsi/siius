<?xml version='1.0' encoding='UTF-8'?>
<!-- Simplify DARIAH-SI Digital Library structure, so its text can be analysed -->
<xsl:stylesheet version='2.0' 
  xmlns:xsl = "http://www.w3.org/1999/XSL/Transform"
  xmlns:fn="http://www.w3.org/2005/xpath-functions"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns="http://www.tei-c.org/ns/1.0"
  xmlns:et="http://nl.ijs.si/et"
  exclude-result-prefixes="fn tei et">

  <xsl:output indent="yes"/>
  
  <xsl:variable name="listPrefixDef">
    <listPrefixDef>
      <prefixDef ident="mte" matchPattern="(.+)"
                 replacementPattern="http://nl.ijs.si/ME/V6/msd/tables/msd-fslib-sl.xml#$1">
        <p xml:lang="sl">Zasebni naslovi URI s to predpono kažejo na element fs, ki definirajo oblikoskladenjske oznake <ref target="http://nl.ijs.si/ME/V6/">MULTEXT-East V6</ref>.</p>
        <p xml:lang="en">Private URIs with this prefix point to feature-structure elements defining the morphosyntactic tagset of <ref target="http://nl.ijs.si/ME/V6/">MULTEXT-East V6</ref>.</p>
      </prefixDef>
    </listPrefixDef>
  </xsl:variable>

  <xsl:variable name="appInfo">
    <appInfo>
      <application version="2.2" ident="classla">
        <label>CLASSLA</label>
        <desc xml:lang="en">MSD tagging, lemmatisation and UD dependency parsing with CLASSLA (a fork of StanfordNLP) trained for Slovene, available from <ref target="https://github.com/clarinsi/classla">https://github.com/clarinsi/classla</ref>.</desc>
      </application>
    </appInfo>
  </xsl:variable>
  
  <xsl:template match="/">
    <xsl:variable name="pass1">
      <xsl:apply-templates/>
    </xsl:variable>
    <xsl:apply-templates mode="pass2" select="$pass1"/>
  </xsl:template>


  <xsl:template mode="pass2" match="tei:teiHeader">
    <xsl:copy-of select="."/>
  </xsl:template>

  <!-- Flatten recursive abs -->
  <xsl:template mode="pass2" match="tei:ab[tei:ab]">
    <xsl:variable name="type" select="@type"/>
    <xsl:for-each-group select="node()" group-starting-with="tei:ab">
      <xsl:for-each select="current-group()">
	<xsl:choose>
	  <xsl:when test="self::tei:ab">
	    <xsl:apply-templates mode="pass2" select="."/>
	  </xsl:when>
	  <xsl:when test="self::text() and normalize-space(.)">
	    <ab type="{$type}">
	      <xsl:value-of select="normalize-space(.)"/>
	    </ab>
	  </xsl:when>
	  <xsl:otherwise>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:for-each>
    </xsl:for-each-group>
  </xsl:template>

  <xsl:template mode="pass2" match="tei:*[tei:*]" priority="-1">
    <xsl:variable name="text">
      <xsl:for-each select="text()">
	<xsl:value-of select="."/>
      </xsl:for-each>
    </xsl:variable>
    <xsl:if test="normalize-space($text)">
      <xsl:message>
	<xsl:text>ERROR: mixed content element </xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:text>: </xsl:text>
	<xsl:value-of select="text()[normalize-space(.)]"/>
      </xsl:message>
    </xsl:if>
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates mode="pass2"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="pass2" match="tei:*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates mode="pass2"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="pass2" match="text()">
    <xsl:if test="normalize-space(.)">
      <xsl:choose>
	<!-- orphan text -->
	<xsl:when test="ancestor::tei:text and ../tei:*">
	  <ab type="text">
	    <xsl:value-of select="normalize-space(.)"/>
	  </ab>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="normalize-space(.)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <!-- Pass1 -->
  <xsl:template match="tei:TEI | tei:text">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:teiHeader">
    <xsl:apply-templates mode="header" select="."/>
  </xsl:template>

  <xsl:template match="tei:front | tei:body | tei:back">
    <xsl:if test=".//tei:div">
      <xsl:copy>
	<xsl:apply-templates select="@*"/>
	<xsl:apply-templates/>
      </xsl:copy>
    </xsl:if>
  </xsl:template>

  <!-- Of course, very problematic! - maybe move it to end of text, like back, call it floatingText!?! -->
  <!-- Now divs are deeply nested there, div6 etc, even though no div1 .. div5, cf. CPZ -->
  <xsl:template match="tei:floatingText">
    <xsl:if test=".//tei:div">
      <div type="floatingText">
	<xsl:apply-templates select="@*"/>
	<xsl:apply-templates select=".//tei:div"/>
      </div>
    </xsl:if>
  </xsl:template>

  
  <xsl:template match="tei:table | tei:row | tei:list |
		       tei:dateline | tei:span | tei:label | tei:cit | tei:signed">
    <!-- Do these in second row make sense - they are used only a couple of times in 1 work -->
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:placeName | tei:date | tei:quote">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- seg is (mis)used for hi -->
  <xsl:template match="tei:hi | tei:seg">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="tei:titlePage">
    <gap/>
  </xsl:template>
  
  <xsl:template match="tei:divGen | tei:milestone | tei:pb | tei:lb | tei:gap"/>
  
  <!-- These are output in another mode -->
  <xsl:template match="tei:note"/>
  
  <!-- Give default @type -->
  <xsl:template match="tei:div">
    <xsl:copy>
      <xsl:apply-templates select="@xml:id"/>
	<xsl:attribute name="type">
	  <xsl:choose>
	    <xsl:when test="@type">
	      <xsl:value-of select="@type"/>
	    </xsl:when>
	    <xsl:when test="ancestor::tei:floatingText">
	      <xsl:value-of select="concat(name(),
				    count(ancestor::tei:div[ancestor::tei:floatingText]))"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="concat(name(),
				    count(ancestor::tei:div))"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:attribute>
      <xsl:apply-templates/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:opener | tei:closer | tei:docAuthor | tei:bibl">
    <xsl:choose>
      <xsl:when test="../tei:div">
	<div type="{name()}">
	  <xsl:apply-templates select="@*[not(name()='rend')]"/>
	  <ab type="{name()}">
	    <xsl:apply-templates/>
	  </ab>
	</div>
      </xsl:when>
      <xsl:when test="parent::tei:p">
	<xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
	<ab type="{name()}">
	  <xsl:apply-templates select="@*[not(name()='rend')]"/>
	  <xsl:apply-templates/>
	</ab>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Collapse p-like elements to p -->
  <xsl:template match="tei:p |
		       tei:ab | tei:head | tei:item | tei:cell">
    <ab>
      <xsl:apply-templates select="@xml:id"/>
      <xsl:attribute name="type">
	<xsl:choose>
	  <xsl:when test="@type">
	    <xsl:value-of select="@type"/>
	  </xsl:when>
	  <xsl:when test="self::tei:p">text</xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="name()"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <!-- Move note out -->
      <xsl:apply-templates/>
    </ab>
    <xsl:apply-templates mode="note" select=".//tei:note"/>
  </xsl:template>

  <xsl:template match="tei:*">
    <xsl:message>
      <xsl:text>WARN: unexpected element </xsl:text>
      <xsl:value-of select="name()"/>
    </xsl:message>
  </xsl:template>

  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

  <!-- Note must contain at least 1 paragraph-like element -->
  <xsl:template mode="note" match="tei:note">
    <xsl:copy>
      <xsl:apply-templates select="@xml:id | @n | @place"/>
      <xsl:attribute name="type">
	<xsl:choose>
	  <xsl:when test="@type">
	    <xsl:value-of select="@type"/>
	  </xsl:when>
	  <xsl:otherwise>footnote</xsl:otherwise>
	</xsl:choose>
      </xsl:attribute>
      <xsl:choose>
	<!-- What about tei:head or .//tei:item or .//tei:cell or mixed content? -->
	<xsl:when test="tei:p or tei:ab">
	  <xsl:apply-templates/>
	</xsl:when>
	<xsl:otherwise>
	  <ab type="text">
	    <xsl:apply-templates/>
	  </ab>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <!-- Process teiHeader -->
  <xsl:template mode="header" match="tei:titleStmt/tei:title[1]">
    <xsl:copy>
      <xsl:value-of select="replace(., 'SI-IUS', 'SI-IUS.crp')"/>
    </xsl:copy>
  </xsl:template>
  
  <xsl:template mode="header" match="tei:encodingDesc">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates mode="header"/>
      <xsl:copy-of select="$listPrefixDef"/>
      <xsl:copy-of select="$appInfo"/>
    </xsl:copy>
    </xsl:template>
  
  <xsl:template mode="header" match="tei:*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates mode="header"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template mode="header" match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

</xsl:stylesheet>
