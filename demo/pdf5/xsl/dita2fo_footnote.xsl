<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Make footnote as postnote
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
 function:  postnote control
 param:     prmTopicRef, prmTopicContent
 return:    related-links fo objects
 note:        
 -->
<xsl:template name="makePostNote">
    <xsl:param name="prmTopicRef" required="yes" as="element()"/>
    <xsl:param name="prmTopicContent" required="yes" as="element()"/>
    <xsl:variable name="noteCount" select="count($prmTopicContent/descendant::*[contains(@class,' topic/fn ')][not(contains(@class,' pr-d/synnote '))])"/>
    <xsl:if test="$noteCount &gt; 0">
        <xsl:call-template name="makePostNoteSub">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
        </xsl:call-template>
    </xsl:if>
</xsl:template>

<!-- 
 function:  Make postnote sub
 param:     prmTopicRef, prmTopicContent
 return:    fo:block (postnote fo objects)
 note:        
 -->
<xsl:template name="makePostNoteSub">
    <xsl:param name="prmTopicRef" required="yes" as="element()"/>
    <xsl:param name="prmTopicContent" required="yes" as="element()"/>
    
    <!-- Make related-link title block -->
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsPostnoteTitleBeforeBlock')"/>
        <fo:leader>
            <xsl:copy-of select="ahf:getAttributeSet('atsPostnoteLeader1')"/>
        </fo:leader>
        <fo:inline>
            <xsl:copy-of select="ahf:getAttributeSet('atsPostnoteInline')"/>
            <xsl:value-of select="ahf:getVarValue('Postnote_Title')"/>
        </fo:inline>
        <fo:leader>
            <xsl:copy-of select="ahf:getAttributeSet('atsPostnoteLeader2')"/>
        </fo:leader>
    </fo:block>
    
    <!-- process postnote -->
    <xsl:call-template name="processPostnote">
        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        <xsl:with-param name="prmTopicContent" select="$prmTopicContent"/>
    </xsl:call-template>
    
    <!-- Make postnote end block -->
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsPostnoteTitleAfterBlock')"/>
        <fo:leader>
            <xsl:copy-of select="ahf:getAttributeSet('atsPostnoteLeader3')"/>
        </fo:leader>
    </fo:block>
</xsl:template>

<!-- 
 function:  Process postnote
 param:     prmTopicRef, prmTopicContent
 return:    postnote list blocks
 note:        
 -->
<xsl:template name="processPostnote">
    <xsl:param name="prmTopicRef" required="yes" as="element()"/>
    <xsl:param name="prmTopicContent" required="yes" as="element()"/>
    
    <fo:list-block>
        <xsl:copy-of select="ahf:getAttributeSet('atsPostnoteListBlock')"/>
        <xsl:for-each select="$prmTopicContent/descendant::*[contains(@class,' topic/fn ')]">
            <xsl:variable name="fn" select="."/>
            <fo:list-item>
                <xsl:copy-of select="ahf:getAttributeSet('atsPostnoteLi')"/>
                <xsl:if test="position()=1">
                    <xsl:attribute name="space-before" select="'0mm'"/>
                </xsl:if>
                <fo:list-item-label end-indent="label-end()"> 
                    <fo:block>
                        <xsl:copy-of select="ahf:getAttributeSet('atsPostnoteLabel')"/>
                        <xsl:value-of select="ahf:getFootnotePrefix($fn,$prmTopicRef)"/>
                    </fo:block>
                </fo:list-item-label>
                <fo:list-item-body start-indent="body-start()">
                    <fo:block>
                        <xsl:copy-of select="ahf:getAttributeSet('atsPostnoteBody')"/>
                        <xsl:copy-of select="ahf:getUnivAtts($fn,$prmTopicRef,true())"/>
                        <xsl:if test="not($fn/@id)">
                            <xsl:attribute name="id" select="ahf:generateId($fn,$prmTopicRef)"/>
                        </xsl:if>
                        <xsl:apply-templates>
                            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                            <xsl:with-param name="prmNeedId"   select="true()"/>
                        </xsl:apply-templates>
                    </fo:block>
                </fo:list-item-body>
            </fo:list-item>
        </xsl:for-each>
    </fo:list-block>
</xsl:template>


</xsl:stylesheet>
