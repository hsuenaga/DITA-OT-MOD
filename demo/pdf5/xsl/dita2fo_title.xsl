<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Generate title module.
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
 function:	Heading generation template for frontmatter
 param:		prmLevel, prmTopicRef, prmTopicContent
 return:	title contents
 note:		
 -->
<xsl:template name="genFrontmatterTitle">
    <xsl:param name="prmLevel"        required="yes" as="xs:integer"/>
    <xsl:param name="prmTopicRef"     required="yes" as="element()"/>
    <xsl:param name="prmTopicContent" required="yes" as="element()"/>
    
    <xsl:variable name="titleElement" select="$prmTopicContent/*[contains(@class, ' topic/title ')]"/>
    <xsl:choose>
        <xsl:when test="$prmLevel = 1">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsFmHeader1')"/>
                <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
                <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
                <xsl:call-template name="processIndextermInMetadata">
                    <xsl:with-param name="prmTopicRef"      select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                </xsl:call-template>
                <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:when test="$prmLevel = 2">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsFmHeader2')"/>
                <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
                <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
                <xsl:call-template name="processIndextermInMetadata">
                    <xsl:with-param name="prmTopicRef"      select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                </xsl:call-template>
                <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:when test="$prmLevel = 3">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsFmHeader3')"/>
                <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
                <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
                <xsl:call-template name="processIndextermInMetadata">
                    <xsl:with-param name="prmTopicRef"      select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                </xsl:call-template>
                <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsFmHeader3')"/>
                <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
                <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
                <xsl:call-template name="processIndextermInMetadata">
                    <xsl:with-param name="prmTopicRef"      select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                </xsl:call-template>
                <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	Heading generation template for backmatter
 param:		prmLevel, prmTopicRef, prmTopicContent
 return:	title contents
 note:		Same as frontmatter
 -->
<xsl:template name="genBackmatterTitle">
    <xsl:param name="prmLevel"        required="yes" as="xs:integer"/>
    <xsl:param name="prmTopicRef"     required="yes" as="element()"/>
    <xsl:param name="prmTopicContent" required="yes" as="element()"/>

    <xsl:call-template name="genFrontmatterTitle">
        <xsl:with-param name="prmLevel" select="$prmLevel"/>
        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
    </xsl:call-template>
</xsl:template>

<!-- 
 function:	Heading generation template for part/chapter
 param:		prmTopicRef, prmTopicContent
 return:	title contents
 note:		
 -->
<xsl:template name="genChapterTitle">
    <xsl:param name="prmTopicRef"     required="yes" as="element()"/>
    <xsl:param name="prmTopicContent" required="yes" as="element()"/>
    
    <!-- Nesting level in the bookmap -->
    <xsl:variable name="level" select="count($prmTopicRef/ancestor-or-self::*[contains(@class, ' map/topicref ')][not(contains(@class, ' mapgroup-d/topicgroup '))])"/>
    <!-- Title prefix -->
    <xsl:variable name="titlePrefix">
        <xsl:call-template name="genTitlePrefix">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        </xsl:call-template>
    </xsl:variable>
    <!--title -->
    <xsl:variable name="titleElement" select="$prmTopicContent/child::*[contains(@class, ' topic/title ')]"/>
    <xsl:variable name="title">
        <xsl:apply-templates select="$titleElement" mode="GET_CONTENTS"/>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="$level = 1">
            <fo:block>
                <xsl:choose>
                    <xsl:when test="$pOnlinePdf">
                        <xsl:copy-of select="ahf:getAttributeSet('atsChapterHead1Online')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="ahf:getAttributeSet('atsChapterHead1')"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
                <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
                <xsl:if test="$pAddNumberingTitlePrefix">
                    <fo:marker marker-class-name="{$cTitlePrefix}">
                        <fo:inline><xsl:value-of select="$titlePrefix"/></fo:inline>
                    </fo:marker>
                </xsl:if>
                <fo:marker marker-class-name="{$cTitleBody}">
                    <fo:inline><xsl:copy-of select="$title"/></fo:inline>
                </fo:marker>
                <xsl:call-template name="processIndextermInMetadata">
                    <xsl:with-param name="prmTopicRef"      select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                </xsl:call-template>
                <xsl:if test="$pAddNumberingTitlePrefix">
                    <xsl:value-of select="$titlePrefix"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:when test="$level = 2">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsChapterHead2')"/>
                <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
                <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
                <xsl:if test="$pAddNumberingTitlePrefix">
                    <fo:marker marker-class-name="{$cTitlePrefix}">
                        <fo:inline><xsl:value-of select="$titlePrefix"/></fo:inline>
                    </fo:marker>
                </xsl:if>
                <fo:marker marker-class-name="{$cTitleBody}">
                    <fo:inline><xsl:copy-of select="$title"/></fo:inline>
                </fo:marker>
                <xsl:call-template name="processIndextermInMetadata">
                    <xsl:with-param name="prmTopicRef"      select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                </xsl:call-template>
                <xsl:if test="$pAddNumberingTitlePrefix">
                    <xsl:value-of select="$titlePrefix"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsChapterHead3')"/>
                <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
                <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
                <xsl:call-template name="makeMarker">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef/parent::node()"/>
                </xsl:call-template>
                <xsl:call-template name="processIndextermInMetadata">
                    <xsl:with-param name="prmTopicRef"      select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                </xsl:call-template>
                <xsl:if test="$pAddNumberingTitlePrefix">
                    <xsl:value-of select="$titlePrefix"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	Heading title template
 param:		prmTopicRef, prmNeedId
 return:	title contents
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/title ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:apply-templates>
        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
    </xsl:apply-templates>
</xsl:template>

<!-- 
 function:	Heading generation template for appendix
 param:		prmTopicRef, prmTopicContent
 return:	title contents
 note:		
  -->
<xsl:template name="genAppendixTitle">
    <xsl:param name="prmTopicRef"     required="yes" as="element()"/>
    <xsl:param name="prmTopicContent" required="yes" as="element()"/>
    
    <!-- Nesting level in the bookmap -->
    <xsl:variable name="level"> 
        <xsl:value-of select="count($prmTopicRef/ancestor-or-self::*[contains(@class, ' map/topicref ')])"/>
    </xsl:variable>
    <!-- Title prefix -->
    <xsl:variable name="titlePrefix">
        <xsl:call-template name="genTitlePrefix">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        </xsl:call-template>
    </xsl:variable>
    <!--title -->
    <xsl:variable name="titleElement" select="$prmTopicContent/child::*[contains(@class, ' topic/title ')]"/>
    <xsl:variable name="title">
        <xsl:apply-templates select="$titleElement" mode="GET_CONTENTS"/>
    </xsl:variable>

    <xsl:choose>
        <xsl:when test="$level = 1">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsAppendixHead1')"/>
                <xsl:choose>
                    <xsl:when test="$pOnlinePdf">
                        <xsl:copy-of select="ahf:getAttributeSet('atsAppendixHead1Online')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="ahf:getAttributeSet('atsAppendixHead1')"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
                <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
                <xsl:if test="$pAddNumberingTitlePrefix">
                    <fo:marker marker-class-name="{$cTitlePrefix}">
                        <fo:inline><xsl:value-of select="$titlePrefix"/></fo:inline>
                    </fo:marker>
                </xsl:if>
                <fo:marker marker-class-name="{$cTitleBody}">
                    <fo:inline><xsl:value-of select="$title"/></fo:inline>
                </fo:marker>
                <xsl:call-template name="processIndextermInMetadata">
                    <xsl:with-param name="prmTopicRef"     select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                </xsl:call-template>
                <xsl:if test="$pAddNumberingTitlePrefix">
                    <xsl:value-of select="$titlePrefix"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:when test="$level = 2">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsAppendixHead2')"/>
                <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
                <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
                <xsl:if test="$pAddNumberingTitlePrefix">
                    <fo:marker marker-class-name="{$cTitlePrefix}">
                        <fo:inline><xsl:value-of select="$titlePrefix"/></fo:inline>
                    </fo:marker>
                </xsl:if>
                <fo:marker marker-class-name="{$cTitleBody}">
                    <fo:inline><xsl:value-of select="$title"/></fo:inline>
                </fo:marker>
                <xsl:call-template name="processIndextermInMetadata">
                    <xsl:with-param name="prmTopicRef"     select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                </xsl:call-template>
                <xsl:if test="$pAddNumberingTitlePrefix">
                    <xsl:value-of select="$titlePrefix"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsAppendixHead3')"/>
                <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
                <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
                <xsl:call-template name="makeMarker">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef/parent::node()"/>
                </xsl:call-template>
                <xsl:call-template name="processIndextermInMetadata">
                    <xsl:with-param name="prmTopicRef"     select="$prmTopicRef"/>
                    <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                </xsl:call-template>
                <xsl:if test="$pAddNumberingTitlePrefix">
                    <xsl:value-of select="$titlePrefix"/>
                    <xsl:text> </xsl:text>
                </xsl:if>
                <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	Square bullet heading generation 
 param:		prmTopicRef, prmTopicContent
 return:	title contents
 note:		for nested topic/concept/task/reference or toc="no" specified contents
 -->
<xsl:template name="genSquareBulletTitle">
    <xsl:param name="prmTopicRef"     required="yes" as="element()"/>
    <xsl:param name="prmTopicContent" required="yes" as="element()"/>

    <!--title -->
    <xsl:variable name="titleElement" select="$prmTopicContent/child::*[contains(@class, ' topic/title ')]"/>

    <fo:list-block>
        <xsl:copy-of select="ahf:getAttributeSet('atsHeader4List')"/>
        <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
        <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
        <fo:list-item>
            <xsl:copy-of select="ahf:getAttributeSet('atsHeader4ListItem')"/>
            <fo:list-item-label end-indent="label-end()">
                <fo:block>
                    <xsl:copy-of select="ahf:getAttributeSet('atsHeader4Label')"/>
                    <xsl:call-template name="processIndextermInMetadata">
                        <xsl:with-param name="prmTopicRef"      select="$prmTopicRef"/>
                        <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                    </xsl:call-template>
                    <fo:inline>
                        <xsl:copy-of select="ahf:getAttributeSet('atsHeader4LabelInline')"/>
                        <xsl:value-of select="$cLevel4LabelChar"/>
                    </fo:inline>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <xsl:copy-of select="ahf:getAttributeSet('atsHeader4Body')"/>
                    <xsl:apply-templates select="$titleElement">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                    </xsl:apply-templates>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </fo:list-block>
</xsl:template>

<!-- 
 function:	Round bullet heading generation 
 param:		prmTopicRef, prmTopicContent
 return:	Title contents
 note:
  -->
<xsl:template name="genRoundBulletTitle">
    <xsl:param name="prmTopicRef"     required="yes" as="element()"/>
    <xsl:param name="prmTopicContent" required="yes" as="element()"/>
    
    <!--title -->
    <xsl:variable name="titleElement" select="$prmTopicContent/child::*[contains(@class, ' topic/title ')]"/>

    <fo:list-block>
        <xsl:copy-of select="ahf:getAttributeSet('atsHeader5List')"/>
        <xsl:copy-of select="ahf:getIdAtts($titleElement,$prmTopicRef,true())"/>
        <xsl:copy-of select="ahf:getLocalizationAtts($titleElement)"/>
        <fo:list-item>
            <xsl:copy-of select="ahf:getAttributeSet('atsHeader5ListItem')"/>
            <fo:list-item-label end-indent="label-end()">
                <fo:block>
                    <xsl:copy-of select="ahf:getAttributeSet('atsHeader5Label')"/>
                    <xsl:call-template name="processIndextermInMetadata">
                        <xsl:with-param name="prmTopicRef"      select="$prmTopicRef"/>
                        <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
                    </xsl:call-template>
                    <fo:inline>
                        <xsl:copy-of select="ahf:getAttributeSet('atsHeader5LabelInline')"/>
                        <xsl:value-of select="$cLevel5LabelChar"/>
                    </fo:inline>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <xsl:copy-of select="ahf:getAttributeSet('atsHeader5Body')"/>
                    <xsl:apply-templates select="$titleElement">
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        <xsl:with-param name="prmNeedId"   select="true()"/>
                    </xsl:apply-templates>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </fo:list-block>
</xsl:template>

<!-- 
 function:	Generate fo:marker from topichead/topicref element
 param:		prmTopicRef (topichead or topicref)
 return:	fo:marker
 note:		
 -->
<xsl:template name="makeMarker">
    <xsl:param name="prmTopicRef"     required="yes" as="element()"/>
    
    <!-- Title prefix -->
    <xsl:variable name="titlePrefix">
        <xsl:call-template name="genTitlePrefix">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        </xsl:call-template>
    </xsl:variable>

    <!-- title -->
    <xsl:variable name="title">
        <xsl:choose>
            <xsl:when test="not($prmTopicRef/@href)">
                <xsl:value-of select="$prmTopicRef/@navtitle"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="id" select="substring-after($prmTopicRef/@href, '#')"/>
                <xsl:variable name="topicContent" select="key('topicById', $id)"/>
                <xsl:apply-templates select="$topicContent/*[contains(@class, ' topic/title ')]" mode="GET_CONTENTS"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:if test="$pAddNumberingTitlePrefix">
        <fo:marker marker-class-name="{$cTitlePrefix}">
            <fo:inline><xsl:value-of select="$titlePrefix"/></fo:inline>
        </fo:marker>
    </xsl:if>
    <fo:marker marker-class-name="{$cTitleBody}">
        <fo:inline><xsl:copy-of select="$title"/></fo:inline>
    </fo:marker>
</xsl:template>


</xsl:stylesheet>