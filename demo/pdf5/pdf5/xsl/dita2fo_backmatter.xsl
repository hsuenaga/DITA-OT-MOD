<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Backmatter stylesheet
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
 exclude-result-prefixes="xs ahf"
>

<!-- 
 function:	Generate back matter
 param:		none
 return:	fo:page-sequence
 note:		Called from dita2fo_main.xsl
 -->
<xsl:template match="*[contains(@class, ' bookmap/backmatter ')]" >
    <xsl:if test="descendant::*[contains(@class,' map/topicref ')][@href]
                | descendant::*[contains(@class,' bookmap/toc ')][not(@href)]
                | descendant::*[contains(@class,' bookmap/indexlist ')][not(@href)]
                | descendant::*[contains(@class,' bookmap/figurelist ')][not(@href)]
                | descendant::*[contains(@class,' bookmap/tablelist ')][not(@href)]">
        <fo:page-sequence>
            <xsl:choose>
                <xsl:when test="$pOnlinePdf">
                    <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqBackMatterOnline')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqBackMatter')"/>
                </xsl:otherwise>
            </xsl:choose>
            <fo:static-content flow-name="rgnBackmatterBeforeLeft">
                <xsl:call-template name="backmatterBeforeLeft"/>
            </fo:static-content>
            <fo:static-content flow-name="rgnBackmatterBeforeRight">
                <xsl:call-template name="backmatterBeforeRight"/>
            </fo:static-content>
            <fo:static-content flow-name="rgnBackmatterAfterLeft">
                <xsl:call-template name="backmatterAfterLeft"/>
            </fo:static-content>
            <fo:static-content flow-name="rgnBackmatterAfterRight">
                <xsl:call-template name="backmatterAfterRight"/>
            </fo:static-content>
            <fo:static-content flow-name="rgnBackmatterBlankBody">
                <xsl:call-template name="makeBlankBlock"/>
            </fo:static-content>
            <fo:flow flow-name="xsl-region-body">
                <xsl:apply-templates mode="PROCESS_BACKMATTER"/>
            </fo:flow>
        </fo:page-sequence>
    </xsl:if>
</xsl:template>


<!-- 
 function:	Back matter's general template
 param:		none
 return:	none
 note:		
 -->
<xsl:template match="*" mode="PROCESS_BACKMATTER">
    <xsl:apply-templates mode="PROCESS_BACKMATTER"/>
</xsl:template>

<xsl:template match="text()" mode="PROCESS_BACKMATTER"/>

<!-- Ignore topicref level's topicmeta
 -->
<xsl:template match="*[contains(@class, ' map/topicmeta ')]" mode="PROCESS_BACKMATTER"/>

<!-- 
 function:	topichead templates
 param:		none
 return:	descendant topic contents
 note:		
 -->
<xsl:template match="*[contains(@class,' map/topicref ')][not(@href)]" mode="PROCESS_BACKMATTER">
    <xsl:apply-templates select="child::*[contains(@class,' map/topicref ')]" mode="PROCESS_BACKMATTER"/>
</xsl:template>

<!-- 
 function:	Trigger of making TOC
 param:		none
 return:	toc contents
 note:		
 -->
<xsl:template match="*[contains(@class,' bookmap/toc ')][not(@href)]" mode="PROCESS_BACKMATTER" priority="2">
    <xsl:call-template name="genToc"/>
</xsl:template>

<!-- 
 function:	Trigger of making index
 param:		none
 return:	index contents
 note:		
 -->
<xsl:template match="*[contains(@class,' bookmap/indexlist ')][not(@href)]" mode="PROCESS_BACKMATTER" priority="2">
    <xsl:call-template name="genIndex"/>
</xsl:template>

<!-- 
 function:	Trigger of making Figure list
 param:		none
 return:	figure list contents
 note:		
 -->
<xsl:template match="*[contains(@class,' map/topicref ')][contains(@class,' bookmap/figurelist ')][not(@href)]" mode="PROCESS_BACKMATTER" priority="2" >
    <xsl:call-template name="genFigureList"/>
</xsl:template>

<!-- 
 function:	Trigger of making Table list
 param:		none
 return:	table list contents
 note:		
 -->
<xsl:template match="*[contains(@class,' map/topicref ')][contains(@class,' bookmap/tablelist ')][not(@href)]" mode="PROCESS_BACKMATTER" priority="2" >
    <xsl:call-template name="genTableList"/>
</xsl:template>


<!-- 
 function:	Process back matter's topicref
 param:		none
 return:	topic contents
 note:		none
 -->
<xsl:template match="*[contains(@class,' map/topicref ')][@href]" mode="PROCESS_BACKMATTER">

    <xsl:variable name="topicRef" select="."/>
    <!-- get topic from @href -->
    <xsl:variable name="id" select="substring-after(@href, '#')" as="xs:string"/>
    <xsl:variable name="topicContent" select="if (string($id)) then key('topicById', $id) else ()" as="element()?"/>
    <xsl:variable name="titleMode" select="ahf:getTitleMode($topicRef,())" as="xs:integer"/>
    
    <xsl:choose>
        <xsl:when test="exists($topicContent)">
            <!-- Process contents -->
            <xsl:apply-templates select="$topicContent" mode="OUTPUT_BACKMATTER">
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
    
    <!-- Process children.
     -->
    <xsl:apply-templates select="child::*[contains(@class,' map/topicref ')]" mode="PROCESS_BACKMATTER"/>
    
    <!-- generate fo:index-range-end for metadata -->
    <xsl:call-template name="processIndextermInMetadataEnd">
        <xsl:with-param name="prmTopicRef"     select="$topicRef"/>
        <xsl:with-param name="prmTopicContent" select="$topicContent"/>
    </xsl:call-template>
    
</xsl:template>

<!-- 
 function:	Process backmatter topic
 param:		prmTopicRef, prmTitleMode
 return:	topic contents
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/topic ')]" mode="OUTPUT_BACKMATTER">
    <xsl:param name="prmTopicRef"    required="yes" as="element()"/>
    <xsl:param name="prmTitleMode"   required="yes" as="xs:integer"/>
    
    <!-- Nesting level in the bookmap 
         topicgroup is skipped in dita2fo_convmerged.xsl.
     -->
    <xsl:variable name="level" 
                  as="xs:integer"
                  select="count($prmTopicRef/ancestor-or-self::*[contains(@class, ' map/topicref ')]
                                                               [not(contains(@class, ' bookmap/backmatter '))]
                                                               )"/>
    <!--
                                                               [not(contains(@class, ' mapgroup-d/topicgroup '))]
     -->
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
                <!-- Make square bullet title -->
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
            <xsl:otherwise>
                <!-- Pointed from bookmap contents -->
                <xsl:call-template name="genBackmatterTitle">
                    <xsl:with-param name="prmLevel" select="$level"/>
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
        <xsl:apply-templates select="child::*[contains(@class, ' topic/topic ')]" mode="OUTPUT_BACKMATTER">
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
