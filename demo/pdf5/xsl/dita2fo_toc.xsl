<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: TOC stylesheet
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
 xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 xmlns:psmi="http://www.CraneSoftwrights.com/resources/psmi"
 exclude-result-prefixes="xs ahf"
>

<!-- 
 function:	Generate TOC template
 param:		none
 return:	fo:page-sequence
 note:		
 -->
<xsl:template name="genToc" >
    <psmi:page-sequence>
        <xsl:choose>
            <xsl:when test="$pOnlinePdf">
                <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqFrontMatterOnline')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqFrontMatter')"/>
            </xsl:otherwise>
        </xsl:choose>
        <fo:static-content flow-name="rgnFrontmatterBeforeLeft">
            <xsl:call-template name="frontmatterBeforeLeft"/>
        </fo:static-content>
        <fo:static-content flow-name="rgnFrontmatterBeforeRight">
            <xsl:call-template name="frontmatterBeforeRight"/>
        </fo:static-content>
        <fo:static-content flow-name="rgnFrontmatterAfterLeft">
            <xsl:call-template name="frontmatterAfterLeft"/>
        </fo:static-content>
        <fo:static-content flow-name="rgnFrontmatterAfterRight">
            <xsl:call-template name="frontmatterAfterRight"/>
        </fo:static-content>
        <fo:static-content flow-name="rgnFrontmatterBlankBody">
            <xsl:call-template name="makeBlankBlock"/>
        </fo:static-content>
        <fo:flow flow-name="xsl-region-body">
            <xsl:call-template name="genTocMain"/>
        </fo:flow>
    </psmi:page-sequence>
</xsl:template>


<!-- 
 function:	TOC's main template
 param:		none
 return:	none
 note:		
 -->
<xsl:template name="genTocMain">
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsBase')"/>
        <!-- Title -->
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsFmHeader1')"/>
            <xsl:attribute name="id">
                <xsl:value-of select="$cTocId"/>
            </xsl:attribute>
            <fo:marker marker-class-name="{$cTitleBody}">
                <fo:inline><xsl:copy-of select="$cTocTitle"/></fo:inline>
            </fo:marker>
            <xsl:value-of select="$cTocTitle"/>
        </fo:block>
        <!-- Make contents -->
		<xsl:apply-templates select="$map" mode="MAKE_TOC"/>
    </fo:block>
</xsl:template>
 
<!-- 
 function:	General templates for TOC
 param:		none
 return:	
 note:		none
 -->
<xsl:template match="*" mode="MAKE_TOC">
    <xsl:apply-templates mode="MAKE_TOC"/>
</xsl:template>

<xsl:template match="text()" mode="MAKE_TOC"/>
<xsl:template match="*[contains(@class, ' bookmap/bookmeta ')]" mode="MAKE_TOC"/>

<!-- Frontmatter -->
<xsl:template match="*[contains(@class,' bookmap/frontmatter ')][ahf:isToc(.)]" mode="MAKE_TOC" priority="2">
    <xsl:if test="$pIncludeFrontmatterToToc">
        <xsl:apply-templates mode="MAKE_TOC"/>
    </xsl:if>
</xsl:template>

<!-- Backmatter -->
<xsl:template match="*[contains(@class,' bookmap/backmatter ')][ahf:isToc(.)]" mode="MAKE_TOC" priority="2">
    <xsl:apply-templates mode="MAKE_TOC"/>
</xsl:template>

<!-- frontmatter/backmatter contents -->

<!-- booklist -->
<xsl:template match="*[contains(@class,' bookmap/booklists ')]" mode="MAKE_TOC" priority="2" >
    <xsl:apply-templates mode="MAKE_TOC"/>
</xsl:template>

<!-- TOC page -->
<xsl:template match="*[contains(@class,' bookmap/toc ')][not(@href)][ahf:isToc(.)]" mode="MAKE_TOC" priority="2" >
    <xsl:call-template name="makeTocPageLine"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/figurelist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_TOC" priority="2" >
    <xsl:call-template name="makeTocFigureListLine"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/tablelist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_TOC" priority="2" >
    <xsl:call-template name="makeTocTableListLine"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/abbrevlist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_TOC" priority="2" >
    <!-- Abbrevlist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/trademarklist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_TOC" priority="2" >
    <!-- Trademarklist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/bibliolist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_TOC" priority="2" >
    <!-- Bibliolist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/glossarylist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_TOC" priority="2" >
    <!-- Glossarylist have topicref child element. -->
    <xsl:apply-templates mode="MAKE_TOC"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/indexlist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_TOC" priority="2" >
    <!-- Index line -->
    <xsl:call-template name="makeIndexLine"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/booklist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_TOC" priority="2" >
    <!-- Booklist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/notices ')][not(@href)]" mode="MAKE_TOC" priority="2" >
    <!-- Notices line -->
    <xsl:call-template name="makeNoticesLine"/>
    <!-- Notices have topicref child element. -->
    <xsl:apply-templates mode="MAKE_TOC"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/preface ')][not(@href)]" mode="MAKE_TOC" priority="2" >
    <!-- Notices line -->
    <xsl:call-template name="makePrefaceLine"/>
    <!-- Notices have topicref child element. -->
    <xsl:apply-templates mode="MAKE_TOC"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/dedication ')][not(@href)]" mode="MAKE_TOC" priority="2" >
    <!-- Dedication should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/colophon ')][not(@href)]" mode="MAKE_TOC" priority="2" >
    <!-- Colophon should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/amendments ')][not(@href)]" mode="MAKE_TOC" priority="2" >
    <!-- Aamendments should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' mapgroup-d/topicgroup ')]" mode="MAKE_TOC" priority="2" >
    <!-- topicgroup create group without affecting the hierarchy. 
         topicgroup is skipped in dita2fo_convmerged.xsl.
    -->
    <xsl:apply-templates mode="MAKE_TOC"/>
</xsl:template>

<!-- Ignore reltable contents -->
<xsl:template match="*[contains(@class,' map/reltable ')]" mode="MAKE_TOC" />

<!-- 
 function:	templates for topicref
 param:		none
 return:	TOC line
 note:		Process all of the map/topicref contents.
 -->
<xsl:template match="*[contains(@class,' map/topicref ')]" mode="MAKE_TOC">
    
    <xsl:variable name="topicref" select="."/>
    <xsl:variable name="id">
        <xsl:choose>
            <xsl:when test="@href">
                <xsl:value-of select="substring-after(@href, '#')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <xsl:variable name="linkContent" select="if (string($id)) then key('topicById',$id) else ()" as="element()?"/>
    <xsl:variable name="contentId" select="if (empty($linkContent)) then () else ahf:getIdAtts($linkContent,$topicref,true())" as="attribute()*"/>
    <xsl:variable name="navtitle" select="normalize-space(@navtitle)"/>
    <xsl:variable name="nestedTopicCount" as="xs:integer">
        <xsl:choose>
            <!-- frontmatter -->
            <xsl:when test="ancestor::*[contains(@class, ' bookmap/frontmatter ')]">
                <xsl:sequence select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' bookmap/frontmatter '))]
                                                               )"/>
            </xsl:when>
            <!-- backmatter -->
            <xsl:when test="ancestor::*[contains(@class, ' bookmap/backmatter ')]">
                <xsl:sequence select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' bookmap/backmatter '))]
                                                               )"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')])"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="addToc" as="xs:boolean">
        <xsl:choose>
            <xsl:when test="$nestedTopicCount &gt; $cTocNestMax">
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:when test="ancestor-or-self::*[contains(@class, ' map/topicref ')][@toc='no']">
                <!-- Descendant of toc="no" topicref --> 
                <xsl:sequence select="false()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="true()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="not($addToc)">
            <!-- Ignore this element and descendant. -->
        </xsl:when>
        <xsl:otherwise>
            <!-- Make TOC line -->
            <xsl:variable name="title" select="ahf:getTitleContent($topicref,$linkContent)" as="node()*"/>
                <!--xsl:call-template name="genTitle">
                    <xsl:with-param name="prmTopicRef" select="$topicref"/>
                    <xsl:with-param name="prmLinkContent" select="$linkContent"/>
                </xsl:call-template>
            </xsl:variable-->
            <xsl:call-template name="makeTocLine">
                <xsl:with-param name="prmId"    select="if (exists($contentId)) then string($contentId[1]) else ''"/>
                <xsl:with-param name="prmLevel" select="$nestedTopicCount"/>
                <xsl:with-param name="prmTitle" select="$title"/>
            </xsl:call-template>
            <!-- Navigate to lower level -->
            <xsl:apply-templates mode="MAKE_TOC"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- 
 function:	Get title contents
 param:		prmTopicRef, prmLinkContent
 return:	title inline
 note:		
 -->
<xsl:function name="ahf:getTitleContent" as="node()*">
    <xsl:param name="prmTopicRef" as="element()"/>
    <xsl:param name="prmLinkContent" as="element()?"/>
    
    <xsl:if test="$pAddNumberingTitlePrefix">
        <xsl:variable name="titlePrefix" as="xs:string">
            <xsl:call-template name="genTitlePrefix">
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string(normalize-space($titlePrefix))">
            <fo:inline>
                <xsl:value-of select="$titlePrefix"/>
                <xsl:text>&#x00A0;&#x00A0;</xsl:text>
            </fo:inline>
        </xsl:if>
    </xsl:if>
    <xsl:choose>
        <xsl:when test="exists($prmLinkContent)">
            <xsl:apply-templates select="$prmLinkContent/*[contains(@class, ' topic/title ')]" mode="GET_CONTENTS"/>
        </xsl:when>
        <xsl:otherwise>
            <fo:inline><xsl:value-of select="string($prmTopicRef/@navtitle)"/></fo:inline>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<!-- 
 function:	Make TOC line
 param:		prmId, prmLevel, prmTitle
 return:	TOC line
 note:		
 -->
<xsl:template name="makeTocLine">
    <xsl:param name="prmId"    required="yes" as="xs:string"/>
    <xsl:param name="prmLevel" required="yes" as="xs:integer"/>
    <xsl:param name="prmTitle" required="yes" as="node()*"/>

    <xsl:choose>
        <xsl:when test="$prmLevel=1">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsTocLevel1')"/>
                <xsl:choose>
                    <xsl:when test="string($prmId)">
                        <fo:basic-link internal-destination="{$prmId}">
                            <xsl:copy-of select="$prmTitle"/>
                        </fo:basic-link>
            			<fo:leader leader-length.optimum="0pt">
                            <xsl:copy-of select="ahf:getAttributeSet('atsTocLeader')"/>
                        </fo:leader>
                        <fo:inline keep-with-next="always">
                            <fo:leader>
                                <xsl:copy-of select="ahf:getAttributeSet('atsTocLeader')"/>
                            </fo:leader>
                        </fo:inline>
                        <fo:basic-link internal-destination="{$prmId}">
                            <fo:page-number-citation ref-id="{$prmId}" />
                        </fo:basic-link>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="ahf:getAttributeSet('atsTocTitleOnly')"/>
                        <fo:inline>
                            <xsl:copy-of select="$prmTitle"/>
                        </fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
        </xsl:when>
        <xsl:when test="$prmLevel=2">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsTocLevel2')"/>
                <xsl:choose>
                    <xsl:when test="string($prmId)">
                        <fo:basic-link internal-destination="{$prmId}">
                            <xsl:copy-of select="$prmTitle"/>
                        </fo:basic-link>
            			<fo:leader leader-length.optimum="0pt">
                            <xsl:copy-of select="ahf:getAttributeSet('atsTocLeader')"/>
                        </fo:leader>
                        <fo:inline keep-with-next="always">
                            <fo:leader>
                                <xsl:copy-of select="ahf:getAttributeSet('atsTocLeader')"/>
                            </fo:leader>
                        </fo:inline>
                        <fo:basic-link internal-destination="{$prmId}">
                            <fo:page-number-citation ref-id="{$prmId}" />
                        </fo:basic-link>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="ahf:getAttributeSet('atsTocTitleOnly')"/>
                        <fo:inline>
                            <xsl:copy-of select="$prmTitle"/>
                        </fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
        </xsl:when>
        <xsl:when test="$prmLevel=3">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsTocLevel3')"/>
                <xsl:choose>
                    <xsl:when test="string($prmId)">
                        <fo:basic-link internal-destination="{$prmId}">
                            <xsl:copy-of select="$prmTitle"/>
                        </fo:basic-link>
            			<fo:leader leader-length.optimum="0pt">
                            <xsl:copy-of select="ahf:getAttributeSet('atsTocLeader')"/>
                        </fo:leader>
                        <fo:inline keep-with-next="always">
                            <fo:leader>
                                <xsl:copy-of select="ahf:getAttributeSet('atsTocLeader')"/>
                            </fo:leader>
                        </fo:inline>
                        <fo:basic-link internal-destination="{$prmId}">
                            <fo:page-number-citation ref-id="{$prmId}" />
                        </fo:basic-link>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="ahf:getAttributeSet('atsTocTitleOnly')"/>
                        <fo:inline>
                            <xsl:copy-of select="$prmTitle"/>
                        </fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsTocLevel4')"/>
                <xsl:choose>
                    <xsl:when test="string($prmId)">
                        <fo:basic-link internal-destination="{$prmId}">
                            <xsl:copy-of select="$prmTitle"/>
                        </fo:basic-link>
            			<fo:leader leader-length.optimum="0pt">
                            <xsl:copy-of select="ahf:getAttributeSet('atsTocLeader')"/>
                        </fo:leader>
                        <fo:inline keep-with-next="always">
                            <fo:leader>
                                <xsl:copy-of select="ahf:getAttributeSet('atsTocLeader')"/>
                            </fo:leader>
                        </fo:inline>
                        <fo:basic-link internal-destination="{$prmId}">
                            <fo:page-number-citation ref-id="{$prmId}" />
                        </fo:basic-link>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="ahf:getAttributeSet('atsTocTitleOnly')"/>
                        <fo:inline>
                            <xsl:copy-of select="$prmTitle"/>
                        </fo:inline>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	Make index line
 param:		none
 return:	index line
 note:		
 -->
<xsl:template name="makeIndexLine">
    <xsl:if test="$indextermSortedCount&gt;0">
        <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                                   [not(contains(@class, ' bookmap/backmatter '))]
                                                                   [not(contains(@class, ' bookmap/frontmatter '))]
                                                                   [not(contains(@class, ' bookmap/booklists '))]
                                                                   )"/>
        <xsl:call-template name="makeTocLine">
            <xsl:with-param name="prmId"    select="$cIndexId"/>
            <xsl:with-param name="prmLevel" select="$level"/>
            <xsl:with-param name="prmTitle">
                <fo:inline>
                    <xsl:value-of select="$cIndexTitle"/>
                </fo:inline>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<!-- 
 function:	Make toc line
 param:		none
 return:	TOC line
 note:		
 -->
<xsl:template name="makeTocPageLine">
    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' bookmap/backmatter '))]
                                                               [not(contains(@class, ' bookmap/frontmatter '))]
                                                               [not(contains(@class, ' bookmap/booklists '))]
                                                               )"/>
    <xsl:call-template name="makeTocLine">
        <xsl:with-param name="prmId"    select="$cTocId"/>
        <xsl:with-param name="prmLevel" select="$level"/>
        <xsl:with-param name="prmTitle">
            <fo:inline>
                <xsl:value-of select="$cTocTitle"/>
            </fo:inline>
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>

<!-- 
 function:	Make figure list line
 param:		none
 return:	figure list line
 note:		
 -->
<xsl:template name="makeTocFigureListLine">
    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' bookmap/backmatter '))]
                                                               [not(contains(@class, ' bookmap/frontmatter '))]
                                                               [not(contains(@class, ' bookmap/booklists '))]
                                                               )"/>
    <xsl:call-template name="makeTocLine">
        <xsl:with-param name="prmId"    select="$cFigureListId"/>
        <xsl:with-param name="prmLevel" select="$level"/>
        <xsl:with-param name="prmTitle">
            <fo:inline>
                <xsl:value-of select="$cFigureListTitle"/>
            </fo:inline>
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>

<!-- 
 function:	Make table list line
 param:		none
 return:	table list line
 note:		
 -->
<xsl:template name="makeTocTableListLine">
    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' bookmap/backmatter '))]
                                                               [not(contains(@class, ' bookmap/frontmatter '))]
                                                               [not(contains(@class, ' bookmap/booklists '))]
                                                               )"/>
    <xsl:call-template name="makeTocLine">
        <xsl:with-param name="prmId"    select="$cTableListId"/>
        <xsl:with-param name="prmLevel" select="$level"/>
        <xsl:with-param name="prmTitle">
            <fo:inline>
                <xsl:value-of select="$cTableListTitle"/>
            </fo:inline>
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>

<!-- 
 function:	Make preface line
 param:		none
 return:	preface line
 note:		
 -->
<xsl:template name="makePrefaceLine">
    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' bookmap/backmatter '))]
                                                               [not(contains(@class, ' bookmap/frontmatter '))]
                                                               )"/>
    <xsl:call-template name="makeTocLine">
        <xsl:with-param name="prmId"    select="''"/>
        <xsl:with-param name="prmLevel" select="$level"/>
        <xsl:with-param name="prmTitle">
            <fo:inline>
                <xsl:value-of select="$cPrefaceTitle"/>
            </fo:inline>
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>

<!-- 
 function:	Make notice line
 param:		none
 return:	notice line
 note:		
 -->
<xsl:template name="makeNoticesLine">
    <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' bookmap/backmatter '))]
                                                               [not(contains(@class, ' bookmap/frontmatter '))]
                                                               )"/>
    <xsl:call-template name="makeTocLine">
        <xsl:with-param name="prmId"    select="''"/>
        <xsl:with-param name="prmLevel" select="$level"/>
        <xsl:with-param name="prmTitle">
            <fo:inline>
                <xsl:value-of select="$cNoticeTitle"/>
            </fo:inline>
        </xsl:with-param>
    </xsl:call-template>
</xsl:template>


</xsl:stylesheet>
