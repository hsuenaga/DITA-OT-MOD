<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Generate bookmark tree.
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
 exclude-result-prefixes="xs ahf">
 
<!-- 
 function:	Generate bookmark tree
 param:		none
 return:	fo:bookmark-tree
 note:		none
 -->
<xsl:template name="genBookmarkTree">
	<fo:bookmark-tree>
		<xsl:apply-templates select="$map" mode="MAKE_BOOKMARK"/>
	</fo:bookmark-tree>
</xsl:template>

<!-- 
 function:	General templates for bookmark
 param:		none
 return:	
 note:		none
 -->
<xsl:template match="*" mode="MAKE_BOOKMARK">
    <xsl:apply-templates mode="MAKE_BOOKMARK"/>
</xsl:template>

<xsl:template match="text()" mode="MAKE_BOOKMARK"/>
<xsl:template match="*[contains(@class, ' bookmap/bookmeta ')]" mode="MAKE_BOOKMARK"/>

<!-- frontmatter -->
<xsl:template match="*[contains(@class,' map/topicref ')][contains(@class,' bookmap/frontmatter ')]" mode="MAKE_BOOKMARK" priority="2" >
    <xsl:apply-templates mode="MAKE_BOOKMARK"/>
</xsl:template>

<!-- frontmatter contents -->
<xsl:template match="*[contains(@class,' map/topicref ')][contains(@class,' bookmap/booklists ')]" mode="MAKE_BOOKMARK" priority="2" >
    <xsl:apply-templates mode="MAKE_BOOKMARK"/>
</xsl:template>

<xsl:template match="*[contains(@class,' map/topicref ')][contains(@class,' bookmap/toc ')][not(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
    <!--The stylesheet should TOC here. -->
    <xsl:call-template name="genTocBookMark"/>
</xsl:template>

<xsl:template match="*[contains(@class,' map/topicref ')][contains(@class,' bookmap/figurelist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
    <xsl:call-template name="genFigureListBookMark"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/tablelist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
    <xsl:call-template name="genTableListBookMark"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/abbrevlist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- Abbrevlist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/trademarklist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- Trademarklist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/bibliolist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- Bibliolist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/glossarylist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- Glossarylist have topicref child element. -->
    <xsl:apply-templates mode="MAKE_BOOKMARK"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/indexlist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
    <xsl:call-template name="genIndexBookMark"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/booklist ')][not(@href)][ahf:isToc(.)]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- Booklist should have a href attribute. -->
</xsl:template>

<!-- Notices have topicref child element. -->
<!--xsl:template match="*[contains(@class,' bookmap/notices ')][not(@href)]" mode="MAKE_BOOKMARK" priority="2" >
    <xsl:apply-templates mode="MAKE_BOOKMARK"/>
</xsl:template-->

<xsl:template match="*[contains(@class,' bookmap/dedication ')][not(@href)]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- Dedication should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/colophon ')][not(@href)]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- Colophon should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/bookabstract ')][not(@href)]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- Bookabstract should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/draftintro ')]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- Draftintro have topicref child elements. -->
    <xsl:apply-templates mode="MAKE_BOOKMARK"/>
</xsl:template>

<!-- Preface have topicref child elements. -->
<!--xsl:template match="*[contains(@class,' bookmap/preface ')]" mode="MAKE_BOOKMARK" priority="2" >
    <xsl:apply-templates mode="MAKE_BOOKMARK"/>
</xsl:template-->

<xsl:template match="*[contains(@class,' mapgroup-d/topicgroup ')]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- topicgroup create group without affecting the hierarchy. -->
    <xsl:apply-templates mode="MAKE_BOOKMARK"/>
</xsl:template>

<!-- Backmatter contents -->
<xsl:template match="*[contains(@class,' bookmap/backmatter ')]" mode="MAKE_BOOKMARK" priority="2" >
    <xsl:apply-templates mode="MAKE_BOOKMARK"/>
</xsl:template>

<!-- backmatter/booklists: Same as frontmatter -->
<!-- backmatter/notices:   Same as frontmatter -->
<!-- backmatter/dedication:Same as frontmatter -->
<!-- backmatter/colophon:  Same as frontmatter -->

<xsl:template match="*[contains(@class,' bookmap/amendments ')]" mode="MAKE_BOOKMARK" priority="2" >
    <!-- Aamendments should have a href attribute. -->
</xsl:template>

<!-- Ignore reltable contents -->
<xsl:template match="*[contains(@class,' map/reltable ')]" mode="MAKE_BOOKMARK" />

<!-- 
 function:	Generate bookmark
 param:		none
 return:	fo:bookmark
 note:		Process all of the map/topicref contents.
 -->
<xsl:template match="*[contains(@class,' map/topicref ')]" mode="MAKE_BOOKMARK">

    <!--xsl:message>[topicref] href="<xsl:value-of select="@href"/>"</xsl:message-->
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
    
    <xsl:variable name="linkContent" select="if (string($id)) then key('topicById',$id) else ()"/>
    <xsl:variable name="oid" select="if (empty($linkContent)) then () else ahf:getIdAtts($linkContent,$topicref,true())" as="attribute()*"/>
    <xsl:variable name="navtitle" select="normalize-space(@navtitle)"/>
    
    <xsl:variable name="nestedTopicCount">
        <xsl:choose>
            <!-- Frontmatter -->
            <xsl:when test="ancestor-or-self::*[contains(@class, ' bookmap/frontmatter ')]">
                <xsl:value-of select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' bookmap/frontmatter '))]
                                                               )"/>
                <!-- topicgroup is skipped in dita2fo_convmerged.xsl
                                                               [not(contains(@class, ' mapgroup-d/topicgroup '))]
                 -->
            </xsl:when>
            <!-- backmatter -->
            <xsl:when test="ancestor-or-self::*[contains(@class, ' bookmap/backmatter ')]">
                <xsl:value-of select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' bookmap/backmatter '))]
                                                               )"/>
                <!-- topicgroup is skipped in dita2fo_convmerged.xsl
                                                               [not(contains(@class, ' mapgroup-d/topicgroup '))]
                 -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="count(ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' mapgroup-d/topicgroup '))]
                                                               )"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="addBookmark">
        <xsl:choose>
            <xsl:when test="$nestedTopicCount &gt; $cBookmarkNestMax">
                <!-- Max nesting level = 4 --> 
                <xsl:value-of select="$false"/>
            </xsl:when>
            <!--xsl:when test="ancestor-or-self::*[contains(@class, ' map/topicref ')][@toc='no']"-->
            <xsl:when test="ancestor-or-self::*[contains(@class, ' map/topicref ')][ahf:isTocNo(.)]">
                <!-- Descendant of toc="no" topicref --> 
                <xsl:value-of select="$false"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$true"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="$addBookmark = $false">
            <!-- Ignore this element and descendant. -->
        </xsl:when>
        <xsl:otherwise>
            <!--xsl:comment>id=<xsl:value-of select="if exists($oid) then string($oid[1]) else ''"/></xsl:comment-->
            <fo:bookmark starting-state="{$cStartingState}">
                <xsl:if test="exists($oid)">
                    <xsl:attribute name="internal-destination">
                        <!-- id is fixed to index 1. -->
                        <xsl:value-of select="string($oid[1])"/>
                    </xsl:attribute>
                </xsl:if>
                <fo:bookmark-title>
                    <xsl:call-template name="genTitle">
                        <xsl:with-param name="prmTopicRef" select="."/>
                        <xsl:with-param name="prmLinkContent" select="$linkContent"/>
                    </xsl:call-template>
                </fo:bookmark-title>
                <!-- Navigate to lower level -->
                <xsl:apply-templates mode="MAKE_BOOKMARK"/>
            </fo:bookmark>
        </xsl:otherwise>
    </xsl:choose>

</xsl:template>

<!-- 
 function:	Generate title of bookmark
 param:		prmTopicRef, prmLinkContent
 return:	title string
 note:		prmLinkContent is not valid if $prmTopicRef does not have @href attribute.
 -->
<xsl:template name="genTitle">
    <xsl:param name="prmTopicRef" required="yes" as="element()"/>
    <xsl:param name="prmLinkContent" required="yes" as="element()?"/>
    
    <xsl:variable name="href" select="string($prmTopicRef/@href)"/>
    <!-- Who is my ancestor? -->
    <xsl:choose>
        <xsl:when test="$isBookMap">
            <xsl:choose>
                <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/frontmatter ')]">
                    <!-- frontmatter -->
                    <xsl:variable name="frontmatterTitle">
                        <xsl:choose>
                            <xsl:when test="string($href)">
                                <xsl:apply-templates select="$prmLinkContent/child::*[contains(@class, ' topic/title ')]" mode="TEXT_ONLY"/>
                            </xsl:when>
                            <xsl:when test="contains($prmTopicRef/@class, ' bookmap/notices ')">
                                <xsl:value-of select="$cNoticeTitle"/>
                            </xsl:when>
                            <xsl:when test="contains($prmTopicRef/@class, ' bookmap/preface ')">
                                <xsl:value-of select="$cPrefaceTitle"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$prmTopicRef/@navtitle"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($frontmatterTitle)"/>
                </xsl:when>
                <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/backmatter ')]">
                    <!-- backmatter -->
                    <xsl:variable name="backmatterTitle">
                        <xsl:choose>
                            <xsl:when test="string($href)">
                                <xsl:apply-templates select="$prmLinkContent/child::*[contains(@class, ' topic/title ')]" mode="TEXT_ONLY"/>
                            </xsl:when>
                            <xsl:when test="contains($prmTopicRef/@class, ' bookmap/notices ')">
                                <xsl:value-of select="$cNoticeTitle"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$prmTopicRef/@navtitle"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:value-of select="normalize-space($backmatterTitle)"/>
                </xsl:when>
                <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/part ')]">
                    <!-- part -->
                    <xsl:call-template name="genPartDescendantTitle">
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        <xsl:with-param name="prmLinkContent" select="$prmLinkContent"/>
                        <xsl:with-param name="prmStart" select="true()"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/chapter ')]">
                    <!-- chapter -->
                    <xsl:call-template name="genChapterDescendantTitle">
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        <xsl:with-param name="prmLinkContent" select="$prmLinkContent"/>
                        <xsl:with-param name="prmStart" select="true()"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/appendix ')]">
                    <!-- appendix -->
                    <xsl:call-template name="genAppendixDescendantTitle">
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        <xsl:with-param name="prmLinkContent" select="$prmLinkContent"/>
                        <xsl:with-param name="prmStart" select="true()"/>
                    </xsl:call-template>
                </xsl:when>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="genMapDescendantTitle">
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmLinkContent" select="$prmLinkContent"/>
                <xsl:with-param name="prmStart" select="true()"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	Generate title of topic descendant of part
 param:		prmTopicRef, prmLinkContent, prmStart
 return:	title string
 note:		none
 -->
<xsl:template name="genPartDescendantTitle">
    <xsl:param name="prmTopicRef" required="yes" as="element()"/>
    <xsl:param name="prmLinkContent" required="yes" as="element()?"/>
    <xsl:param name="prmStart" required="yes" as="xs:boolean"/>
    
    <xsl:variable name="href" select="string($prmTopicRef/@href)"/>
    <xsl:variable name="title">
        <xsl:choose>
            <xsl:when test="$prmStart">
                <xsl:variable name="titleResult">
                    <xsl:choose>
                        <xsl:when test="string($href)">
                            <xsl:apply-templates select="$prmLinkContent/child::*[contains(@class, ' topic/title ')]" mode="TEXT_ONLY"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$prmTopicRef/@navtitle"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat(' ', normalize-space($titleResult))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="isPart" select="boolean(contains($prmTopicRef/@class, ' bookmap/part '))"/>
    
    <xsl:variable name="upperTopicCount" select="count($prmTopicRef/ancestor-or-self::*[contains(@class, ' map/topicref ')])"/>
    
    <!--xsl:message>isPart=<xsl:value-of select="$isPart"/></xsl:message-->
    <!--xsl:message>upperTopicCount=<xsl:value-of select="$upperTopicCount"/></xsl:message-->
    
    
    <xsl:variable name="currentNumber">
        <xsl:choose>
            <xsl:when test="$isPart">
                <!-- this is part -->
                <xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' bookmap/part ')]) + 1"/>
                <!--xsl:message>Partno: <xsl:value-of select="$partNumber"/></xsl:message-->
                <!--xsl:call-template name="partNumberToAlpha">
                    <xsl:with-param name="prmPartNumber" select="$partNumber"/>
                </xsl:call-template-->
            </xsl:when>
            <xsl:otherwise>
                <!--xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' map/topicref ')][not(@toc='no')]) + 1"/-->
                <xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' map/topicref ')][not(ahf:isTocNo(.))]) + 1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="upperNumber">
        <xsl:choose>
            <xsl:when test="not($prmTopicRef/ancestor::*[contains(@class, ' map/topicref ')])">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="ancestorLinkSrc" select="$prmTopicRef/ancestor::*[contains(@class, ' map/topicref ')][1]"/>
                <xsl:call-template name="genPartDescendantTitle">
                    <xsl:with-param name="prmTopicRef" select="$ancestorLinkSrc"/>
                    <xsl:with-param name="prmLinkContent" select="()"/>
                    <xsl:with-param name="prmStart" select="false()"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="not($pAddNumberingTitlePrefix)">
            <xsl:value-of select="$title"/>
        </xsl:when>
        <xsl:when test="$isPart">
            <xsl:choose>
                <xsl:when test="$prmStart and $pAddPartToTitle">
                    <xsl:choose>
                        <xsl:when test="not(string(normalize-space($cPartTitleSuffix)))">
                            <!-- Suffix is none -->
                            <xsl:value-of select="concat($cPartTitlePrefix,
                                                         $currentNumber,
                                                         $cTitlePrefixSeparator,
                                                         $cPartTitleSuffix, 
                                                         ' ',
                                                         $title)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Suffix is character -->
                            <xsl:value-of select="concat($cPartTitlePrefix,
                                                         $currentNumber,
                                                         $cPartTitleSuffix, 
                                                         ' ',
                                                         $title)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($currentNumber,$cTitlePrefixSeparator, $title)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="$upperTopicCount=2">
            <xsl:value-of select="concat($upperNumber, $currentNumber, $title)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat($upperNumber, $cTitlePrefixSeparator, $currentNumber, $title)"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- 
 function:	Generate title of topic descendant of chapter
 param:		prmTopicRef, prmLinkContent, prmStart
 return:	title string
 note:		none
 -->
<xsl:template name="genChapterDescendantTitle">
    <xsl:param name="prmTopicRef" required="yes" as="element()"/>
    <xsl:param name="prmLinkContent" required="yes" as="element()?"/>
    <xsl:param name="prmStart" required="yes" as="xs:boolean"/>
    
    <xsl:variable name="href" select="string($prmTopicRef/@href)"/>
    <xsl:variable name="title">
        <xsl:choose>
            <xsl:when test="$prmStart">
                <xsl:variable name="titleResult">
                    <xsl:choose>
                        <xsl:when test="string($href)">
                            <xsl:apply-templates select="$prmLinkContent/child::*[contains(@class, ' topic/title ')]" mode="TEXT_ONLY"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$prmTopicRef/@navtitle"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat(' ', normalize-space($titleResult))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="isChapter" select="boolean(contains($prmTopicRef/@class, ' bookmap/chapter '))"/>
    
    <xsl:variable name="upperTopicCount" select="count($prmTopicRef/ancestor-or-self::*[contains(@class, ' map/topicref ')])"/>
    
    <xsl:variable name="currentNumber">
        <xsl:choose>
            <xsl:when test="$isChapter">
                <xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' bookmap/chapter ')]) + 1"/>
            </xsl:when>
            <xsl:otherwise>
                <!--xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' map/topicref ')][not(@toc='no')]) + 1"/-->
                <xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' map/topicref ')][not(ahf:isTocNo(.))]) + 1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="upperNumber">
        <xsl:choose>
            <xsl:when test="not($prmTopicRef/ancestor::*[contains(@class, ' map/topicref ')])">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="ancestorLinkSrc" select="$prmTopicRef/ancestor::*[contains(@class, ' map/topicref ')][1]"/>
                <xsl:call-template name="genChapterDescendantTitle">
                    <xsl:with-param name="prmTopicRef" select="$ancestorLinkSrc"/>
                    <xsl:with-param name="prmLinkContent" select="()"/>
                    <xsl:with-param name="prmStart" select="false()"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="not($pAddNumberingTitlePrefix)">
            <xsl:value-of select="$title"/>
        </xsl:when>
        <xsl:when test="$isChapter">
            <xsl:choose>
                <xsl:when test="$prmStart and $pAddPartToTitle">
                    <xsl:choose>
                        <xsl:when test="not(string(normalize-space($cChapterTitleSuffix)))">
                            <!-- Suffix is only space -->
                            <xsl:value-of select="concat($cChapterTitlePrefix,
                                                         $currentNumber,
                                                         $cTitlePrefixSeparator,
                                                         $cChapterTitleSuffix, 
                                                         $title)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- Suffix is character -->
                            <xsl:value-of select="concat($cChapterTitlePrefix,
                                                         $currentNumber,
                                                         $cChapterTitleSuffix, 
                                                         $title)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat($currentNumber, $cTitlePrefixSeparator, $title)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="$upperTopicCount=2">
            <xsl:value-of select="concat($upperNumber, $currentNumber, $title)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat($upperNumber, $cTitlePrefixSeparator, $currentNumber, $title)"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- 
 function:	Generate title of appendix ( and their descendant topic)
 param:		prmTopicRef, prmLinkContent, prmStart
 return:	title string
 note:		none
 -->
<xsl:template name="genAppendixDescendantTitle">
    <xsl:param name="prmTopicRef" required="yes" as="element()"/>
    <xsl:param name="prmLinkContent" required="yes" as="element()?"/>
    <xsl:param name="prmStart" required="yes" as="xs:boolean"/>
    
    <xsl:variable name="href" select="string($prmTopicRef/@href)"/>
    <xsl:variable name="titlePrefix">
        <xsl:choose>
            <xsl:when test="$prmStart">
                <xsl:value-of select="$cAppendixTitle"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="titleSuffix">
        <xsl:choose>
            <xsl:when test="$prmStart">
                <xsl:variable name="titleResult">
                    <xsl:choose>
                        <xsl:when test="string($href)">
                            <xsl:apply-templates select="$prmLinkContent/child::*[contains(@class, ' topic/title ')]" mode="TEXT_ONLY"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$prmTopicRef/@navtitle"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat(' ', normalize-space($titleResult))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="isAppendix" select="boolean(contains($prmTopicRef/@class, ' bookmap/appendix '))"/>
    
    <xsl:variable name="upperTopicCount" select="count($prmTopicRef/ancestor-or-self::*[contains(@class, ' map/topicref ')])"/>

    <xsl:variable name="currentNumber">
        <xsl:choose>
            <xsl:when test="$isAppendix">
                <xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' bookmap/appendix ')]) + 1"/>
            </xsl:when>
            <xsl:otherwise>
                <!--xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' map/topicref ')][not(@toc='no')]) + 1"/-->
                <xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' map/topicref ')][not(ahf:isTocNo(.))]) + 1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="upperNumber">
        <xsl:choose>
            <xsl:when test="not($prmTopicRef/ancestor::*[contains(@class, ' map/topicref ')])">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="ancestorLinkSrc" select="$prmTopicRef/ancestor::*[contains(@class, ' map/topicref ')][1]"/>
                <xsl:call-template name="genAppendixDescendantTitle">
                    <xsl:with-param name="prmTopicRef" select="$ancestorLinkSrc"/>
                    <xsl:with-param name="prmLinkContent" select="()"/>
                    <xsl:with-param name="prmStart" select="false()"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="not($pAddNumberingTitlePrefix)">
            <xsl:value-of select="$titleSuffix"/>
        </xsl:when>
        <xsl:when test="$isAppendix">
            <xsl:value-of select="concat($titlePrefix, $currentNumber, $cTitlePrefixSeparator, $titleSuffix)"/>
        </xsl:when>
        <xsl:when test="$upperTopicCount=2">
            <xsl:value-of select="concat($titlePrefix, $upperNumber, $currentNumber, $titleSuffix)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat($titlePrefix, $upperNumber, $cTitlePrefixSeparator, $currentNumber, $titleSuffix)"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- 
 function:	Generate title of topic descendant of map
 param:		prmTopicRef, prmLinkContent,prmStart
 return:	title string
 note:		none
 -->
<xsl:template name="genMapDescendantTitle">
    <xsl:param name="prmTopicRef" required="yes" as="element()"/>
    <xsl:param name="prmLinkContent" required="yes" as="element()?"/>
    <xsl:param name="prmStart" required="yes" as="xs:boolean"/>
    
    <xsl:variable name="href" select="string($prmTopicRef/@href)"/>
    <xsl:variable name="title">
        <xsl:choose>
            <xsl:when test="$prmStart">
                <xsl:variable name="titleResult">
                    <xsl:choose>
                        <xsl:when test="string($href)">
                            <xsl:apply-templates select="$prmLinkContent/child::*[contains(@class, ' topic/title ')]" mode="TEXT_ONLY"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$prmTopicRef/@navtitle"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="concat(' ', normalize-space($titleResult))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="isRoot" select="boolean($prmTopicRef/parent::*[contains(@class, ' map/map ')])"/>
    
    <xsl:variable name="upperTopicCount" select="count($prmTopicRef/ancestor-or-self::*[contains(@class, ' map/topicref ')])"/>
    
    <xsl:variable name="currentNumber">
        <xsl:choose>
            <xsl:when test="$isRoot">
                <xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' map/topicref ')]) + 1"/>
            </xsl:when>
            <xsl:otherwise>
                <!--xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' map/topicref ')][not(@toc='no')]) + 1"/-->
                <xsl:value-of select="count($prmTopicRef/preceding-sibling::*[contains(@class, ' map/topicref ')][not(ahf:isTocNo(.))]) + 1"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:variable name="upperNumber">
        <xsl:choose>
            <xsl:when test="not($prmTopicRef/ancestor::*[contains(@class, ' map/topicref ')])">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="ancestorTopicRef" select="$prmTopicRef/ancestor::*[contains(@class, ' map/topicref ')][1]"/>
                <xsl:call-template name="genMapDescendantTitle">
                    <xsl:with-param name="prmTopicRef" select="$ancestorTopicRef"/>
                    <xsl:with-param name="prmLinkContent" select="()"/>
                    <xsl:with-param name="prmStart" select="false()"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:choose>
        <xsl:when test="not($pAddNumberingTitlePrefix)">
            <xsl:value-of select="$title"/>
        </xsl:when>
        <xsl:when test="$isRoot">
            <xsl:value-of select="concat($currentNumber, $cTitlePrefixSeparator, $title)"/>
        </xsl:when>
        <xsl:when test="$upperTopicCount=2">
            <xsl:value-of select="concat($upperNumber, $currentNumber, $title)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="concat($upperNumber, $cTitlePrefixSeparator, $currentNumber, $title)"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>


<!-- 
 function:	Generate title of toc
 param:		none
 return:	fo:bookmark
 note:		none
 -->
<xsl:template name="genTocBookMark">
    <fo:bookmark internal-destination="{$cTocId}" starting-state="{$cStartingState}">
        <fo:bookmark-title>
            <xsl:value-of select="$cTocTitle"/>
        </fo:bookmark-title>
    </fo:bookmark>
</xsl:template>

<!-- 
 function:	Generate index bookmark
 param:		none
 return:	fo:bookmark
 note:		none
 -->
<xsl:template name="genIndexBookMark">
    <xsl:if test="$indextermSortedCount&gt;0">
        <fo:bookmark internal-destination="{$cIndexId}" starting-state="{$cStartingState}">
            <fo:bookmark-title>
                <xsl:value-of select="$cIndexTitle"/>
            </fo:bookmark-title>
        </fo:bookmark>
    </xsl:if>
</xsl:template>

<!-- 
 function:	Generate figurelist bookmark
 param:		none
 return:	fo:bookmark
 note:		none
 -->
<xsl:template name="genFigureListBookMark">
    <xsl:if test="boolean($figureCountMap/*[@count&gt;0])">
        <fo:bookmark internal-destination="{$cFigureListId}" starting-state="{$cStartingState}">
            <fo:bookmark-title>
                <xsl:value-of select="$cFigureListTitle"/>
            </fo:bookmark-title>
        </fo:bookmark>
    </xsl:if>
</xsl:template>


<!-- 
 function:	Generate tablelist bookmark
 param:		none
 return:	fo:bookmark
 note:		none
 -->
<xsl:template name="genTableListBookMark">
    <xsl:if test="boolean($tableCountMap/*[@count&gt;0])">
        <fo:bookmark internal-destination="{$cTableListId}" starting-state="{$cStartingState}">
            <fo:bookmark-title>
                <xsl:value-of select="$cTableListTitle"/>
            </fo:bookmark-title>
        </fo:bookmark>
    </xsl:if>
</xsl:template>



</xsl:stylesheet>