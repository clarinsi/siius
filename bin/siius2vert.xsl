<?xml version="1.0"?>
<!-- Transform siIUS corpus to CQP vertical format -->

<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:tei="http://www.tei-c.org/ns/1.0"
		xmlns:et="http://nl.ijs.si/et/"
		xmlns="http://www.tei-c.org/ns/1.0"
		exclude-result-prefixes="tei fn et">
  <xsl:output method="xml" encoding="utf-8" indent="no" omit-xml-declaration="yes"/>

  <xsl:key name="id" match="tei:*" use="@xml:id"/>
  <xsl:variable name="Root" select="/"/>

  <xsl:template match="@*"/>
  <xsl:template match="text()"/>

  <xsl:param name="taxo-sperator">/</xsl:param>

  <xsl:template match="tei:TEI">
    <xsl:variable name="bibl" select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:bibl"/>
    <xsl:variable name="title">
      <xsl:call-template name="meta">
	<xsl:with-param name="element" select="$bibl/tei:title[1]"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="publisher">
      <xsl:call-template name="meta">
	<xsl:with-param name="element" select="$bibl/tei:publisher"/>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="year">
      <xsl:call-template name="meta">
	<xsl:with-param name="element" select="$bibl/tei:date/@when"/>
      </xsl:call-template>
    </xsl:variable>

    <text id="{@xml:id}" 
	  title="{$title}" year="{$year}" publisher="{$publisher}">
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates/>
    </text>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="tei:text">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template match="tei:front | tei:body | tei:back">
    <xsl:copy>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates/>
    </xsl:copy>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="tei:div">
    <xsl:if test="not(@type)">
      <xsl:message terminate="yes">
	<xsl:text>ERROR: element </xsl:text>
	<xsl:value-of select="name()"/>
	<xsl:text> without @type!</xsl:text>
      </xsl:message>
    </xsl:if>
    <xsl:element name="{@type}">
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates/>
    </xsl:element>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <xsl:template match="tei:ab">
    <p type="{@type}" id="{@id}">
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates/>
    </p>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>
  
  <xsl:template match="tei:gap">
    <xsl:if test="not(following-sibling::tei:*[1]/self::tei:gap)">
      <xsl:copy/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:template>
  
  <xsl:template match="tei:s">
    <xsl:copy>
      <xsl:attribute name="id" select="@xml:id"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:apply-templates/>
    </xsl:copy>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- Tokens -->
  <xsl:template match="tei:pc | tei:w">
    <xsl:value-of select="concat(.,'&#9;',et:output-annotations(.))"/>
    <!--xsl:call-template name="deps">
      <xsl:with-param name="type">UD-SYN</xsl:with-param>
    </xsl:call-template-->
    <xsl:text>&#10;</xsl:text>
    <xsl:if test="@join='right'">
      <g/>
      <xsl:text>&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <xsl:template name="deps">
    <xsl:param name="type">UD-SYN</xsl:param>
    <xsl:variable name="id" select="@xml:id"/>
    
    <xsl:variable name="s" select="ancestor::tei:s"/>
    <xsl:choose>
      <xsl:when test="$s/tei:linkGrp[@type=$type]">
	<xsl:variable name="link"
		      select="$s/tei:linkGrp[@type=$type]/tei:link
			      [fn:ends-with(@target,concat(' #',$id))]"/>
	<xsl:variable name="label" select="substring-after($link/@ana,'ud-syn:')"/>
	<xsl:value-of select="concat('&#9;',$label)"/>
	<xsl:variable name="target" select="key('id', fn:replace($link/@target,'#(.+?) #.*','$1'))"/>
	<xsl:choose>
	  <xsl:when test="$target/self::tei:s">
	    <xsl:text>&#9;-&#9;-&#9;-&#9;-&#9;-</xsl:text>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="concat('&#9;',et:output-annotations($target))"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>WARN: sentence without syntax!</xsl:message>
	<xsl:text>&#9;-&#9;-&#9;-&#9;-&#9;-&#9;-</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:function name="et:output-annotations">
    <xsl:param name="token"/>
    <xsl:variable name="id" select="$token/@xml:id"/>
    <xsl:variable name="n" select="replace($id, '.+\.(t\d+)$', '$1')"/>
    <xsl:variable name="lemma">
      <xsl:choose>
	<xsl:when test="$token/@lemma">
	  <xsl:value-of select="$token/@lemma"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="substring($token,1,1)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="msd" select="substring-after($token/@ana,'mte:')"/>
    <xsl:variable name="ud-pos" select="replace(replace($token/@msd, 'UPosTag=', ''), '\|.+', '')"/>
    <xsl:variable name="ud-feats">
      <xsl:variable name="fs" select="replace($token/@msd, 'UPosTag=[^|]+\|?', '')"/>
      <xsl:choose>
	<xsl:when test="normalize-space($fs)">
	  <xsl:value-of select="replace($fs, '\|', ' ')"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:text>-</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:sequence select="concat($lemma, '&#9;', $msd, '&#9;', $ud-pos, '&#9;', $ud-feats,
			  '&#9;', $n)"/>
  </xsl:function>

  <xsl:template name="meta">
    <xsl:param name="element"/>
    <xsl:choose>
      <xsl:when test="starts-with($element,'#')">
	<xsl:value-of select="substring-after($element,'#')"/>
      </xsl:when>
      <xsl:when test="normalize-space($element)">
	<xsl:value-of select="normalize-space(fn:replace($element,' / ','/'))"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>-</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
