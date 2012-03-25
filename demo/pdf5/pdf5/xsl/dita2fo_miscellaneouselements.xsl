<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet 
Module: Miscellaneous elements stylesheet
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
 function:	draft-comment template
 param:     prmTopicRef, prmNeedId
 return:	fo:block
 note:		none
 -->
<xsl:variable name="draftCommentTitlePrefix" select="ahf:getVarValue('Draft_Comment_Title_Prefix')"/>
<xsl:variable name="draftCommentAuthor"      select="ahf:getVarValue('Draft_Comment_Author')"/>
<xsl:variable name="draftCommentTime"        select="ahf:getVarValue('Draft_Comment_Time')"/>
<xsl:variable name="draftCommentDisposition" select="ahf:getVarValue('Draft_Comment_Disposition')"/>
<xsl:variable name="draftCommentTitleSuffix" select="ahf:getVarValue('Draft_Comment_Title_Suffix')"/>

<xsl:template match="*[contains(@class,' topic/draft-comment ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:if test="$pOutputDraftComment">
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsDraftComment')"/>
            <xsl:copy-of select="ahf:getIdAtts(.,$prmTopicRef,$prmNeedId)"/>
            <xsl:copy-of select="ahf:getLocalizationAtts(.)"/>
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsDraftCommentTitle')"/>
                <xsl:value-of select="$draftCommentTitlePrefix"/>
                <xsl:if test="string(@author)">
                    <xsl:value-of select="$draftCommentAuthor"/>
                    <xsl:value-of select="@author"/>
                </xsl:if>
                <xsl:if test="string(@time)">
                    <xsl:value-of select="$draftCommentTime"/>
                    <xsl:value-of select="@time"/>
                </xsl:if>
                <xsl:if test="string(@disposition)">
                    <xsl:value-of select="$draftCommentDisposition"/>
                    <xsl:value-of select="@disposition"/>
                </xsl:if>
                <xsl:value-of select="$draftCommentTitleSuffix"/>
            </fo:block>
            <xsl:apply-templates>
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            </xsl:apply-templates>
        </fo:block>
    </xsl:if>
</xsl:template>


<!-- 
 function:	fn template
 param:     prmTopicRef, prmNeedId
 return:	fo:basic-link(fo:footnote)
 note:		none
 -->
<xsl:template match="*[contains(@class,' topic/fn ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:variable name="fn" select="."/>
    <xsl:variable name="fnPrefix" select="ahf:getFootnotePrefix($fn,$prmTopicRef)"/>
    <!-- standard fo:footnote generation method -->
    <!--fo:footnote>
        <xsl:choose>
            <xsl:when test="@id">
                <fo:inline/>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline>
                    <xsl:copy-of select="ahf:getAttributeSet('atsFnPrefix')"/>
                    <xsl:value-of select="$fnPrefix"/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
        
        <fo:footnote-body>
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsFnBody')"/>
                <fo:inline>
                    <xsl:copy-of select="ahf:getAttributeSet('atsFnPrefix')"/>
                    <xsl:value-of select="$fnPrefix"/>
                    <xsl:value-of select="' '"/>
                </fo:inline>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="true()"/>
                </xsl:apply-templates>
            </fo:block>
        </fo:footnote-body>
    </fo:footnote-->
    
    <!-- This stylesheet outputs footnote as postnote -->
    <xsl:choose>
        <xsl:when test="@id">
            <fo:inline/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="id" select="ahf:generateId(.,$prmTopicRef)"/>
            <fo:basic-link internal-destination="{$id}">
                <xsl:copy-of select="ahf:getAttributeSet('atsFnPrefix')"/>
                <xsl:value-of select="$fnPrefix"/>
            </fo:basic-link>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	Generate footnote prefix
 param:		prmFn
 return:	Footnote title prefix
 note:		
 -->
<xsl:function name="ahf:getFootnotePrefix" as="xs:string">
    <xsl:param name="prmFn" as="element()"/>
    <xsl:param name="prmTopicRef" as="element()"/>

    <xsl:choose>
        <xsl:when test="$prmFn/@callout">
            <xsl:sequence select="string($prmFn/@callout)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="topicNode" select="$prmFn/ancestor::*[contains(@class, ' topic/topic ')][position()=last()]"/>
            <xsl:variable name="fnPreviousAmount" as="xs:integer">
                <xsl:variable name="topicNodeId" select="ahf:generateIdByTopicRef(string($topicNode/@id),$prmTopicRef)"/>
                <xsl:sequence select="$footnoteNumberingMap/*[@id=$topicNodeId]/@count"/>
            </xsl:variable>
            <xsl:variable name="fnCurrentAmount" as="xs:integer">
                <xsl:number select="$prmFn"
                            level="any"
                            count="*[contains(@class,' topic/fn ')][not(contains(@class,' pr-d/synnote '))][not(@callout)]"
                            from="*[contains(@class, ' topic/topic ')][generate-id(parent::*)=$rootId]"/>
            </xsl:variable>
            <xsl:variable name="fnNumber" select="$fnPreviousAmount + $fnCurrentAmount" as="xs:integer"/>
            <xsl:sequence select="concat($cFootnoteTagPrefix,string($fnNumber),$cFootnoteTagSuffix)"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<!-- indexterm is coded in dita2fo_indexterm.xsl, dita2fo_index.xsl. -->
<!-- indextermref is defined as future use in DITA1.1 spec. -->
<!-- index-base is coded in dita2fo_indexterm.xsl, dita2fo_index.xsl. (Only skip element.)-->

<!-- 
 function:	tm
 param:     prmTopicRef, prmNeedId
 return:	fo:inline
 note:		none
 -->
<xsl:variable name="tmSymbolTm"      select="ahf:getVarValue('Tm_Symbol_Tm')"/>
<xsl:variable name="tmSymbolReg"     select="ahf:getVarValue('Tm_Symbol_Reg')"/>
<xsl:variable name="tmSymbolService" select="ahf:getVarValue('Tm_Symbol_Service')"/>

<xsl:template match="*[contains(@class,' topic/tm ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:inline>
        <xsl:copy-of select="ahf:getAttributeSet('atsTm')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef"    select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
        
        <fo:inline>
            <xsl:copy-of select="ahf:getAttributeSet('atsTmSymbol')"/>
            <xsl:choose>
                <xsl:when test="@tmtype='tm'">
                    <xsl:value-of select="$tmSymbolTm"/>
                </xsl:when>
                <xsl:when test="@tmtype='reg'">
                    <xsl:value-of select="$tmSymbolReg"/>
                </xsl:when>
                <xsl:when test="@tmtype='service'">
                    <xsl:copy-of select="ahf:getAttributeSet('atsTmSymbolSm')"/>
                    <xsl:value-of select="$tmSymbolService"/>
                </xsl:when>
            </xsl:choose>
        </fo:inline>
    </fo:inline>

</xsl:template>

<!-- 
 function:	data-about
 param:	    prmTopicRef, prmNeedId
 return:	none
 note:		ignore descendant-or-self
 -->
<xsl:template match="*[contains(@class,' topic/data-about ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
</xsl:template>

<!-- 
 function:	data
 param:	    prmTopicRef, prmNeedId
 return:	none
 note:		ignore descendant-or-self
 -->
<xsl:template match="*[contains(@class,' topic/data ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
</xsl:template>


</xsl:stylesheet>