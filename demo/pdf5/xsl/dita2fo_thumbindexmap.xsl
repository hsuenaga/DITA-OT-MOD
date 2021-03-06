<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Make thumb index map.
Copyright © 2009-2009 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="2.0" 
 xmlns:fo="http://www.w3.org/1999/XSL/Format" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 exclude-result-prefixes="xs ahf"
>

<!-- Inner class (used this module)
 -->
<xsl:variable name="cClassPart" select="'part'"/>
<xsl:variable name="cClassChapter" select="'chapter'"/>
<xsl:variable name="cClassAppendix" select="'appendix'"/>
<xsl:variable name="cClassIndex" select="'index'"/>
<xsl:variable name="cClassToc" select="'toc'"/>

<!-- Part & Chapter Map -->
<xsl:variable name="chapterMap">
    <xsl:call-template name="makeChapterMap"/>
</xsl:variable>

<!-- Thumb index map -->
<xsl:variable name="thumbIndexMap">
    <xsl:call-template name="makeThumbIndexMap"/>
</xsl:variable>

<!-- 
 function:	make book chapter map template
 param:		none
 return:	chapter map node
 note:		none
 -->
<xsl:template name="makeChapterMap">
    <xsl:apply-templates select="/*/*[contains(@class, ' map/map ')]
                                   /*[contains(@class, ' map/topicref ')]
                                     [not(contains(@class, ' bookmap/frontmatter '))]
                                     [not(contains(@class, ' bookmap/backmatter '))]
                               | /*/*[contains(@class, ' map/map ')]
                                   /*[contains(@class, ' bookmap/frontmatter ')]
                                  //*[contains(@class, ' bookmap/toc ')]
                               | /*/*[contains(@class, ' map/map ')]
                                   /*[contains(@class, ' bookmap/backmatter ')]
                                  //*[contains(@class, ' bookmap/indexlist ')]"
                         mode="MAKE_CHAPTER_MAP">
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="*[contains(@class, ' bookmap/toc ')]" mode="MAKE_CHAPTER_MAP" priority="2">
    <xsl:element name="chaptermap">
        <xsl:attribute name="id"/>
        <xsl:attribute name="class" select="$cClassToc"/>
        <xsl:attribute name="label" select="$cTocThumbnailLabel"/>
        <xsl:attribute name="title" select="$cTocThumbnailTitle"/>
    </xsl:element>
</xsl:template>

<xsl:template match="*[contains(@class, ' bookmap/indexlist ')]" mode="MAKE_CHAPTER_MAP" priority="2">
    <xsl:element name="chaptermap">
        <xsl:attribute name="id"/>
        <xsl:attribute name="class" select="$cClassIndex"/>
        <xsl:attribute name="label" select="$cIndexThumbnailLabel"/>
        <xsl:attribute name="title" select="$cIndexThumbnailTitle"/>
    </xsl:element>
</xsl:template>

<xsl:template match="*[contains(@class, ' map/topicref ')]" mode="MAKE_CHAPTER_MAP">
    <xsl:variable name="linkSrc" select="."/>
    <xsl:variable name="linkContents" select="key('topicById', substring-after($linkSrc/@href, '#'))"/>
    <xsl:variable name="title">
        <xsl:choose>
            <xsl:when test="@href">
                <xsl:apply-templates select="$linkContents/child::*[contains(@class, ' topic/title ')]" mode="TEXT_ONLY"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="@navtitle"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="id" select="generate-id()"/>
    <xsl:variable name="class">
        <xsl:choose>
            <xsl:when test="contains(@class, ' bookmap/part ')">
                <xsl:value-of select="$cClassPart"/>
            </xsl:when>
            <xsl:when test="contains(@class, ' bookmap/chapter ')">
                <xsl:value-of select="$cClassChapter"/>
            </xsl:when>
            <xsl:when test="contains(@class, ' bookmap/appendix ')">
                <xsl:value-of select="$cClassAppendix"/>
            </xsl:when>
            <xsl:when test="contains(parent::*/@class, ' bookmap/part ')">
                <xsl:value-of select="$cClassChapter"/>
            </xsl:when>
            <xsl:when test="contains(parent::*/@class, ' map/map ')">
                <xsl:value-of select="$cClassChapter"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="warningContinue">
                    <xsl:with-param name="prmMes"
                                    select="ahf:replace($stMes700,('%class','%file'),(@class,@xtrf))"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:choose>
        <xsl:when test="$class=$cClassPart">
            <xsl:variable name="label" select="count(preceding-sibling::*[contains(@class,' bookmap/part ')]) + 1"/>
            <xsl:element name="chaptermap">
                <xsl:attribute name="id" select="$id"/>
                <xsl:attribute name="class" select="$class"/>
                <xsl:attribute name="label" select="$label"/>
                <xsl:attribute name="title" select="$title"/>
            </xsl:element>
        </xsl:when>
        <xsl:when test="$class=$cClassChapter">
            <xsl:variable name="label">
                <xsl:variable name="chapterLabel" select="count(preceding-sibling::*[contains(@class,' map/topicref ')][not(contains(@class,' bookmap/frontmatter '))]) + 1"/>
                <xsl:value-of select="$chapterLabel"/>
            </xsl:variable>
            <xsl:element name="chaptermap">
                <xsl:attribute name="id" select="$id"/>
                <xsl:attribute name="class" select="$class"/>
                <xsl:attribute name="label" select="$label"/>
                <xsl:attribute name="title" select="$title"/>
            </xsl:element>
        </xsl:when>
        <xsl:when test="$class=$cClassAppendix">
            <xsl:if test="not(preceding-sibling::*[contains(@class,' bookmap/appendix ')])">
                <!-- Adopt first appendix only -->
                <xsl:element name="chaptermap">
                    <xsl:attribute name="id"/>
                    <xsl:attribute name="class" select="$class"/>
                    <xsl:attribute name="label" select="$cAppendixThumbnailLabel"/>
                    <xsl:attribute name="title" select="''"/>
                </xsl:element>
            </xsl:if>
        </xsl:when>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	dump chapter map template
 param:		none
 return:	dump result
 note:		none
 -->
<xsl:template name="dumpChapterMap">
    <xsl:for-each select="$chapterMap/*">
        <xsl:message>[dumpChapterMap] no=<xsl:value-of select="position()"/> id=<xsl:value-of select="@id"/> class=<xsl:value-of select="@class"/> label=<xsl:value-of select="@label"/> title="<xsl:value-of select="@title"/>"</xsl:message>
    </xsl:for-each>
</xsl:template>

<!-- 
 function:	make thumb index map template
 param:		none
 return:	table start cout node
 note:		none
 -->
<xsl:template name="makeThumbIndexMap">
    <!--xsl:call-template name="dumpBookChildMap"/-->
    <xsl:apply-templates select="$chapterMap/*[1]" mode="MAKE_THUMB_INDEX_MAP">
        <xsl:with-param name="prmOffset" select="0"/>
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="chaptermap" mode="MAKE_THUMB_INDEX_MAP">
    <xsl:param name="prmOffset" required="yes" as="xs:integer"/>

    <xsl:variable name="indexOffset" as="xs:integer">
        <xsl:choose>
            <xsl:when test="$prmOffset &lt; number($cThumbIndexMax)">
                <xsl:sequence select="$prmOffset + 1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:element name="thumbindex">
        <xsl:attribute name="index"><xsl:value-of select="$indexOffset"/></xsl:attribute>
        <xsl:copy-of select="@*"/>
    </xsl:element>
    
    <xsl:apply-templates select="following-sibling::chaptermap[1]" mode="MAKE_THUMB_INDEX_MAP">
        <xsl:with-param name="prmOffset" select="$indexOffset"/>
    </xsl:apply-templates>
</xsl:template>

<!-- 
 function:	dump thumb index map template
 param:		none
 return:	dump result
 note:		none
 -->
<xsl:template name="dumpThumbIndexMap">
    <xsl:for-each select="$thumbIndexMap/*">
        <xsl:message>[dumpThumbIndexMap] no=<xsl:value-of select="position()"/> id=<xsl:value-of select="@id"/> class=<xsl:value-of select="@class"/> label=<xsl:value-of select="@label"/> index=<xsl:value-of select="@index"/> title=<xsl:value-of select="@title"/></xsl:message>
    </xsl:for-each>
</xsl:template>

</xsl:stylesheet>