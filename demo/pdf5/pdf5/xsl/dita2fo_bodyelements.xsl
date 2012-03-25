<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet 
Module: Body elements stylesheet
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
 function:	p template
 param:	    prmTopicRef,prmNeedId
 return:	fo:block with p's contents
 note:		none
 -->
<xsl:template match="*[contains(@class, ' topic/p ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsP')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
</xsl:template>

<!-- 
 function:	note template
 param:	    prmTopicRef,prmNeedId
 return:	fo:block 
 note:		none
 -->
<xsl:variable name="noteIconObject" select="ahf:getInstreamObject('Note_Icon')"/>
<xsl:variable name="tipIconObject" select="ahf:getInstreamObject('Tip_Icon')"/>
<xsl:variable name="fastPathIconObject" select="ahf:getInstreamObject('FastPath_Icon')"/>
<xsl:variable name="restrictionIconObject" select="ahf:getInstreamObject('Restriction_Icon')"/>
<xsl:variable name="importantIconObject" select="ahf:getInstreamObject('Important_Icon')"/>
<xsl:variable name="rememberIconObject" select="ahf:getInstreamObject('Remember_Icon')"/>
<xsl:variable name="attentionText" select="ahf:getVarValue('Note_Attention')"/>
<xsl:variable name="cautionText" select="ahf:getVarValue('Note_Caution')"/>
<xsl:variable name="dangerText" select="ahf:getVarValue('Note_Danger')"/>
<xsl:variable name="otherText" select="ahf:getVarValue('Note_Other')"/>
<xsl:variable name="attentionIconObject" select="ahf:getInstreamObjectTextReplace('Caution_Icon','@Caution',$attentionText)"/>
<xsl:variable name="cautionIconObject" select="ahf:getInstreamObjectTextReplace('Caution_Icon','@Caution',$cautionText)"/>
<xsl:variable name="dangerIconObject" select="ahf:getInstreamObjectTextReplace('Caution_Icon','@Caution',$dangerText)"/>

<xsl:template match="*[contains(@class, ' topic/note ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsNoteIcon')"/>
        <xsl:choose>
            <xsl:when test="@type='note'">
                <fo:instream-foreign-object>
                    <xsl:copy-of select="$noteIconObject"/>
                </fo:instream-foreign-object>
            </xsl:when>
            <xsl:when test="@type='tip'">
                <fo:instream-foreign-object>
                    <xsl:copy-of select="$tipIconObject"/>
                </fo:instream-foreign-object>
            </xsl:when>
            <xsl:when test="@type='fastpath'">
                <fo:instream-foreign-object>
                    <xsl:copy-of select="$fastPathIconObject"/>
                </fo:instream-foreign-object>
            </xsl:when>
            <xsl:when test="@type='restriction'">
                <fo:instream-foreign-object>
                    <xsl:copy-of select="$restrictionIconObject"/>
                </fo:instream-foreign-object>
            </xsl:when>
            <xsl:when test="@type='important'">
                <fo:instream-foreign-object>
                    <xsl:copy-of select="$importantIconObject"/>
                </fo:instream-foreign-object>
            </xsl:when>
            <xsl:when test="@type='remember'">
                <fo:instream-foreign-object>
                    <xsl:copy-of select="$rememberIconObject"/>
                </fo:instream-foreign-object>
            </xsl:when>
            <xsl:when test="@type='attention'">
                <fo:instream-foreign-object>
                    <xsl:copy-of select="$attentionIconObject"/>
                </fo:instream-foreign-object>
            </xsl:when>
            <xsl:when test="@type='caution'">
                <fo:instream-foreign-object>
                    <xsl:copy-of select="$cautionIconObject"/>
                </fo:instream-foreign-object>
            </xsl:when>
            <xsl:when test="@type='danger'">
                <fo:instream-foreign-object>
                    <xsl:copy-of select="$dangerIconObject"/>
                </fo:instream-foreign-object>
            </xsl:when>
            <xsl:when test="@type='other'">
                <xsl:variable name="otherType" select="if (@othertype) then (string(@othertype)) else ($otherText)"/>
                <fo:instream-foreign-object>
                    <xsl:copy-of select="ahf:getInstreamObjectTextReplace('Other_Icon','@Other',$otherType)"/>
                </fo:instream-foreign-object>
            </xsl:when>
        </xsl:choose>
    </fo:block>
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsNote')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsNoteAfterBlock')"/>
        <xsl:value-of select="'&#x00A0;'"/>
    </fo:block>
</xsl:template>



<!-- 
 function:	ph template
 param:	    prmTopicRef,prmNeedId
 return:	fo:inline
 note:		no special formatting
 -->
<xsl:template match="*[contains(@class, ' topic/ph ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <fo:inline>
        <xsl:copy-of select="ahf:getAttributeSet('atsPh')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:inline>
</xsl:template>

<!-- 
 function:	keyword template
 param:	    prmTopicRef,prmNeedId
 return:	fo:inline
 note:		no special formatting
 -->
<xsl:template match="*[contains(@class, ' topic/keyword ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <fo:inline>
        <xsl:copy-of select="ahf:getAttributeSet('atsKeyword')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:inline>
</xsl:template>

<!-- 
     xref template is coded in dita2fo_xref.xsl
 -->


<!-- 
 function:	ol template
 param:	    prmTopicRef,prmNeedId
 return:	Numbered list (fo:list-block)
 note:		none
 -->
<xsl:variable name="liSpacingAttr" select="ahf:getVarValue('Li_Spacing_Attr')"/> 
 
<xsl:template match="*[contains(@class,' topic/ol ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:variable name="numberFormat" select="ahf:getOlNumberFormat(.)" as="xs:string"/>
    <fo:list-block>
        <xsl:copy-of select="ahf:getAttributeSet('atsOl')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            <xsl:with-param name="prmNumberFormat" select="$numberFormat"/>
        </xsl:apply-templates>
    </fo:list-block>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/ol ')]/*[contains(@class,' topic/li ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmNumberFormat" required="yes" as="xs:string"/>

    <fo:list-item>
        <!-- Set list-item attribute. -->
        <xsl:copy-of select="ahf:getAttributeSet('atsOlItem')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <!-- Discard first space-before -->
        <xsl:if test="not(preceding-sibling::*[contains(@class,' topic/li ')])">
            <xsl:attribute name="{$liSpacingAttr}" select="'0mm'"/>
        </xsl:if>
        <fo:list-item-label end-indent="label-end()"> 
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsOlLabel')"/>
                <xsl:number format="{$prmNumberFormat}"/>
            </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsP')"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:block>
        </fo:list-item-body>
    </fo:list-item>
</xsl:template>

<!-- 
 function:	Get ol number format
 param:		prmOl
 return:	Number format string
 note:		none
 -->
<xsl:function name="ahf:getOlNumberFormat" as="xs:string">
    <xsl:param name="prmOl" as="element()"/>
    
    <xsl:variable name="olNestLevel" select="ahf:countOl($prmOl,0)" as="xs:integer"/>
    
    <xsl:variable name="formatOrder" as="xs:integer">
        <xsl:choose>
            <xsl:when test="$olNumberFormatCount != 0">
                <xsl:variable name="olNumberFormatIndex" select="$olNestLevel mod $olNumberFormatCount"/>
                <xsl:sequence select="if ($olNumberFormatIndex=0) then $olNumberFormatCount else $olNumberFormatIndex"/>
            </xsl:when>
            <xsl:otherwise>
                <xs:sequence select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:sequence select="if ($formatOrder=0) then '1.' else $olNumberFormat[$formatOrder]"/>
    
</xsl:function>

<xsl:function name="ahf:countOl" as="xs:integer">
    <xsl:param name="prmElement" as="element()"/>
    <xsl:param name="prmCount" as="xs:integer"/>

    <xsl:variable name="count" select="if ($prmElement[contains(@class, ' topic/ol ')]) then ($prmCount+1) else $prmCount"/>
    <xsl:choose>
        <xsl:when test="$prmElement[contains(@class, ' topic/entry ')]">
            <xsl:sequence select="$count"/>
        </xsl:when>
        <xsl:when test="$prmElement/parent::*">
            <xsl:sequence select="ahf:countOl($prmElement/parent::*, $count)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:sequence select="$count"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>


<!-- 
 function:	ul template
 param:	    prmTopicRef,prmNeedId
 return:	Unordered list (fo:list-block)
 note:		none
 -->
<xsl:template match="*[contains(@class,' topic/ul ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:list-block>
        <xsl:copy-of select="ahf:getAttributeSet('atsUl')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:list-block>
</xsl:template>

<xsl:template match="*[contains(@class,' topic/ul ')]/*[contains(@class,' topic/li ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:list-item>
        <xsl:copy-of select="ahf:getAttributeSet('atsUlItem')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <!-- Discard first space-before -->
        <xsl:if test="not(preceding-sibling::*[contains(@class,' topic/li ')])">
            <xsl:attribute name="{$liSpacingAttr}" select="'0mm'"/>
        </xsl:if>
        <fo:list-item-label end-indent="label-end()"> 
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsUlLabel')"/>
                <xsl:value-of select="$cUlLabelChar"/>
            </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsP')"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:block>
        </fo:list-item-body>
    </fo:list-item>
</xsl:template>

<!-- 
 function:	sl template
 param:	    prmTopicRef,prmNeedId
 return:	fo:list-block
 note:		none
 -->
<xsl:template match="*[contains(@class,' topic/sl ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:variable name="doCompact" select="boolean(@compact='yes')" as="xs:boolean"/>
    <fo:list-block>
        <xsl:copy-of select="ahf:getAttributeSet('atsSl')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef"    select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"      select="$prmNeedId"/>
            <xsl:with-param name="prmDoCompact"   select="$doCompact"/>
        </xsl:apply-templates>
    </fo:list-block>
</xsl:template>

<xsl:variable name="slCompactRatio" select="xs:double(ahf:getVarValue('Sl_Compact_Ratio'))" as="xs:double"/>
<xsl:variable name="slCompactAttrName"  select="ahf:getVarValue('Sl_Compact_Attr')" as="xs:string"/>

<xsl:template match="*[contains(@class,' topic/sl ')]/*[contains(@class,' topic/sli ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmDoCompact" required="yes" as="xs:boolean"/>
    
    <xsl:variable name="compactAttrVal" select="ahf:getAttributeValue('atsSlItem',$slCompactAttrName)"/>
    
    <fo:list-item>
        <xsl:copy-of select="ahf:getAttributeSet('atsSlItem')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:choose>
            <!-- Discard first space-before -->
            <xsl:when test="not(preceding-sibling::*[contains(@class,' topic/sli ')])">
                <xsl:attribute name="{$liSpacingAttr}" select="'0mm'"/>
            </xsl:when>
            <!-- Apply compact spacing -->
            <xsl:when test="string($compactAttrVal) and $prmDoCompact">
                <xsl:attribute name="{$slCompactAttrName}" 
                               select="ahf:getPropertyRatio($compactAttrVal,$slCompactRatio)"/>
            </xsl:when>
        </xsl:choose>
        <fo:list-item-label end-indent="label-end()"> 
            <fo:block>
                <fo:inline/>
            </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
            <fo:block>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:block>
        </fo:list-item-body>
    </fo:list-item>
</xsl:template>

<!-- 
 function:	dl template
 param:	    prmTopicRef,prmNeedId
 return:	fo:table
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/dl ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:variable name="doCompact" select="boolean(@compact='yes')" as="xs:boolean"/>
    <xsl:choose>
        <xsl:when test="$pFormatDlAsBlock">
            <fo:wrapper>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates select="*[contains(@class, ' topic/dlhead ')]">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                    <xsl:with-param name="prmDoCompact" select="$doCompact"/>
                </xsl:apply-templates>
                <xsl:apply-templates select="*[contains(@class, ' topic/dlentry ')]">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                    <xsl:with-param name="prmDoCompact" select="$doCompact"/>
                </xsl:apply-templates>
            </fo:wrapper>
        </xsl:when>
        <xsl:otherwise>
            <fo:table>
                <xsl:copy-of select="ahf:getAttributeSet('atsDl')"/>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates select="*[contains(@class, ' topic/dlhead ')]">
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                    <xsl:with-param name="prmDoCompact" select="$doCompact"/>
                </xsl:apply-templates>
                <fo:table-body>
                    <xsl:copy-of select="ahf:getAttributeSet('atsDlbody')"/>
                    <xsl:apply-templates select="*[contains(@class, ' topic/dlentry ')]">
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                        <xsl:with-param name="prmDoCompact" select="$doCompact"/>
                    </xsl:apply-templates>
                </fo:table-body>
            </fo:table>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:variable name="dlCompactRatio" select="xs:double(ahf:getVarValue('Dl_Compact_Ratio'))" as="xs:double"/>
<xsl:variable name="dlCompactRatioBlockDt" select="xs:double(ahf:getVarValue('Dl_Compact_Ratio_Block_Dt'))" as="xs:double"/>
<xsl:variable name="dlCompactRatioBlockDd" select="xs:double(ahf:getVarValue('Dl_Compact_Ratio_Block_Dd'))" as="xs:double"/>
<xsl:variable name="dlCompactAttrName"  select="ahf:getVarValue('Dl_Compact_Attr')" as="xs:string"/>
<xsl:variable name="dlCompactAttrNameBlock"  select="ahf:getVarValue('Dl_Compact_Attr_Block')" as="xs:string"/>

<xsl:template match="*[contains(@class, ' topic/dlhead ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmDoCompact" required="yes" as="xs:boolean"/>

    <xsl:choose>
        <xsl:when test="$pFormatDlAsBlock">
            <xsl:call-template name="warningContinue">
                <xsl:with-param name="prmMes" 
                 select="ahf:replace($stMes055,('%file'),(@xtrf))"/>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <fo:table-header>
                <xsl:copy-of select="ahf:getAttributeSet('atsDlhead')"/>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <fo:table-row>
                    <xsl:apply-templates>
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                        <xsl:with-param name="prmDoCompact" select="$prmDoCompact"/>
                    </xsl:apply-templates>
                </fo:table-row>
            </fo:table-header>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/dthd ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmDoCompact" required="yes" as="xs:boolean"/>
    
    <xsl:variable name="compactAttrVal" select="ahf:getAttributeValue('atsDthd',$dlCompactAttrName)"/>
    <fo:table-cell>
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsDthd')"/>
            <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
            <xsl:if test="string($compactAttrVal) and $prmDoCompact">
                <xsl:attribute name="{$dlCompactAttrName}" 
                               select="ahf:getPropertyRatio($compactAttrVal,$dlCompactRatio)"/>
            </xsl:if>
            <xsl:apply-templates>
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            </xsl:apply-templates>
        </fo:block>
    </fo:table-cell>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/ddhd ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmDoCompact" required="yes" as="xs:boolean"/>
    
    <xsl:variable name="compactAttrVal" select="ahf:getAttributeValue('atsDdhd',$dlCompactAttrName)"/>
    <fo:table-cell>
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsDdhd')"/>
            <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
            <xsl:if test="string($compactAttrVal) and $prmDoCompact">
                <xsl:attribute name="{$dlCompactAttrName}" 
                               select="ahf:getPropertyRatio($compactAttrVal,$dlCompactRatio)"/>
            </xsl:if>
            <xsl:apply-templates>
                <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            </xsl:apply-templates>
        </fo:block>
    </fo:table-cell>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/dlentry ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmDoCompact" required="yes" as="xs:boolean"/>
    
    <xsl:choose>
        <xsl:when test="$pFormatDlAsBlock">
            <fo:wrapper>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                    <xsl:with-param name="prmDoCompact" select="$prmDoCompact"/>
                </xsl:apply-templates>
            </fo:wrapper>
        </xsl:when>
        <xsl:otherwise>
            <fo:table-row>
                <xsl:copy-of select="ahf:getAttributeSet('atsDlentry')"/>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                    <xsl:with-param name="prmDoCompact" select="$prmDoCompact"/>
                </xsl:apply-templates>
            </fo:table-row>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/dt ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmDoCompact" required="yes" as="xs:boolean"/>
    
    <xsl:choose>
        <xsl:when test="$pFormatDlAsBlock">
            <xsl:variable name="compactAttrValBlock" 
                          select="ahf:getAttributeValue('atsDtBlock',$dlCompactAttrNameBlock)"/>
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsDtBlock')"/>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:if test="string($compactAttrValBlock) and $prmDoCompact">
                    <xsl:attribute name="{$dlCompactAttrNameBlock}" 
                                   select="ahf:getPropertyRatio($compactAttrValBlock,$dlCompactRatioBlockDt)"/>
                </xsl:if>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="compactAttrVal" select="ahf:getAttributeValue('atsDt',$dlCompactAttrName)"/>
            <xsl:variable name="hasDlhead" select="boolean(ancestor::*[contains(@class,' topic/dl ')]/child::*[contains(@class,' topic/dlhead ')])"/>
            <fo:table-cell>
                <fo:block>
                    <xsl:copy-of select="ahf:getAttributeSet('atsDt')"/>
                    <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                    <xsl:if test="string($compactAttrVal) and $prmDoCompact">
                        <xsl:attribute name="{$dlCompactAttrName}" 
                                       select="ahf:getPropertyRatio($compactAttrVal,$dlCompactRatio)"/>
                    </xsl:if>
                    <xsl:if test="$hasDlhead">
                        <xsl:copy-of select="ahf:getAttributeSet('atsDtHasDlhead')"/>
                    </xsl:if>
                    <xsl:apply-templates>
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                    </xsl:apply-templates>
                </fo:block>
            </fo:table-cell>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/dd ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    <xsl:param name="prmDoCompact" required="yes" as="xs:boolean"/>
    
    <xsl:choose>
        <xsl:when test="$pFormatDlAsBlock">
            <xsl:variable name="compactAttrValBlock" 
                          select="ahf:getAttributeValue('atsDdBlock',$dlCompactAttrNameBlock)"/>
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsDdBlock')"/>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:if test="string($compactAttrValBlock) and $prmDoCompact">
                    <xsl:attribute name="{$dlCompactAttrNameBlock}" 
                                   select="ahf:getPropertyRatio($compactAttrValBlock,$dlCompactRatioBlockDd)"/>
                </xsl:if>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
            <xsl:variable name="compactAttrVal" select="ahf:getAttributeValue('atsDd',$dlCompactAttrName)"/>
            <fo:table-cell>
                <fo:block>
                    <xsl:copy-of select="ahf:getAttributeSet('atsDd')"/>
                    <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                    <xsl:if test="string($compactAttrVal) and $prmDoCompact">
                        <xsl:attribute name="{$dlCompactAttrName}" 
                                       select="ahf:getPropertyRatio($compactAttrVal,$dlCompactRatio)"/>
                    </xsl:if>
                    <xsl:apply-templates>
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                    </xsl:apply-templates>
                </fo:block>
            </fo:table-cell>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	fig template
 param:	    prmTopicRef,prmNeedId
 return:	fo:block
 note:		Generate id attribute for figure list.
 -->
<xsl:template match="*[contains(@class, ' topic/fig ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsFig')"/>
        <xsl:copy-of select="ahf:getDisplayAtts(.,'atsFig')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:if test="not(@id) and child::*[contains(@class, ' topic/title ')]">
            <xsl:attribute name="id" select="ahf:generateId(.,$prmTopicRef)"/>
        </xsl:if>
        <xsl:apply-templates select="*[contains(@class,' topic/desc ')]">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="*[not(contains(@class,' topic/title '))][not(contains(@class,' topic/desc '))]">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
    <!-- process title last -->
    <xsl:apply-templates select="*[contains(@class,' topic/title ')]">
        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
    </xsl:apply-templates>
</xsl:template>

<!-- fig/desc -->
<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/desc ')]" priority="2">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsFigDesc')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
</xsl:template>

<!-- fig/title -->
<xsl:template match="*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ')]" priority="2">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <xsl:variable name="figTitlePrefix" select="ahf:getFigTitlePrefix($prmTopicRef,parent::*)"/>
    
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsFigTitle')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:value-of select="$figTitlePrefix"/>
        <xsl:text>&#x00A0;</xsl:text>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
</xsl:template>

<!-- 
 function:	figgroup template
 param:	    prmTopicRef,prmNeedId
 return:	fo:block
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/figgroup ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:variable name="isFiggroupInTable" select="boolean(ancestor::*[contains(@class,' topic/entry ')])"/>
    <xsl:variable name="atsFiggroup" select="if ($isFiggroupInTable) then 'atsFiggroupInTable' else 'atsFiggroup'"/>
    <xsl:variable name="figgroupId" select="generate-id()"/>
    <xsl:variable name="isLastFiggroup" select="boolean(ancestor::*[contains(@class,' topic/fig ')][(@frame='all') or (@frame='bottom') or (@frame='topbot')]/child::*[position()=last()]/descendant-or-self::*[contains(@class, ' topic/figgroup ')][generate-id()=$figgroupId][not(child::*[contains(@class,' topic/title ')])])"/>
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet($atsFiggroup)"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:if test="$isLastFiggroup">
            <!-- add some spacing -->
            <xsl:copy-of select="ahf:getAttributeSet('atsFiggroupLastSpacing')"/>
        </xsl:if>
        <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
    <!-- process title last -->
    <xsl:apply-templates select="*[contains(@class,' topic/title ')]">
        <xsl:with-param name="prmTopicRef"    select="$prmTopicRef"/>
        <xsl:with-param name="prmNeedId"      select="$prmNeedId"/>
    </xsl:apply-templates>
</xsl:template>

<xsl:template match="*[contains(@class, ' topic/figgroup ')]/*[contains(@class, ' topic/title ')]" priority="2">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:variable name="titleId" select="generate-id()"/>
    <xsl:variable name="isLastFiggroupTitle" select="boolean(ancestor::*[contains(@class,' topic/fig ')][(@frame='all') or (@frame='bottom') or (@frame='topbot')]/child::*[position()=last()]/descendant::*[contains(@class, ' topic/title ')][generate-id()=$titleId])"/>
    
    <xsl:variable name="isFiggroupInTable" select="boolean(ancestor::*[contains(@class,' topic/entry ')])"/>
    <xsl:variable name="atsFiggroupTitle" select="if ($isFiggroupInTable) then 'atsFiggroupTitleInTable' else 'atsFiggroupTitle'"/>
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet($atsFiggroupTitle)"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:if test="$isLastFiggroupTitle">
            <!-- add some spacing -->
            <xsl:copy-of select="ahf:getAttributeSet('atsFiggroupLastTitleSpacing')"/>
        </xsl:if>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
</xsl:template>

<!-- 
 function:	desc template
 param:	    prmTopicRef,prmNeedId
 return:	only call descendant template
 note:		fig/desc is coded previous.
            [Other descs]
             object/desc:  Ignored.
             table/desc:   dita2fo_tableelements.xsl
             link/desc:    Ignored.
             linklist/desc:Ignored.
 -->
<xsl:template match="*[contains(@class, ' topic/xref ')]/*[contains(@class, ' topic/desc ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:apply-templates>
        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
        <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
    </xsl:apply-templates>
</xsl:template>

<!-- 
 function:	image template
 param:	    prmTopicRef,prmNeedId
 return:	fo:external-graphic (fo:block)
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/image ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:choose>
        <xsl:when test="@placement='break'">
            <!-- block level image -->
            <fo:block>
                <xsl:copy-of select="ahf:getImageBlockAttr(.)"/>
                <xsl:copy-of select="ahf:processImage(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef"    select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
            <!-- inline level image -->
            <xsl:copy-of select="ahf:processImage(.,$prmTopicRef,$prmNeedId)"/>
            <xsl:apply-templates>
                <xsl:with-param name="prmTopicRef"    select="$prmTopicRef"/>
                <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
            </xsl:apply-templates>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:function name="ahf:processImage" as="element()*">
    <xsl:param name="prmImage"    as="element()"/>
    <xsl:param name="prmTopicRef" as="element()?"/>
    <xsl:param name="prmNeedId"   as="xs:boolean"/>
    <xsl:choose>
        <xsl:when test="$prmImage/@longdescref">
            <fo:basic-link>
                <xsl:attribute name="external-destination" select="concat('url(',$prmImage/@longdescref,')')"/>
                <fo:external-graphic>
                    <xsl:copy-of select="ahf:getUnivAtts($prmImage,$prmTopicRef,$prmNeedId)"/>
                    <xsl:copy-of select="ahf:getImageCommonAttr($prmImage)"/>
                </fo:external-graphic>
            </fo:basic-link>
        </xsl:when>
        <xsl:otherwise>
            <fo:external-graphic>
                <xsl:copy-of select="ahf:getUnivAtts($prmImage,$prmTopicRef,$prmNeedId)"/>
                <xsl:copy-of select="ahf:getImageCommonAttr($prmImage)"/>
            </fo:external-graphic>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<xsl:function name="ahf:getImageCommonAttr" as="attribute()*">
    <xsl:param name="prmImage" as="element()"/>

    <xsl:if test="$prmImage/@href">
        <xsl:attribute name="src" select="concat('url(',$prmImage/@href,')')"/>
    </xsl:if>

    <xsl:variable name="height" select="ahf:getLength(string($prmImage/@height))"/>
    <xsl:variable name="width"  select="ahf:getLength(string($prmImage/@width))"/>
    <xsl:variable name="scale"  select="normalize-space($prmImage/@scale)"/>
    
    <xsl:choose>
        <xsl:when test="string($width) or string($height)">
            <xsl:if test="string($width)">
                <xsl:attribute name="content-width" select="$width"/>
            </xsl:if>
            <xsl:if test="string($height)">
                <xsl:attribute name="content-height" select="$height"/>
            </xsl:if>
            <xsl:if test="string($width) and string($height)">
                <xsl:attribute name="scaling" select="'non-uniform'"/>
            </xsl:if>
        </xsl:when>
        <xsl:when test="string($scale)">
            <xsl:attribute name="scaling" select="'uniform'"/><!-- XSL default -->
            <xsl:attribute name="content-width" select="concat(normalize-space($scale),'%')"/>
        </xsl:when>
    </xsl:choose>
</xsl:function>

<xsl:function name="ahf:getLength" as="xs:string">
    <xsl:param name="prmLen" as="xs:string"/>
    
    <xsl:variable name="lengthStr" select="normalize-space($prmLen)"/>
    <xsl:variable name="unit" select="ahf:getPropertyUnit($lengthStr)"/>
    <xsl:choose>
        <xsl:when test="not(string($prmLen))">
            <xsl:sequence select="''"/>
        </xsl:when>
        <xsl:when test="not(string($unit))">
            <!-- If no unit is specified, adopt "px" -->
            <xsl:sequence select="concat($lengthStr,$cUnitPx)"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:sequence select="$lengthStr"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<xsl:function name="ahf:getImageBlockAttr" as="attribute()*">
    <xsl:param name="prmImage" as="element()"/>
    <xsl:if test="$prmImage/@align">
        <xsl:variable name="align" select="$prmImage/@align"/>
        <xsl:choose>
            <xsl:when test="$align='left'">
                <xsl:attribute name="text-align" select="'start'"/>
            </xsl:when>
            <xsl:when test="$align='right'">
                <xsl:attribute name="text-align" select="'end'"/>
            </xsl:when>
            <xsl:when test="$align='center'">
                <xsl:attribute name="text-align" select="'center'"/>
            </xsl:when>
            <xsl:when test="$align='current'">
                <!-- treat as inherited value -->
                <xsl:attribute name="text-align" select="'inherited-attribute-value(text-align)'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:if>
</xsl:function>

<!-- 
 function:	alt template
 param:	    prmTopicRef,prmNeedId
 return:	none
 note:		skip contents
 -->
<xsl:template match="*[contains(@class, ' topic/alt ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
</xsl:template>

<!-- 
 function:	object template
 param:	    prmTopicRef,prmNeedId
 return:	none
 note:		Element object is not supported because:
            1. Object without foreign/unknown is for HTML output.
            2. Object with foreign/unkown causes parser error.
               Content type of foreign is ANY. However this means
               DITA DTD needs SVG, MathML, etc DTDs.
 -->
<xsl:template match="*[contains(@class, ' topic/object ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <xsl:choose>
        <xsl:when test="child::*[contains(@class,' topic/foreign ') or contains(@class,' topic/unknown ')]">
            <xsl:call-template name="warningContinue">
                <xsl:with-param name="prmMes">
                    <xsl:value-of select="ahf:replace($stMes040,('%file','%trace'),(@xtrf,@xtrc))"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="warningContinue">
                <xsl:with-param name="prmMes">
                    <xsl:value-of select="ahf:replace($stMes041,('%file','%class'),(@xtrf,@classid))"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	param template
 param:	    prmTopicRef,prmNeedId
 return:	none
 note:		This template will not be activated.
 -->
<xsl:template match="*[contains(@class, ' topic/param ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
</xsl:template>

<!-- 
 function:	pre template
 param:	    prmTopicRef,prmNeedId
 return:	fo:block
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/pre ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsPre')"/>
        <xsl:copy-of select="ahf:getDisplayAtts(.,'atsPre')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
</xsl:template>

<!-- 
 function:	lines template
 param:	    prmTopicRef,prmNeedId
 return:	fo:block
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/lines ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsLines')"/>
        <xsl:copy-of select="ahf:getDisplayAtts(.,'atsLines')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
    </fo:block>
</xsl:template>

<!-- 
 function:	cite template
 param:	    prmTopicRef,prmNeedId
 return:	fo:inline
 note:		
 -->
<xsl:variable name="citePrefix" select="ahf:getVarValue('Cite_Prefix')"/>
<xsl:variable name="citeSuffix" select="ahf:getVarValue('Cite_Suffix')"/>

<xsl:template match="*[contains(@class, ' topic/cite ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <fo:inline>
        <xsl:copy-of select="ahf:getAttributeSet('atsCite')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:value-of select="$citePrefix"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
        <xsl:value-of select="$citeSuffix"/>
    </fo:inline>
</xsl:template>

<!-- 
 function:	lq template
 param:	    prmTopicRef,prmNeedId
 return:	fo:block
 note:		Diffrent from xref/@href, DITA-OT doesn't do special processing for lq/@href.
 -->
<xsl:template match="*[contains(@class, ' topic/lq ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <fo:block>
        <xsl:copy-of select="ahf:getAttributeSet('atsLq')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
        <xsl:if test="@reftitle">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsLqRefTitle')"/>
                <xsl:choose>
                    <xsl:when test="@href">
                        <fo:basic-link>
                            <xsl:copy-of select="ahf:makeBasicLinkDestination(string(@href),string(@type))"/>
                            <xsl:value-of select="@reftitle"/>
                        </fo:basic-link>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@reftitle"/>
                    </xsl:otherwise>
                </xsl:choose>
            </fo:block>
        </xsl:if>
    </fo:block>
</xsl:template>

<!-- 
 function:	q template
 param:	    prmTopicRef,prmNeedId
 return:	fo:inline
 note:		
 -->
<xsl:variable name="qPrefix" select="ahf:getVarValue('Q_Prefix')"/>
<xsl:variable name="qSuffix" select="ahf:getVarValue('Q_Suffix')"/>

<xsl:template match="*[contains(@class, ' topic/q ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <fo:inline>
        <xsl:copy-of select="ahf:getAttributeSet('atsQ')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:value-of select="$qPrefix"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
        <xsl:value-of select="$qSuffix"/>
    </fo:inline>
</xsl:template>




<!-- ========================
      Common templates
     ======================== -->
<!-- 
 function:	Make fo:basic-link attribute external-destination/internal-destination
 param:		prmHref, prmScope
 return:	attribute()*
 note:		
 -->
<xsl:function name="ahf:makeBasicLinkDestination" as="attribute()*">
    <xsl:param name="prmHref" as="xs:string"/>
    <xsl:param name="prmScope" as="xs:string"/>
    
    <xsl:choose>
        <xsl:when test="($prmScope='external')
                     or (contains($prmHref,'://'))
                     or (starts-with($prmHref,'/'))
                     or (matches($prmHref,'^[a-zA-Z]:\\'))">
            <!-- external link -->
            <xsl:variable name="isLinkToPdf" select="matches($prmHref,'(\.PDF#|\.pdf#)')"/>
            <xsl:choose>
                <xsl:when test="$isLinkToPdf">
                    <xsl:variable name="modifiedHref" select="replace($prmHref,'(\.PDF#|\.pdf#)','$1nameddest=')"/>
                    <xsl:attribute name="external-destination" select="concat('url(', $modifiedHref, ')')"/>
                    <xsl:attribute name="axf:action-type" select="'gotor'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="external-destination" select="concat('url(', $prmHref, ')')"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
            <!-- Internal link -->
            <xsl:choose>
                <xsl:when test="$pGenUniqueId">
                    <xsl:variable name="dstId" select="replace(substring-after($prmHref,'#'),'/',$idSeparator)" as="xs:string"/>
                    <xsl:attribute name="internal-destination" select="$dstId"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:variable name="topicId"   select="substring-after($prmHref,'#')"/>
                    <xsl:variable name="elementId" select="substring-after($prmHref,'/')"/>
                    <xsl:choose>
                        <xsl:when test="not(string($elementId))">
                            <xsl:attribute name="internal-destination" select="$topicId"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:attribute name="internal-destination" select="$elementId"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<!-- 
 function:	Generate fig title prefix
 param:		prmTopicRef, prmFig
 return:	Table title prefix string
 note:		
 -->
<xsl:function name="ahf:getFigTitlePrefix" as="xs:string">
    <xsl:param name="prmTopicRef" as="element()"/>
    <xsl:param name="prmFig" as="element()"/>

    <xsl:variable name="titlePrefix" as="xs:string">
        <xsl:choose>
            <xsl:when test="$pAddNumberingTitlePrefix">
                <xsl:variable name="tempTitlePrefix" select="ahf:genNumberingPrefix($prmTopicRef,$cFigureGroupingLevelMax)"/>
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

    <xsl:variable name="topicNode" select="$prmFig/ancestor::*[contains(@class, ' topic/topic ')][position()=last()]"/>

    <xsl:variable name="figPreviousAmount" as="xs:integer">
        <xsl:variable name="topicNodeId" select="ahf:generateIdByTopicRef(string($topicNode/@id),$prmTopicRef)"/>
        <xsl:sequence select="$figureNumberingMap/*[@id=$topicNodeId]/@count"/>
    </xsl:variable>

    <xsl:variable name="figCurrentAmount" as="xs:integer">
        <xsl:number select="$prmFig"
                    level="any"
                    count="*[contains(@class,' topic/fig ')]"
                    from="*[contains(@class, ' topic/topic ')][generate-id(parent::*)=$rootId]"/>
    </xsl:variable>
    <xsl:variable name="figNumber" select="$figPreviousAmount + $figCurrentAmount" as="xs:integer"/>

    <xsl:sequence select="concat($cFigureTitle,$titlePrefix,string($figNumber))"/>
</xsl:function>

</xsl:stylesheet>