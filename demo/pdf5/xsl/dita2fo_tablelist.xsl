<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Table list stylesheet
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
 function:	Generate table list template
 param:		none
 return:	(fo:page-sequence)
 note:		
 -->
<xsl:template name="genTableList" >
    <xsl:if test="$tableCountMap/tablecount[@count &gt; 0]">
        <!-- If you want make new page sequence for figure list, 
             comment out next line and delete comment symbol of following line.
         -->
        <xsl:call-template name="genTableListMain"/>
        <!--psmi:page-sequence>
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
                <xsl:call-template name="genTableListMain"/>
            </fo:flow>
        </psmi:page-sequence-->
    </xsl:if>
</xsl:template>


<!-- 
 function:	Figure list main template
 param:		none
 return:	fo:block
 note:		
 -->
<xsl:template name="genTableListMain">
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsBase')"/>
        <!-- Title -->
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsFmHeader1')"/>
            <xsl:attribute name="id">
                <xsl:value-of select="$cTableListId"/>
            </xsl:attribute>
            <fo:marker marker-class-name="{$cTitleBody}">
                <fo:inline><xsl:copy-of select="$cTableListTitle"/></fo:inline>
            </fo:marker>
            <xsl:value-of select="$cTableListTitle"/>
        </fo:block>
        <!-- Make contents -->
		<xsl:apply-templates select="$map" mode="MAKE_TABLE_LIST"/>
    </fo:block>
</xsl:template>
 
<!-- 
 function:	General templates for figure list
 param:		none
 return:	
 note:		none
 -->
<xsl:template match="*" mode="MAKE_TABLE_LIST">
    <xsl:apply-templates mode="MAKE_TABLE_LIST"/>
</xsl:template>

<xsl:template match="text()" mode="MAKE_TABLE_LIST"/>
<xsl:template match="*[contains(@class, ' bookmap/bookmeta ')]" mode="MAKE_TABLE_LIST"/>

<!-- Frontmatter -->
<xsl:template match="*[contains(@class,' bookmap/frontmatter ')]" mode="MAKE_TABLE_LIST" priority="2" >
    <xsl:apply-templates mode="MAKE_TABLE_LIST"/>
</xsl:template>

<!-- Backmatter -->
<xsl:template match="*[contains(@class,' bookmap/backmatter ')]" mode="MAKE_TABLE_LIST" priority="2" >
    <xsl:apply-templates mode="MAKE_TABLE_LIST"/>
</xsl:template>

<!-- frontmatter/backmatter contents -->

<xsl:template match="*[contains(@class,' bookmap/booklists ')]" mode="MAKE_TABLE_LIST" priority="2" >
    <xsl:apply-templates mode="MAKE_TABLE_LIST"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/toc ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!--Ignore TOC -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/figurelist ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/tablelist ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/abbrevlist ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Abbrevlist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/trademarklist ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Trademarklist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/bibliolist ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Bibliolist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/glossarylist ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Glossarylist have topicref child element. -->
    <xsl:apply-templates mode="MAKE_TABLE_LIST"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/indexlist ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Index line -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/booklist ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Booklist should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/notices ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Notices have topicref child element. -->
    <xsl:apply-templates mode="MAKE_TABLE_LIST"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/preface ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Preface has topicref child element. -->
    <xsl:apply-templates mode="MAKE_TABLE_LIST"/>
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/dedication ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Dedication should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/colophon ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Colophon should have a href attribute. -->
</xsl:template>

<xsl:template match="*[contains(@class,' bookmap/amendments ')][not(@href)]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- Aamendments should have a href attribute. -->
</xsl:template>

<!-- topicgroup is skipped in dita2fo_convmerged.xsl -->
<xsl:template match="*[contains(@class,' mapgroup-d/topicgroup ')]" mode="MAKE_TABLE_LIST" priority="2" >
    <!-- topicgroup create group without affecting the hierarchy. -->
    <xsl:apply-templates mode="MAKE_TABLE_LIST"/>
</xsl:template>

<!-- Ignore reltable contents -->
<xsl:template match="*[contains(@class,' map/reltable ')]" mode="MAKE_TABLE_LIST" />

<!-- 
 function:	templates for topicref
 param:		none
 return:	Table list line
 note:		Process all of the map/topicref contents.
 -->
<xsl:template match="*[contains(@class,' map/topicref ')][@href]" mode="MAKE_TABLE_LIST">
    <xsl:variable name="topicRef" select="."/>
    <xsl:variable name="id" select="substring-after(@href, '#')"/>
    <xsl:variable name="topicContent" select="if (string($id)) then key('topicById',$id) else ()" as="element()?"/>
    <xsl:variable name="topicRefCount" select="ahf:countTopicRef(.)" as="xs:integer"/>

    <xsl:for-each select="$topicContent/descendant::*[contains(@class, ' topic/table ')][child::*[contains(@class, ' topic/title ')]]">
        <xsl:variable name="table" select="."/>
        <xsl:variable name="tableId" select="if (@id) then string(ahf:getIdAtts($table,$topicRef,true())) else ahf:generateIdByTrCount($table,$topicRefCount)" as="xs:string"/>
        <xsl:variable name="tableTitle" as="node()*">
            <xsl:apply-templates select="$table/*[contains(@class,' topic/title ')]" mode="MAKE_TABLE_LIST">
                <xsl:with-param name="prmTopicRef"    select="$topicRef"/>
                <xsl:with-param name="prmNeedId"      select="false()"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:call-template name="makeTableListLine">
            <xsl:with-param name="prmId"    select="$tableId"/>
            <xsl:with-param name="prmTitle" select="$tableTitle"/>
        </xsl:call-template>
    </xsl:for-each>
    <!-- Navigate to lower level -->
    <xsl:apply-templates mode="MAKE_TABLE_LIST"/>
</xsl:template>

<!-- table/title -->
<xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]" priority="2" mode="MAKE_TABLE_LIST">
    <xsl:param name="prmTopicRef" required="yes"  as="element()"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <fo:inline>
        <xsl:value-of select="ahf:getTableTitlePrefix($prmTopicRef,parent::*)"/>
        <xsl:text>&#x00A0;</xsl:text>
        <xsl:text>&#x00A0;</xsl:text>
    </fo:inline>
    <fo:inline>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef"    select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"      select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:inline>
</xsl:template>


<!-- 
 function:	Make table list line
 param:		prmId, prmTitle
 return:	fo:block
 note:		
 -->
<xsl:template name="makeTableListLine">
    <xsl:param name="prmId"    required="yes" as="xs:string"/>
    <xsl:param name="prmTitle" required="yes" as="node()*"/>

    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsTableListLine')"/>
        <fo:basic-link internal-destination="{$prmId}">
            <xsl:copy-of select="$prmTitle"/>
        </fo:basic-link>
		<fo:leader leader-length.optimum="0pt">
            <xsl:copy-of select="ahf:getAttributeSet('atsTableListLeader')"/>
        </fo:leader>
        <fo:inline keep-with-next="always">
            <fo:leader>
                <xsl:copy-of select="ahf:getAttributeSet('atsTableListLeader')"/>
            </fo:leader>
        </fo:inline>
        <fo:basic-link internal-destination="{$prmId}">
            <fo:page-number-citation ref-id="{$prmId}" />
        </fo:basic-link>
    </fo:block>
</xsl:template>

</xsl:stylesheet>
