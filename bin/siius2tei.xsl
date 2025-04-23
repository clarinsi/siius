<?xml version='1.0' encoding='UTF-8'?>
<!-- Copy input TEI to output -->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:tei="http://www.tei-c.org/ns/1.0"
                xmlns="http://www.tei-c.org/ns/1.0"
                xmlns:et="http://nl.ijs.si/et"
                exclude-result-prefixes="tei et">
  <!--xsl:strip-space elements="*"/-->
  <xsl:output method="xml" version="1.0" indent="yes"/>

  <xsl:param name="id"/>
  
  <xsl:param name="today-iso" select="format-date(current-date(), '[Y0001]-[M01]-[D01]')"/>
  <xsl:param name="today" select="format-date(current-date(), '[D]. [M]. [Y]')"/>
  <xsl:param name="stamp">SI-IUS</xsl:param>
  <xsl:param name="version">1.0</xsl:param>
  <xsl:param name="handle">http://hdl.handle.net/11356/1455</xsl:param>

  <xsl:variable name="respStmts">
    <respStmt>
      <persName ref="https://orcid.org/0009-0007-9561-3991">Katja Škrubej</persName>
      <resp xml:lang="sl">Zagotovitev izvirnikov, vodja projekta</resp>
      <resp xml:lang="en">Acquistion of sources, project lead</resp>
    </respStmt>
    <respStmt>
      <persName ref="https://orcid.org/0000-0003-4053-1570">Mateja Jemec Tomazin</persName>
      <resp xml:lang="sl">Popravki</resp>
      <resp xml:lang="en">Corrections</resp>
    </respStmt>
    <respStmt>
      <persName ref="https://orcid.org/0000-0001-6143-6877">Andrej Pančur</persName>
      <resp xml:lang="sl">Struktura TEI</resp>
      <resp xml:lang="en">TEI annotation</resp>
    </respStmt>
    <respStmt>
      <persName ref="https://orcid.org/0000-0002-1560-4099">Tomaž Erjavec</persName>
      <resp xml:lang="sl">Popravki, jezikoslovna obdelava</resp>
      <resp xml:lang="en">Fixes, linguistic processing</resp>
    </respStmt>
  </xsl:variable>

  <xsl:variable name="funders">
    <funder>
      <orgName xml:lang="sl">Slovenska digitalna raziskovalna infrastruktura za umetnost in humanistiko DARIAH-SI</orgName>
      <orgName xml:lang="en">The Slovenian Digital Research Infrastructure for the Arts and Humanities DARIAH-SI</orgName>
    </funder>
    <funder>
      <orgName xml:lang="sl">Slovenska raziskovalna infrastruktura CLARIN.SI</orgName>
      <orgName xml:lang="en">The Slovenian research infrastructure CLARIN.SI</orgName>
    </funder>
  </xsl:variable>

  <xsl:template match="tei:TEI">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:attribute name="xml:id" select="$id"/>
      <xsl:apply-templates select="tei:*|text()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:teiHeader">
    <xsl:variable name="titlePage" select="/tei:TEI/tei:text/tei:front/tei:titlePage[1]"/>
    <xsl:variable name="docDate">
      <xsl:choose>
        <xsl:when test="$titlePage//tei:docDate">
          <xsl:value-of select="replace($titlePage//tei:docDate, '\.$', '')"/>
        </xsl:when>
        <xsl:when test="contains($id, '1917')">
          <xsl:text>1917</xsl:text>
        </xsl:when>
        <xsl:when test="contains($id, '1920')">
          <xsl:text>1920</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">No docDate found!</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="docTitle-text">
      <xsl:choose>
        <xsl:when test="$titlePage/tei:docTitle">
          <xsl:apply-templates mode="text" select="$titlePage/tei:docTitle"/>
        </xsl:when>
        <xsl:when test="/tei:TEI/tei:text/tei:body/tei:div[1]/tei:head">
          <xsl:apply-templates mode="text" select="/tei:TEI/tei:text/tei:body/tei:div[1]/tei:head[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message terminate="yes">No docTitle found!</xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <teiHeader>
      <fileDesc>
        <titleStmt>
          <title>
            <!--xsl:value-of select="normalize-space(et:sent-case($docTitle-text))"/-->
            <xsl:value-of select="normalize-space($docTitle-text)"/>
            <xsl:value-of select="concat(' (', $docDate, ')')"/>
            <xsl:value-of select="concat(' [', $stamp, ']')"/>
          </title>
          <!--author>...</author-->
          <xsl:copy-of select="$respStmts"/>
          <xsl:copy-of select="$funders"/>
        </titleStmt>
        <editionStmt>
          <edition>
            <xsl:value-of select="$version"/>
          </edition>
      </editionStmt>
      <publicationStmt>
        <publisher>
          <orgName xml:lang="sl">Slovenska digitalna raziskovalna infrastruktura za umetnost in humanistiko DARIAH-SI</orgName>
          <orgName xml:lang="en">The Slovenian Digital Research Infrastructure for the Arts and Humanities DARIAH-SI</orgName>
        </publisher>
        <distributor>CLARIN.SI</distributor>
        <idno type="handle">
          <xsl:value-of select="$handle"/>
        </idno>
        <availability status="free">
          <licence>http://creativecommons.org/licenses/by/4.0/</licence>
          <p xml:lang="sl">To delo je ponujeno pod
          <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Priznanje avtorstva 4.0 mednarodna licenca</ref>.</p>
          <p xml:lang="en">This work is licensed under the
          <ref target="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</ref>.</p>
        </availability>
        <date when="{$today-iso}">
          <xsl:value-of select="$today"/>
        </date>
      </publicationStmt>
      <sourceDesc>
        <bibl>
          <xsl:choose>
            <xsl:when test="/tei:TEI/tei:text/tei:body/tei:div[1]/tei:head = 'Slovenski Pravnik.' or
                            /tei:TEI/tei:text/tei:body/tei:div[2]/tei:head/text()[1] = 'SLOVENSKI PRAVNIK.'">
              <title>
                <xsl:value-of select="normalize-space($docTitle-text)"/>
              </title>
              <publisher>Društvo Pravnik</publisher>
              <date when="{$docDate}">
                <xsl:value-of select="$docDate"/>
              </date>
            </xsl:when>
            <xsl:when test="$titlePage//tei:docTitle/tei:titlePart">
              <!--author>...</author-->
              <title>
                <xsl:value-of select="normalize-space($docTitle-text)"/>
              </title>
              <xsl:variable name="publisher">
                <!-- Here we fake it, as we have currently only two publishers, but written in many different ways -->
                <xsl:choose>
                  <xsl:when test="$id = 'ODZ1928' or $id = 'ZKP1929'">
                    <xsl:text>Tiskovna zadruga v Ljubljani</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text>Društvo Pravnik</xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:if test="normalize-space($publisher)">
                <publisher>
                  <xsl:value-of select="normalize-space(et:cap-case($publisher))"/>
                </publisher>
              </xsl:if>
              <xsl:variable name="pubPlace" select="$titlePage//tei:docImprint/tei:pubPlace"/>
              <xsl:if test="normalize-space($pubPlace)">
                <pubPlace>
                  <!-- LJUBLJANI -> Ljubljana -->
                  <xsl:value-of select="normalize-space(replace(et:title-case($pubPlace), 'i$', 'a'))"/>
                </pubPlace>
              </xsl:if>
              <date when="{$docDate}">
                <xsl:value-of select="$docDate"/>
              </date>
            </xsl:when>
            <xsl:otherwise>
              <xsl:message terminate="yes">No docTitle found!</xsl:message>
            </xsl:otherwise>
          </xsl:choose>
        </bibl>
        <xsl:apply-templates select="tei:fileDesc/tei:sourceDesc/tei:listWit"/>
      </sourceDesc>
      </fileDesc>
      <encodingDesc>
        <projectDesc>
          <p xml:lang="sl">Projekt zbira besedila starejših pravnih dokumentov v slovenskem jeziku.</p>
          <p xml:lang="en">The project collects texts of older Slovenian legal documents.</p>
        </projectDesc>
      </encodingDesc>
      <profileDesc>
        <langUsage>
          <language ident="sl" xml:lang="sl">slovenski</language>
          <language ident="en" xml:lang="sl">angleški</language>
          <language ident="de" xml:lang="sl">nemški</language>
          <language ident="sl" xml:lang="en">Slovenian</language>
          <language ident="en" xml:lang="en">English</language>
          <language ident="de" xml:lang="en">German</language>
        </langUsage>
      </profileDesc>
      <revisionDesc>
        <change when="{$today-iso}"><name>Tomaž Erjavec</name>: modifikacije TEI.</change>
        <xsl:if test=".//tei:revisionDesc//tei:change">
          <xsl:for-each select=".//tei:revisionDesc//tei:change">
            <change>
              <xsl:attribute name="when" select="replace(tei:date, 'T.+', '')"/>
              <xsl:copy-of select="tei:name"/>
              <xsl:text>: </xsl:text>
              <xsl:choose>
                <xsl:when test="normalize-space(tei:name/following-sibling::text())">
                  <xsl:value-of select="normalize-space(tei:name/following-sibling::text())"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>urejanje besedila v Wordu.</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </change>
          </xsl:for-each>
        </xsl:if>
      </revisionDesc>
    </teiHeader>
  </xsl:template>

<!-- These do not belong in our edition (not all have them if nothing else) -->
  <xsl:template match="tei:divGen"/>
  
  <!-- Empty div excpet for pb -->
  <!-- Maybe we don't want this removal if pbs really correspond to PDF pbs -->
  <!--xsl:template match="tei:div[tei:pb]">
    <xsl:if test="tei:*[name() != 'pb']">
      <xsl:copy>
        <xsl:apply-templates select="@*"/>
        <xsl:apply-templates select="tei:*|text()"/>
      </xsl:copy>
    </xsl:if>
  </xsl:template-->
  
  <!-- Not sure what this is supposed to mean -->
  <xsl:template match="tei:hi[@rend='footnote_reference']">
    <xsl:apply-templates/>
  </xsl:template>

  <!-- Not sure why this is so encoded -->
  <xsl:template match="tei:seg[@rend='bold']">
    <xsl:choose>
      <xsl:when test="@rend">
        <hi rend="{@rend}">
          <xsl:apply-templates/>
        </hi>
      </xsl:when>
      <xsl:when test="@style">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="yes">
          <xsl:text>Weird segment </xsl:text>
          <xsl:value-of select="."/>
        </xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="tei:date">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:choose>
        <xsl:when test="not(normalize-space) and matches(@when, '^\d\d\d\d-\d\d-\d\d$')">
          <xsl:value-of select="format-date(@when, '[D]. [M]. [Y]')"/>
        </xsl:when>
        <xsl:when test="not(normalize-space) and @when">
          <xsl:value-of select="@when"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="tei:*|text()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="tei:lb | tei:pb">
    <xsl:if test="not(matches(preceding-sibling::text()[1], '\s$'))">
      <xsl:text>&#32;</xsl:text>
    </xsl:if>
    <xsl:copy/>
  </xsl:template>

  <xsl:template match="tei:*">
    <xsl:copy>
      <xsl:apply-templates select="@*"/>
      <xsl:apply-templates select="tei:*|text()"/>
    </xsl:copy>
  </xsl:template>
  <xsl:template match="@*">
    <xsl:copy/>
  </xsl:template>

  <!-- Output plain text of element, chaning lb to space -->
  <xsl:template mode="text" match="tei:lb">
    <xsl:text>&#32;</xsl:text>
  </xsl:template>
  <xsl:template mode="text" match="tei:*">
    <xsl:apply-templates mode="text"/>
  </xsl:template>
  <xsl:template mode="text" match="text()">
    <xsl:value-of select="."/>
  </xsl:template>

  <xsl:function name="et:sent-case">
    <xsl:param name="str"/>
    <xsl:variable name="out">
      <xsl:for-each select="tokenize($str, '\.')">
        <xsl:variable name="first" select="substring(., 1, 1)"/>
        <xsl:variable name="rest" select="substring(., 2)"/>
        <xsl:value-of select="concat(upper-case($first), lower-case($rest))"/>
        <xsl:text>.</xsl:text>
      </xsl:for-each>
    </xsl:variable>
    <xsl:sequence select="$out"/>
  </xsl:function>

  <xsl:function name="et:title-case">
    <xsl:param name="str"/>
    <xsl:variable name="first" select="substring($str, 1, 1)"/>
    <xsl:variable name="rest" select="substring($str, 2)"/>
    <xsl:value-of select="concat(upper-case($first), lower-case($rest))"/>
  </xsl:function>

  <xsl:function name="et:cap-case">
    <xsl:param name="str"/>
    <xsl:variable name="first" select="substring($str, 1, 1)"/>
    <xsl:variable name="rest" select="substring($str, 2)"/>
    <xsl:value-of select="concat(upper-case($first), $rest)"/>
  </xsl:function>

</xsl:stylesheet>
