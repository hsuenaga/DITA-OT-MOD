<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet 
Module: Specialization elements stylesheet
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
 function:	itemgroup template
 param:	    prmTopicRef, prmNeedId
 return:	fo:block
 note:		none
 -->
<xsl:template match="*[contains(@class,' topic/itemgroup ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsItemGroup')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
</xsl:template>

<!-- 
 function:	no-topic-nesting template
 param:	    prmTopicRef, prmNeedId
 return:	none
 note:		none
 -->
<xsl:template match="*[contains(@class,' topic/no-topic-nesting ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
</xsl:template>

<!-- 
 function:	required-cleanup template
 param:	    prmTopicRef, prmNeedId
 return:	fo:block
 note:		none
 -->
<xsl:variable name="requiredCleanupTitlePrefix" select="ahf:getVarValue('Required_Cleanup_Title_Prefix')"/>
<xsl:variable name="requiredCleanupRemap"       select="ahf:getVarValue('Required_Cleanup_Remap')"/>
<xsl:variable name="requiredCleanupTitleSuffix" select="ahf:getVarValue('Required_Cleanup_Title_Suffix')"/>

<xsl:template match="*[contains(@class,' topic/required-cleanup ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:if test="$pOutputRequiredCleanup">
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsRequiredCleanup')"/>
            <xsl:copy-of select="ahf:getIdAtts(.,$prmTopicRef,$prmNeedId)"/>
            <xsl:copy-of select="ahf:getLocalizationAtts(.)"/>
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsRequiredCleanupTitle')"/>
                <xsl:value-of select="$requiredCleanupTitlePrefix"/>
                <xsl:if test="string(@remap)">
                    <xsl:value-of select="$requiredCleanupRemap"/>
                    <xsl:value-of select="@remap"/>
                </xsl:if>
                <xsl:value-of select="$requiredCleanupTitleSuffix"/>
            </fo:block>
            <xsl:apply-templates>
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            </xsl:apply-templates>
        </fo:block>
    </xsl:if>
</xsl:template>

<!-- 
 function:	state template
 param:	    prmTopicRef, prmNeedId
 return:	fo:inline
 note:		return @name=@value inline.
 -->
<xsl:template match="*[contains(@class,' topic/state ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:inline>
        <xsl:copy-of select="ahf:getAttributeSet('atsState')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:value-of select="@name"/>
        <xsl:text>=</xsl:text>
        <xsl:value-of select="@value"/>
    </fo:inline>
</xsl:template>

<!-- 
 function:	term template
 param:	    prmTopicRef, prmNeedId
 return:	fo:inline
 note:		
 -->
<xsl:template match="*[contains(@class,' topic/term ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:inline>
        <xsl:copy-of select="ahf:getAttributeSet('atsTerm')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:inline>
</xsl:template>

<!-- 
 function:	boolean template
 param:	    prmTopicRef, prmNeedId
 return:	fo:inline
 note:		
 -->
<xsl:template match="*[contains(@class,' topic/boolean ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:inline>
        <xsl:copy-of select="ahf:getAttributeSet('atsBoolean')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:value-of select="@state"/>
    </fo:inline>
</xsl:template>

</xsl:stylesheet>