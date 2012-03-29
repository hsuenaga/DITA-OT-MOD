<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Part, chapter, appendix templates
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

<!-- 
 function:	Generate main content, part, chapter or appendix
 param:		none
 return:	part, chapter contents
 note:		Called from dita2fo_main.xsl
 -->
<xsl:template match="/*/*[contains(@class, ' map/map ')]
                       /*[contains(@class, ' map/topicref ')]
                         [not(contains(@class, ' bookmap/frontmatter '))]
                         [not(contains(@class, ' bookmap/backmatter '))]" >
    <xsl:call-template name="processChapterMain"/>
</xsl:template>

<!-- 
 function:	Generate content fo:page-sequence from part or chapter
 param:		none (curent is top-level topicref)
 return:	fo:page-sequence
 note:      
 -->
<xsl:template name="processChapterMain">

    <fo:page-sequence>
        <xsl:choose>
            <xsl:when test="$pOnlinePdf">
                <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqChapterOnline')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqChapter')"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="preceding-sibling::*[contains(@class, ' bookmap/chapter ')] or preceding-sibling::*[contains(@class, ' bookmap/part ')]">
            <xsl:attribute name="initial-page-number" select="auto-odd"/>
        </xsl:if>
        <fo:static-content flow-name="rgnChapterBeforeLeft">
            <xsl:call-template name="chapterBeforeLeft"/>
        </fo:static-content>
        <fo:static-content flow-name="rgnChapterBeforeRight">
            <xsl:call-template name="chapterBeforeRight"/>
        </fo:static-content>
        <fo:static-content flow-name="rgnChapterAfterLeft">
            <xsl:call-template name="chapterAfterLeft"/>
        </fo:static-content>
        <fo:static-content flow-name="rgnChapterAfterRight">
            <xsl:call-template name="chapterAfterRight"/>
        </fo:static-content>
        <fo:static-content flow-name="rgnChapterEndRight">
            <xsl:call-template name="chapterEndRight"/>
        </fo:static-content>
        <xsl:if test="$pPdfFormatterAh">
            <fo:static-content flow-name="rgnChapterBlankBody">
                <xsl:call-template name="makeBlankBlock"/>
            </fo:static-content>
        </xsl:if>
        <fo:flow flow-name="xsl-region-body">
            <xsl:apply-templates select="." mode="PROCESS_TOPICREF"/>
        </fo:flow>
    </fo:page-sequence>
</xsl:template>


<!-- 
 function:	Process topicref
 param:		none
 return:	fo:block
 note:		none
 -->
<xsl:template match="*[contains(@class,' map/topicref ')][@href]" mode="PROCESS_TOPICREF">

    <xsl:variable name="topicRef" select="."/>
    <!-- get topic from @href -->
    <xsl:variable name="id" select="substring-after(@href, '#')" as="xs:string"/>
    <xsl:variable name="topicContent" select="if (string($id)) then key('topicById', $id) else ()" as="element()?"/>
    <xsl:variable name="titleMode" select="ahf:getTitleMode($topicRef,())" as="xs:integer"/>
    
    <xsl:choose>
        <xsl:when test="exists($topicContent)">
            <!-- Process contents -->
            <xsl:apply-templates select="$topicContent" mode="PROCESS_MAIN_CONTENT">
                <xsl:with-param name="prmTopicRef"    select="$topicRef"/>
                <xsl:with-param name="prmTitleMode"  select="$titleMode"/>
            </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="warningContinue">
                <xsl:with-param name="prmMes" 
                 select="ahf:replace($stMes070,('%href','%file'),(string(@href),string(@xtrf)))"/>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>

    <!-- Process children.-->
    <xsl:apply-templates select="child::*[contains(@class,' map/topicref ')]" mode="PROCESS_TOPICREF"/>

    <!-- generate fo:index-range-end for metadata -->
    <xsl:call-template name="processIndextermInMetadataEnd">
        <xsl:with-param name="prmTopicRef"     select="$topicRef"/>
        <xsl:with-param name="prmTopicContent" select="$topicContent"/>
    </xsl:call-template>

</xsl:template>

<!-- 
 function:	topichead templates
 param:		none
 return:	descendant topic contents
 note:		
 -->
<xsl:template match="*[contains(@class,' map/topicref ')][not(@href)]" mode="PROCESS_TOPICREF">
    <xsl:apply-templates select="child::*[contains(@class,' map/topicref ')]" mode="PROCESS_TOPICREF"/>
</xsl:template>


<!-- 
 function:	Process topic (part, chapter, appendix and nested topic)
 param:		prmTopicRef, prmTitleMode
 return:	topic contents
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="PROCESS_MAIN_CONTENT">
    <xsl:param name="prmTopicRef"    required="yes" as="element()"/>
    <xsl:param name="prmTitleMode"   required="yes" as="xs:integer"/>
    
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsBase')"/>
        <xsl:copy-of select="ahf:getIdAtts(.,$prmTopicRef,true())"/>
        <xsl:copy-of select="ahf:getLocalizationAtts(.)"/>

        <xsl:choose>
            <xsl:when test="$prmTitleMode=$cRoundBulletTitleMode">
                <!-- Make round bullet title -->
                <xsl:call-template name="genRoundBulletTitle">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="."/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$prmTitleMode=$cSquareBulletTitleMode">
                <!-- Make round bullet title -->
                <xsl:call-template name="genSquareBulletTitle">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="."/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="ancestor::*[contains(@class, ' topic/topic ')]">
                <!-- Nested concept, reference, task -->
                <xsl:call-template name="genSquareBulletTitle">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="."/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$prmTopicRef/ancestor-or-self::*[contains(@class, ' bookmap/appendix ')]">
                <!-- appendix content -->
                <xsl:call-template name="genAppendixTitle">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="."/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <!-- Pointed from bookmap contents -->
                <xsl:call-template name="genChapterTitle">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="."/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>

        <!-- abstract/shortdesc -->
        <xsl:apply-templates select="child::*[contains(@class, ' topic/abstract ')] | child::*[contains(@class, ' topic/shortdesc ')]">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="true()"/>
        </xsl:apply-templates>
        
        <!-- body -->
        <xsl:apply-templates select="child::*[contains(@class, ' topic/body ')]">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="true()"/>
        </xsl:apply-templates>
        
        <!-- nested concept/reference/task -->
        <xsl:apply-templates select="child::*[contains(@class, ' topic/topic ')]" mode="PROCESS_MAIN_CONTENT">
            <xsl:with-param name="prmTopicRef"   select="$prmTopicRef"/>
            <xsl:with-param name="prmTitleMode"  select="$prmTitleMode"/>
        </xsl:apply-templates>
        
        <!-- postnote -->
        <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
            <xsl:call-template name="makePostNote">
                <xsl:with-param name="prmTopicRef"     select="$prmTopicRef"/>
                <xsl:with-param name="prmTopicContent" select="."/>
            </xsl:call-template>
        </xsl:if>
        <!-- related-links -->
        <xsl:apply-templates select="child::*[contains(@class,' topic/related-links ')]"/>
    </fo:block>
</xsl:template>

</xsl:stylesheet>
