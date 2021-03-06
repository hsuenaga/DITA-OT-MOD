<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Table templates
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
<!-- **************************** 
        Table Templates
     ****************************-->
<!-- 
 function:	table template
 param:	    prmTopicRef, prmNeedId
 return:	fo:wrapper
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/table ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:variable name="tableAttr" select="ahf:getTableAttr(.)" as="element()"/>
    <fo:wrapper>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:if test="not(@id) and child::*[contains(@class, ' topic/title ')]">
            <xsl:attribute name="id" select="ahf:generateId(.,$prmTopicRef)"/>
        </xsl:if>
        <xsl:apply-templates select="*[contains(@class, ' topic/desc ')]">
            <xsl:with-param name="prmTopicRef"  select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"    select="$prmNeedId"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="*[contains(@class, ' topic/tgroup ')]">
            <xsl:with-param name="prmTopicRef"  select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"    select="$prmNeedId"/>
            <xsl:with-param name="prmTableAttr" select="$tableAttr"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="*[contains(@class, ' topic/title ')]">
            <xsl:with-param name="prmTopicRef"  select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"    select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:wrapper>
</xsl:template>

<!-- 
 function:	build table attributes
 param:		prmTable
 return:	element()
 note:		
 -->
<xsl:function name="ahf:getTableAttr" as="element()">
    <xsl:param name="prmTable" as="element()"/>
    <dummy>
        <xsl:attribute name="frame"  select="if ($prmTable/@frame)  then string($prmTable/@frame) else 'all'"/>
        <xsl:attribute name="colsep" select="if ($prmTable/@colsep) then string($prmTable/@colsep) else '1'"/>
        <xsl:attribute name="rowsep" select="if ($prmTable/@rowsep) then string($prmTable/@rowsep) else '1'"/>
        <xsl:attribute name="pgwide" select="if ($prmTable/@pgwide) then string($prmTable/@pgwide) else '0'"/>
        <xsl:attribute name="rowheader" select="if ($prmTable/@rowheader) then string($prmTable/@rowheader) else 'norowheader'"/>
        <xsl:attribute name="scale"  select="if ($prmTable/@scale)  then string($prmTable/@scale) else '100'"/>
        <xsl:copy-of select="$prmTable/@class"/>
    </dummy>
</xsl:function>

<!-- 
 function:	table/desc template
 param:	    prmTopicRef, prmNeedId
 return:	fo:block
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/desc ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsTableDesc')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
</xsl:template>

<!-- 
 function:	table/title template
 param:	    prmTopicRef, prmNeedId
 return:	fo:block
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ')]" priority="2">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <xsl:variable name="tableTitlePrefix" select="ahf:getTableTitlePrefix($prmTopicRef,parent::*[1])"/>
    
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsTableTitle')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:value-of select="$tableTitlePrefix"/>
        <xsl:text>&#x00A0;</xsl:text>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
</xsl:template>



<!-- 
 function:	tgroup template
 param:	    prmTopicRef, prmNeedId, prmTableAttr
 return:	fo:table
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/tgroup ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmTableAttr" required="yes" as="element()"/>

    <xsl:variable name="tgroupAttr" select="ahf:addTgroupAttr(.,$prmTableAttr)" as="element()"/>
    <xsl:variable name="colSpec" as="element()*">
        <xsl:apply-templates select="child::*[contains(@class, ' topic/colspec ')]">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            <xsl:with-param name="prmTgroupAttr" select="$tgroupAttr"/>
        </xsl:apply-templates>
    </xsl:variable>
    <xsl:if test="$tgroupAttr/@pgwide='1'">
        <xsl:text disable-output-escaping="yes">&lt;fo:block start-indent="0mm" end-indent="0mm"&gt;</xsl:text>
    </xsl:if>
    <fo:table>
        <xsl:copy-of select="ahf:getAttributeSet('atsTable')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:copy-of select="ahf:getScaleAtts($tgroupAttr,'atsTable')"/>
        <xsl:copy-of select="ahf:getFrameAtts($tgroupAttr)"/>
        <!-- Copy fo:table-column -->
        <xsl:apply-templates select="$colSpec" mode="COPY_COLSPEC"/>
        <xsl:apply-templates select="*[contains(@class, ' topic/thead ')]">
            <xsl:with-param name="prmTopicRef"   select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"     select="$prmNeedId"/>
            <xsl:with-param name="prmTgroupAttr" select="$tgroupAttr"/>
            <xsl:with-param name="prmColSpec"    select="$colSpec"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="*[contains(@class, ' topic/tbody ')]">
            <xsl:with-param name="prmTopicRef"   select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"     select="$prmNeedId"/>
            <xsl:with-param name="prmTgroupAttr" select="$tgroupAttr"/>
            <xsl:with-param name="prmColSpec"    select="$colSpec"/>
        </xsl:apply-templates>
    </fo:table>
    <xsl:if test="$tgroupAttr/@pgwide='1'">
        <xsl:text disable-output-escaping="yes">&lt;/fo:block&gt;</xsl:text>
    </xsl:if>
</xsl:template>

<!-- 
 function:	build tgroup attributes
 param:		prmTgroup, prmTableAttr
 return:	element()
 note:		
 -->
<xsl:function name="ahf:addTgroupAttr" as="element()">
    <xsl:param name="prmTgroup"    as="element()"/>
    <xsl:param name="prmTableAttr" as="element()"/>
    <dummy>
        <xsl:copy-of select="$prmTableAttr/@*"/>
        <xsl:attribute name="cols" select="string($prmTgroup/@cols)"/>
        <xsl:if test="$prmTgroup/@colsep">
            <xsl:attribute name="colsep" select="string($prmTgroup/@colsep)"/>
        </xsl:if>
        <xsl:if test="$prmTgroup/@rowsep">
            <xsl:attribute name="rowsep" select="string($prmTgroup/@rowsep)"/>
        </xsl:if>
    </dummy>
</xsl:function>

<!-- 
 function:	fo:table-column copy template
 param:		none
 return:	fo:table-column
 note:		
 -->
<xsl:template match="fo:table-column" mode="COPY_COLSPEC">
    <xsl:copy>
        <xsl:copy-of select="@*[name()!='ahf:column-name']"/>
    </xsl:copy>
</xsl:template>

<!-- 
 function:	colspec template
 param:	    prmTopicRef, prmNeedId, prmTgroupAttr
 return:	fo:table-column
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/colspec ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmTgroupAttr" required="yes" as="element()"/>

    <fo:table-column>
        <xsl:copy-of select="ahf:getColSpecAttr(.)"/>
        <xsl:copy-of select="ahf:getLocalizationAtts(.)"/>
        <xsl:copy-of select="ahf:getIdAtts(.,$prmTopicRef,$prmNeedId)"/>
    </fo:table-column>
</xsl:template>

<!-- 
 function:	build colspec attributes
 param:		prmColSpec
 return:	attribute()*
 note:		Generates XSL-FO property.
 -->
<xsl:function name="ahf:getColSpecAttr" as="attribute()*">
    <xsl:param name="prmColSpec"    as="element()"/>

    <!-- colname (Not defined in XSL-FO)-->
    <xsl:if test="$prmColSpec/@colname">
        <xsl:attribute name="ahf:column-name" select="$prmColSpec/@colname"/>
    </xsl:if>

    <!-- colnum -->
    <xsl:choose>
        <xsl:when test="$prmColSpec/@colnum">
            <xsl:attribute name="column-number" select="$prmColSpec/@colnum"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:attribute name="column-number" select="string(count($prmColSpec/preceding-sibling::*[contains(@class,' topic/colspec ')])+1)"/>
        </xsl:otherwise>
    </xsl:choose>

    <!-- colwidth -->
    <xsl:if test="$prmColSpec/@colwidth">
        <xsl:variable name="colWidth">
            <xsl:call-template name="calc.column.width">
                <xsl:with-param name="colwidth" select="$prmColSpec/@colwidth"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:attribute name="column-width" select="string($colWidth)"/>
    </xsl:if>
    
    <!-- colsep -->
    <xsl:if test="$prmColSpec/@colsep">
        <xsl:variable name="colsep" select="$prmColSpec/@colsep"/>
        <xsl:choose>
            <xsl:when test="$colsep='0'">
                <xsl:attribute name="border-end-style" select="'none'"/>
            </xsl:when>
            <xsl:when test="$colsep='1'">
                <xsl:attribute name="border-end-style" select="'solid'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:if>

    <!-- rowsep -->
    <xsl:if test="$prmColSpec/@rowsep">
        <xsl:variable name="rowsep" select="$prmColSpec/@rowsep"/>
        <xsl:choose>
            <xsl:when test="$rowsep='0'">
                <xsl:attribute name="border-after-style" select="'none'"/>
            </xsl:when>
            <xsl:when test="$rowsep='1'">
                <xsl:attribute name="border-after-style" select="'solid'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:if>
    
    <!-- align -->
    <xsl:if test="$prmColSpec/@align">
        <xsl:variable name="align" select="string($prmColSpec/@align)"/>
        <xsl:choose>
            <xsl:when test="$align='char'">
                <xsl:variable name="char" select="string($prmColSpec/@char)"/>
                <!--xsl:variable name="charoff" select="string($prmColSpec/@charoff)"/-->
                <xsl:choose>
                    <xsl:when test="string($char)">
                        <xsl:attribute name="text-align" select="$char"/>
                        <!--xsl:if test="string($charoff)">
                            <xsl:attribute name="start-indent" select="concat($charoff,'%')"/>
                        </xsl:if-->
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="text-align" select="$align"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
    
</xsl:function>

<!-- 
 function:	thead template
 param:		prmTopicRef, prmNeedId, prmTgroupAttr, prmColSpec
 return:	fo:table-header
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/thead ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmTgroupAttr" required="yes"  as="element()"/>
    <xsl:param name="prmColSpec" required="yes" as="element()*"/>

    <xsl:variable name="theadAttr" select="ahf:addTheadAttr(.,$prmTgroupAttr)" as="element()"/>
    <fo:table-header>
        <xsl:copy-of select="ahf:getAttributeSet('atsThead')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates select="*[contains(@class, ' topic/row ')]">
            <xsl:with-param name="prmTopicRef"   select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"     select="$prmNeedId"/>
            <xsl:with-param name="prmRowUpperAttr"   select="$theadAttr"/>
            <xsl:with-param name="prmColSpec"    select="$prmColSpec"/>
        </xsl:apply-templates>
    </fo:table-header>
</xsl:template>

<!-- 
 function:	build thead attributes
 param:		prmThead, prmTgroupAttr
 return:	element()
 note:		
 -->
<xsl:function name="ahf:addTheadAttr" as="element()">
    <xsl:param name="prmThead"    as="element()"/>
    <xsl:param name="prmTgroupAttr" as="element()"/>
    <dummy>
        <xsl:copy-of select="$prmTgroupAttr/@*"/>
        <xsl:if test="$prmThead/@valign">
            <xsl:attribute name="valign" select="string($prmThead/@valign)"/>
        </xsl:if>
    </dummy>
</xsl:function>


<!-- 
 function:	tbody template
 param:		prmTopicRef, prmNeedId, prmTgroupAttr, prmColSpec
 return:	fo:table-body
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/tbody ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmTgroupAttr" required="yes" as="element()"/>
    <xsl:param name="prmColSpec" required="yes" as="element()*"/>

    <xsl:variable name="tbodyAttr" select="ahf:addTbodyAttr(.,$prmTgroupAttr)" as="element()"/>
    <fo:table-body>
        <xsl:copy-of select="ahf:getAttributeSet('atsTbody')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates select="*[contains(@class, ' topic/row ')]">
            <xsl:with-param name="prmTopicRef"   select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"     select="$prmNeedId"/>
            <xsl:with-param name="prmRowUpperAttr" select="$tbodyAttr"/>
            <xsl:with-param name="prmColSpec"    select="$prmColSpec"/>
        </xsl:apply-templates>
    </fo:table-body>
</xsl:template>

<!-- 
 function:	build tbody attributes
 param:		prmTbody, prmTgroupAttr
 return:	element()
 note:		
 -->
<xsl:function name="ahf:addTbodyAttr" as="element()">
    <xsl:param name="prmTbody"    as="element()"/>
    <xsl:param name="prmTgroupAttr" as="element()"/>
    <dummy>
        <xsl:copy-of select="$prmTgroupAttr/@*"/>
        <xsl:if test="$prmTbody/@valign">
            <xsl:attribute name="valign" select="string($prmTbody/@valign)"/>
        </xsl:if>
    </dummy>
</xsl:function>

<!-- 
 function:	row template
 param:		prmTopicRef, prmNeedId, prmRowUpperAttr, prmColSpec
 return:	fo:table-row
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/row ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmRowUpperAttr" required="yes" as="element()"/>
    <xsl:param name="prmColSpec" required="yes" as="element()*"/>

    <xsl:variable name="rowAttr" select="ahf:addRowAttr(.,$prmRowUpperAttr)" as="element()"/>
    <fo:table-row>
        <xsl:copy-of select="ahf:getAttributeSet('atsRow')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates select="*[contains(@class, ' topic/entry ')]">
            <xsl:with-param name="prmTopicRef"   select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"     select="$prmNeedId"/>
            <xsl:with-param name="prmRowAttr"    select="$rowAttr"/>
            <xsl:with-param name="prmColSpec"    select="$prmColSpec"/>
        </xsl:apply-templates>
    </fo:table-row>
</xsl:template>

<!-- 
 function:	build row attributes
 param:		prmRow, prmRowUpperAttr
 return:	element()
 note:		
 -->
<xsl:function name="ahf:addRowAttr" as="element()">
    <xsl:param name="prmRow"    as="element()"/>
    <xsl:param name="prmRowUpperAttr" as="element()"/>
    <dummy>
        <xsl:copy-of select="$prmRowUpperAttr/@*"/>
        <xsl:if test="$prmRow/@rowsep">
            <xsl:attribute name="rowsep" select="string($prmRow/@rowsep)"/>
        </xsl:if>
        <xsl:if test="$prmRow/@valign">
            <xsl:attribute name="valign" select="string($prmRow/@valign)"/>
        </xsl:if>
    </dummy>
</xsl:function>

<!-- 
 function:	entry template
 param:		prmTopicRef, prmNeedId, prmRowAttr, prmColSpec
 return:	fo:table-cell
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/entry ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmRowAttr" required="yes" as="element()"/>
    <xsl:param name="prmColSpec" required="yes" as="element()*"/>

    <xsl:variable name="entryAttr" select="ahf:addEntryAttr(.,$prmRowAttr)" as="element()"/>
    <xsl:variable name="colname" select="string($entryAttr/@colname)"/>
    <xsl:variable name="atsName" select="if (ancestor::*[contains(@class,' topic/thead ')]) then 'atsTableHeaderCell' else 'atsTableBodyCell'"/>
    <fo:table-cell>
        <xsl:copy-of select="ahf:getAttributeSet($atsName)"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:copy-of select="ahf:getEntryAttr(.,$entryAttr,$prmColSpec)"/>
        <xsl:copy-of select="ahf:getColSpecAttr($colname,$prmColSpec)"/>
        <fo:block>
            <xsl:apply-templates>
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            </xsl:apply-templates>
        </fo:block>
    </fo:table-cell>
</xsl:template>


<!-- 
 function:	build entry attributes
 param:		prmEntry, prmRowAttr
 return:	element()
 note:		
 -->
<xsl:function name="ahf:addEntryAttr" as="element()">
    <xsl:param name="prmEntry"    as="element()"/>
    <xsl:param name="prmRowAttr"  as="element()"/>
    <dummy>
        <xsl:copy-of select="$prmRowAttr/@*"/>
        <xsl:if test="$prmEntry/@colname">
            <xsl:attribute name="colname" select="string($prmEntry/@colname)"/>
        </xsl:if>
        <xsl:if test="$prmEntry/@namest">
            <xsl:attribute name="namest" select="string($prmEntry/@namest)"/>
        </xsl:if>
        <xsl:if test="$prmEntry/@nameend">
            <xsl:attribute name="nameend" select="string($prmEntry/@nameend)"/>
        </xsl:if>
        <xsl:if test="$prmEntry/@morerows">
            <xsl:attribute name="morerows" select="string($prmEntry/@morerows)"/>
        </xsl:if>
        <xsl:if test="$prmEntry/@colsep">
            <xsl:attribute name="colsep" select="string($prmEntry/@colsep)"/>
        </xsl:if>
        <xsl:if test="$prmEntry/@rowsep">
            <xsl:attribute name="rowsep" select="string($prmEntry/@rowsep)"/>
        </xsl:if>
        <xsl:if test="$prmEntry/@align">
            <xsl:attribute name="align" select="string($prmEntry/@align)"/>
        </xsl:if>
        <xsl:if test="$prmEntry/@char">
            <xsl:attribute name="char" select="string($prmEntry/@char)"/>
        </xsl:if>
        <!--xsl:if test="$prmEntry/@charoff">
            <xsl:attribute name="charoff" select="string($prmEntry/@charoff)"/>
        </xsl:if-->
        <xsl:if test="$prmEntry/@valign">
            <xsl:attribute name="valign" select="string($prmEntry/@valign)"/>
        </xsl:if>
    </dummy>
</xsl:function>

<!-- 
 function:	get XSL-FO property from CALS table entry attributes
 param:		prmEntry, prmEntryAttr, prmColSpec
 return:	attribute()*
 note:		DITA-OT 1.5 sets correct @colname to every entry element.
            This stylesheet use this functionality.
 -->
<xsl:function name="ahf:getEntryAttr" as="attribute()*">
    <xsl:param name="prmEntry"        as="element()"/>
    <xsl:param name="prmEntryAttr"    as="element()"/>
    <xsl:param name="prmColSpec"      as="element()*"/>
    
    <xsl:variable name="colname" select="string($prmEntryAttr/@colname)"/>
    
    <!-- colsep -->
    <xsl:choose>
        <xsl:when test="$prmEntryAttr/@colsep='0'">
            <xsl:attribute name="border-end-style" select="'none'"/>
        </xsl:when>
        <xsl:when test="$prmEntryAttr/@colsep='1'">
            <xsl:attribute name="border-end-style" select="'solid'"/>
        </xsl:when>
    </xsl:choose>
    
    <!-- rowsep -->
    <xsl:choose>
        <xsl:when test="$prmEntryAttr/@rowsep='0'">
            <xsl:attribute name="border-after-style" select="'none'"/>
        </xsl:when>
        <xsl:when test="$prmEntryAttr/@rowsep='1'">
            <xsl:attribute name="border-after-style" select="'solid'"/>
        </xsl:when>
    </xsl:choose>
    
    <!-- rowheader -->
    <xsl:if test="($prmEntryAttr/@rowheader='firstcol') and ($colname='col1')">
        <xsl:sequence select="ahf:getAttributeSet('atsHeaderRow')"/>
    </xsl:if>
    
    <!-- align -->
    <xsl:if test="$prmEntryAttr/@align">
        <xsl:variable name="align" select="string($prmEntryAttr/@align)"/>
        <xsl:choose>
            <xsl:when test="$align='char'">
                <xsl:variable name="char" select="string($prmEntryAttr/@char)"/>
                <!--xsl:variable name="charoff" select="string($prmEntryAttr/@charoff)"/-->
                <xsl:choose>
                    <xsl:when test="string($char)">
                        <xsl:attribute name="text-align" select="$char"/>
                        <!--xsl:if test="string($charoff)">
                            <xsl:attribute name="start-indent" select="concat($charoff,'%')"/>
                        </xsl:if-->
                    </xsl:when>
                    <xsl:otherwise/>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="text-align" select="$align"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
    
    <!-- valign -->
    <xsl:if test="$prmEntryAttr/@valign">
        <xsl:variable name="valign" select="$prmEntryAttr/@valign"/>
        <xsl:choose>
            <xsl:when test="$valign='top'">
                <xsl:attribute name="display-align" select="'before'"/>
            </xsl:when>
            <xsl:when test="$valign='bottom'">
                <xsl:attribute name="display-align" select="'after'"/>
            </xsl:when>
            <xsl:when test="$valign='middle'">
                <xsl:attribute name="display-align" select="'center'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:if>
    
    <!-- namest,nameend -->
    <xsl:if test="($prmEntryAttr/@namest) and ($prmEntryAttr/@nameend)">
        <xsl:variable name="startpos" select="$prmColSpec[@ahf:column-name=$prmEntryAttr/@namest]/@column-number"/>
        <xsl:variable name="endpos"   select="$prmColSpec[@ahf:column-name=$prmEntryAttr/@nameend]/@column-number"/>
        <xsl:variable name="spancolumns" select="$endpos - $startpos + 1"/>
        <xsl:attribute name="number-columns-spanned" select="string($spancolumns)"/>
    </xsl:if>

    <!-- morerows -->
    <xsl:if test="$prmEntryAttr/@morerows">
        <xsl:attribute name="number-rows-spanned" select="string(xs:integer($prmEntryAttr/@morerows) + 1)"/>
    </xsl:if>
    
</xsl:function>

<!-- 
 function:	inherit colspec property to table entry
 param:		prmColName, prmColSpec
 return:	attribute()*
 note:		DITA-OT 1.5 sets correct @colname to every entry element.
            This stylesheet use this functionality.
 -->
<xsl:function name="ahf:getColSpecAttr" as="attribute()*">
    <xsl:param name="prmColName"  as="xs:string"/>
    <xsl:param name="prmColSpec"  as="element()*"/>

    <xsl:variable name="colSpec" select="$prmColSpec[@ahf:column-name=$prmColName][1]"/>
    
    <xsl:if test="$colSpec">
        <xsl:if test="$colSpec/@border-end-style">
            <xsl:attribute name="border-end-style" select="'from-table-column()'"/>
        </xsl:if>
    
        <xsl:if test="$colSpec/@border-after-style">
            <xsl:attribute name="border-after-style" select="'from-table-column()'"/>
        </xsl:if>
    
        <xsl:if test="$colSpec/@text-align">
            <xsl:attribute name="text-align" select="'from-table-column()'"/>
        </xsl:if>

        <!-- Does not support charoff -->
        <!--xsl:if test="$colSpec/@start-indent">
            <xsl:attribute name="start-indent" select="'from-table-column()'"/>
        </xsl:if-->
    </xsl:if>
</xsl:function>


<!-- **************************** 
        Simple Table Templates
     ****************************-->
<!-- 
 function:	simpletable template
 param:	    prmTopicRef, prmNeedId
 return:	fo:table
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/simpletable ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <xsl:variable name="keyCol" select="ahf:getKeyCol(.)" as="xs:integer"/>
    <xsl:if test="@expanse='page' or @expanse='column'">
        <xsl:text disable-output-escaping="yes">&lt;fo:block start-indent="0mm" end-indent="0mm"&gt;</xsl:text>
    </xsl:if>
    <fo:table>
        <xsl:copy-of select="ahf:getAttributeSet('atsSimpleTable')"/>
        <xsl:copy-of select="ahf:getDisplayAtts(.,'atsSimpleTable')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:if test="@relcolwidth">
            <xsl:copy-of select="ahf:getAttributeSet('atsSimpleTableFixed')"/>
            <xsl:call-template name="processRelColWidth">
                <xsl:with-param name="prmRelColWidth" select="string(@relcolwidth)"/>
                <xsl:with-param name="prmTable" select="."/>
            </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates select="*[contains(@class,' topic/sthead ')]">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            <xsl:with-param name="prmKeyCol"   select="$keyCol"/>
        </xsl:apply-templates>
        <fo:table-body>
            <xsl:copy-of select="ahf:getAttributeSet('atsSimpleTableBody')"/>
            <xsl:apply-templates select="*[contains(@class,' topic/strow ')]">
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                <xsl:with-param name="prmKeyCol"   select="$keyCol"/>
            </xsl:apply-templates>
        </fo:table-body>
    </fo:table>
    <xsl:if test="@expanse='page' or @expanse='column'">
        <xsl:text disable-output-escaping="yes">&lt;/fo:block&gt;</xsl:text>
    </xsl:if>
</xsl:template>

<!-- 
 function:	sthead template
 param:	    prmTopicRef, prmNeedId, prmKeyCol
 return:	fo:table-header
 note:		sthead is optional.
            This stylesheet apply bold for sthead if simpletable/@keycol is not defined.
 -->
<xsl:template match="*[contains(@class, ' topic/sthead ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmKeyCol"  required="yes" as="xs:integer"/>
    
    <fo:table-header>
        <xsl:copy-of select="ahf:getAttributeSet('atsSimpleTableHeader')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <fo:table-row>
            <xsl:copy-of select="ahf:getAttributeSet('atsSimpleTableRow')"/>
            <xsl:apply-templates>
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                <xsl:with-param name="prmKeyCol"   select="$prmKeyCol"/>
            </xsl:apply-templates>
        </fo:table-row>
    </fo:table-header>
</xsl:template>

<!-- 
 function:	stentry template
 param:	    prmTopicRef, prmNeedId, prmKeyCol
 return:	stentry contents (fo:table-cell)
 note:		none
 -->
<xsl:template match="*[contains(@class, ' topic/sthead ')]/*[contains(@class, ' topic/stentry ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmKeyCol"   required="yes"  as="xs:integer"/>
    <fo:table-cell>
        <xsl:copy-of select="ahf:getAttributeSet('atsSimpleTableHeaderCell')"/>
        <xsl:choose>
            <xsl:when test="$prmKeyCol = count(preceding-sibling::*[contains(@class, ' topic/stentry ')])+1">
                <xsl:copy-of select="ahf:getAttributeSet('atsPropertyTableKeyCol')"/>
            </xsl:when>
            <xsl:when test="$prmKeyCol != 0">
                <xsl:copy-of select="ahf:getAttributeSet('atsPropertyTableNoKeyCol')"/>
            </xsl:when>
        </xsl:choose>
        <fo:block>
            <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
            <xsl:apply-templates>
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            </xsl:apply-templates>
        </fo:block>
    </fo:table-cell>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/strow ')]/*[contains(@class, ' topic/stentry ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmKeyCol"   required="yes"  as="xs:integer"/>
    <fo:table-cell>
        <xsl:copy-of select="ahf:getAttributeSet('atsSimpleTableBodyCell')"/>
        <xsl:choose>
            <xsl:when test="$prmKeyCol = count(preceding-sibling::*[contains(@class, ' topic/stentry ')])+1">
                <xsl:copy-of select="ahf:getAttributeSet('atsPropertyTableKeyCol')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="ahf:getAttributeSet('atsPropertyTableNoKeyCol')"/>
            </xsl:otherwise>
        </xsl:choose>
        <fo:block>
            <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
            <xsl:apply-templates>
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            </xsl:apply-templates>
        </fo:block>
    </fo:table-cell>
</xsl:template>


<!-- 
 function:	strow template
 param:	    prmTopicRef, prmNeedId, prmKeyCol
 return:	fo:table-row
 note:		none
 -->
<xsl:template match="*[contains(@class, ' topic/strow ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmKeyCol"   required="yes"  as="xs:integer"/>
    
    <fo:table-row>
        <xsl:copy-of select="ahf:getAttributeSet('atsSimpleTableRow')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            <xsl:with-param name="prmKeyCol"   select="$prmKeyCol"/>
        </xsl:apply-templates>
    </fo:table-row>
</xsl:template>


<!-- *************************************** 
        Table related common templates
     ***************************************-->
<!-- 
 function:	get @keycol value and return it.
 param:		prmTable
 return:	integer
 note:		
 -->
<xsl:function name="ahf:getKeyCol" as="xs:integer">
    <xsl:param name="prmTable" as="element()"/>
    
    <xsl:variable name="keyCol" select="if ($prmTable/@keycol) then string($prmTable/@keycol) else '0'" as="xs:string"/>
    <xsl:choose>
        <xsl:when test="$keyCol castable as xs:integer">
            <xsl:choose>
                <xsl:when test="xs:integer($keyCol) &gt;= 0">
                    <xsl:sequence select="xs:integer($keyCol)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="warningContinue">
                        <xsl:with-param name="prmMes" 
                        select="ahf:replace($stMes050,('%file','%elem','%keycol'),($prmTable/@xtrf,name($prmTable),$prmTable/@keycol))"/>
                    </xsl:call-template>
                    <xsl:sequence select="0"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="warningContinue">
                <xsl:with-param name="prmMes" 
                select="ahf:replace($stMes050,('%file','%elem','%keycol'),($prmTable/@xtrf,name($prmTable),$prmTable/@keycol))"/>
            </xsl:call-template>
            <xsl:sequence select="0"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<!-- 
 function:	@relcolwidth processing
 param:		prmRelColWidth, prmTable
 return:	fo:table-column
 note:		
 -->
<xsl:template name="processRelColWidth">
    <xsl:param name="prmRelColWidth" required="yes" as="xs:string"/>
    <xsl:param name="prmTable"  required="yes" as="element()"/>
    
    <xsl:for-each select="tokenize(string($prmRelColWidth), '[\s]+')">
        <xsl:variable name="relColWidth"  select="string(.)"/>
        <xsl:variable name="relColNumber" select="position()"/>
        <fo:table-column>
            <xsl:attribute name="column-number">
                <xsl:value-of select="$relColNumber"/>
            </xsl:attribute>
            <xsl:attribute name="column-width">
                <!-- Get column width format string in XSL-FO -->
                <xsl:call-template name="calc.column.width">
                    <xsl:with-param name="colwidth" select="$relColWidth"/>
                </xsl:call-template>
            </xsl:attribute>
        </fo:table-column>
    </xsl:for-each>
</xsl:template>


<!-- 
 function:	Calculate column width template
 param:		colwidth
 return:	column width attribute value
 note:		This template is from W3C XSL specification.
 -->
<xsl:template name="calc.column.width">
    <xsl:param name="colwidth">1*</xsl:param>
    <!-- Ok, the colwidth could have any one of the following forms: -->
    <!--        1*       = proportional width -->
    <!--     1unit       = 1.0 units wide -->
    <!--         1       = 1pt wide -->
    <!--  1*+1unit       = proportional width + some fixed width -->
    <!--      1*+1       = proportional width + some fixed width -->
    <!-- If it has a proportional width, translate it to XSL -->
    <xsl:if test="contains($colwidth, '*')">
      <!-- modified to handle "*" as input -->
      <xsl:variable name="colfactor">
        <xsl:value-of select="substring-before($colwidth, '*')"/>
      </xsl:variable>
      <xsl:text>proportional-column-width(</xsl:text>
      <xsl:choose>
        <xsl:when test="not($colfactor = '')">
          <xsl:value-of select="$colfactor"/>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
      <xsl:text>)</xsl:text>
    </xsl:if>
    <!-- Now get the non-proportional part of the specification -->
    <xsl:variable name="width-units">
      <xsl:choose>
        <xsl:when test="contains($colwidth, '*')">
          <xsl:value-of select="normalize-space(substring-after($colwidth, '*'))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($colwidth)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Now the width-units could have any one of the following forms: -->
    <!--                 = <empty string> -->
    <!--     1unit       = 1.0 units wide -->
    <!--         1       = 1pt wide -->
    <!-- with an optional leading sign -->
    <!-- Get the width part by blanking out the units part and discarding -->
    <!-- white space. -->
    <xsl:variable name="width" select="normalize-space(translate($width-units,                           '+-0123456789.abcdefghijklmnopqrstuvwxyz',                           '+-0123456789.'))"/>
    <!-- Get the units part by blanking out the width part and discarding -->
    <!-- white space. -->
    <xsl:variable name="units" select="normalize-space(translate($width-units,                           'abcdefghijklmnopqrstuvwxyz+-0123456789.',                           'abcdefghijklmnopqrstuvwxyz'))"/>
    <!-- Output the width -->
    <xsl:value-of select="$width"/>
    <!-- Output the units, translated appropriately -->
    <xsl:choose>
      <xsl:when test="$units = 'pi'">pc</xsl:when>
      <xsl:when test="$units = '' and $width != ''">pt</xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$units"/>
      </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	Generate table title prefix
 param:		prmTopicRef, prmTable
 return:	Table title prefix
 note:		
 -->
<xsl:function name="ahf:getTableTitlePrefix" as="xs:string">
    <xsl:param name="prmTopicRef" as="element()"/>
    <xsl:param name="prmTable" as="element()"/>

    <xsl:variable name="titlePrefix" as="xs:string">
        <xsl:choose>
            <xsl:when test="$pAddNumberingTitlePrefix">
                <xsl:variable name="tempTitlePrefix" select="ahf:genNumberingPrefix($prmTopicRef,$cTableGroupingLevelMax)"/>
                <xsl:choose>
                    <xsl:when test="ends-with($tempTitlePrefix, $cTitlePrefixSeparator)">
                        <xsl:sequence select="concat(substring($tempTitlePrefix, 1, string-length($tempTitlePrefix)-1), $cTitleSeparator)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="concat($tempTitlePrefix, $cTitleSeparator)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="topicNode" select="$prmTable/ancestor::*[contains(@class, ' topic/topic ')][position()=last()]"/>

    <xsl:variable name="tablePreviousAmount" as="xs:integer">
        <xsl:variable name="topicNodeId" select="ahf:generateIdByTopicRef(string($topicNode/@id),$prmTopicRef)"/>
        <xsl:sequence select="$tableNumberingMap/*[@id=$topicNodeId]/@count"/>
    </xsl:variable>

    <xsl:variable name="tableCurrentAmount"  as="xs:integer">
        <xsl:number select="$prmTable"
                    level="any"
                    count="*[contains(@class,' topic/table ')]"
                    from="*[contains(@class, ' topic/topic ')][generate-id(parent::*)=$rootId]"/>
    </xsl:variable>

    <xsl:variable name="tableNumber" select="$tablePreviousAmount + $tableCurrentAmount" as="xs:integer"/>

    <xsl:sequence select="concat($cTableTitle,$titlePrefix,string($tableNumber))"/>
</xsl:function>

</xsl:stylesheet>