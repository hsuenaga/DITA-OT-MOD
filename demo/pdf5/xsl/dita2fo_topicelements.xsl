<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet 
Module: Topic elements stylesheet
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
<!-- NOTE: topic/title is coded in dita2fo_title.xsl -->

<!-- 
 function:	titlealts template
 param:	    prmTopicRef, prmNeedId
 return:	none
 note:		none
 -->
<xsl:template match="*[contains(@class, ' topic/titlealts ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
</xsl:template>
<!-- 
 function:	navtitle template
 param:	    prmTopicRef, prmNeedId
 return:	none
 note:		none
 -->
<xsl:template match="*[contains(@class, ' topic/navtitle ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
</xsl:template>

<!-- 
 function:	searchtitle template
 param:	    prmTopicRef, prmNeedId
 return:	none
 note:		none
 -->
<xsl:template match="*[contains(@class, ' topic/searchtitle ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
</xsl:template>

<!-- 
 function:	abstract template
 param:	    prmTopicRef, prmNeedId
 return:	fo:block or descendant generated fo objects
 note:		xsl:strip-space is applied for this element.
 -->
<xsl:template match="*[contains(@class, ' topic/abstract ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <xsl:choose>
        <xsl:when test="child::text()">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsAbstract')"/>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
            <fo:wrapper>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:wrapper>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	shortdesc template
 param:	    prmTopicRef, prmNeedId
 return:	fo:block or descendant generated fo objects
 note:		Abstract can contain shortdesc as inline or block level objects.
 -->
<xsl:template match="*[contains(@class, ' topic/shortdesc ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <xsl:choose>
        <xsl:when test="parent::*[contains(@class, ' topic/abstract ')]">
            <!-- Child of abstract -->
            <xsl:variable name="abstract" select="parent::*[contains(@class, ' topic/abstract ')]"/>
            <xsl:choose>
                <xsl:when test="$abstract/text()">
                    <fo:wrapper>
                        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                        <xsl:apply-templates>
                            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                        </xsl:apply-templates>
                    </fo:wrapper>
                </xsl:when>
                <xsl:otherwise>
                    <fo:block>
                        <xsl:copy-of select="ahf:getAttributeSet('atsShortdesc')"/>
                        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                        <xsl:apply-templates>
                            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                        </xsl:apply-templates>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
            <!-- Independent shortdesc -->
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsShortdesc')"/>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	prolog template
 param:	    prmTopicRef, prmNeedId
 return:	
 note:		This template will be never called.
 -->
<xsl:template match="*[contains(@class, ' topic/prolog ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
</xsl:template>

<!-- 
 function:	body template
 param:	    prmTopicRef, prmNeedId
 return:	fo:wrapper
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/body ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>
    
    <xsl:variable name="body" select="."/>
    <fo:wrapper>
        <xsl:copy-of select="ahf:getAttributeSet('atsBody')"/>
        <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:apply-templates>
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
        </xsl:apply-templates>
        <!-- Make fo:index-range-end FO object that has @start 
             but has no corresponding @end indexterm in body.
         -->
        <xsl:apply-templates select="$body//*[contains(@class, ' topic/indexterm ')]">
            <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
            <xsl:with-param name="prmNeedId" select="false()"/>
            <xsl:with-param name="prmMakeComplementEnd" tunnel="yes" select="true()"/>
            <xsl:with-param name="prmRangeElem" tunnel="yes" select="$body"/>
        </xsl:apply-templates>
    </fo:wrapper>
</xsl:template>

<!-- 
 function:	Section template
 param:	    prmTopicRef, prmNeedId
 return:	Section contents
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/section ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:choose>
        <xsl:when test="child::text()[string(normalize-space(.))]">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsSection')"/>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef"    select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
            <fo:wrapper>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:wrapper>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	Section title template
 param:	    prmTopicRef, prmNeedId
 return:	Section title list
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/section ')]/*[contains(@class, ' topic/title ')]" priority="2">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:list-block>
        <xsl:copy-of select="ahf:getAttributeSet('atsHeader5List')"/>
        <xsl:copy-of select="ahf:getIdAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:copy-of select="ahf:getLocalizationAtts(.)"/>
        <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
                <fo:block>
                    <xsl:copy-of select="ahf:getAttributeSet('atsHeader5Label')"/>
                    <xsl:value-of select="ahf:getVarValue('Level5_Label_Char')"/>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <xsl:copy-of select="ahf:getAttributeSet('atsHeader5Body')"/>
                    <xsl:apply-templates>
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                    </xsl:apply-templates>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </fo:list-block>
</xsl:template>

<!-- 
 function:	Example template
 param:	    prmTopicRef, prmNeedId
 return:	Example contents
 note:		Example has same content model with section
 -->
<xsl:template match="*[contains(@class, ' topic/example ')]">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <xsl:choose>
        <xsl:when test="child::text()[string(normalize-space(.))]">
            <fo:block>
                <xsl:copy-of select="ahf:getAttributeSet('atsExample')"/>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:when>
        <xsl:otherwise>
            <fo:wrapper>
                <xsl:copy-of select="ahf:getUnivAtts(.,$prmTopicRef,$prmNeedId)"/>
                <xsl:apply-templates>
                    <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                    <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                </xsl:apply-templates>
            </fo:wrapper>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	Example title template
 param:	    prmTopicRef, prmNeedId
 return:	Example title list
 note:		
 -->
<xsl:template match="*[contains(@class, ' topic/example ')]/*[contains(@class, ' topic/title ')]" priority="2">
    <xsl:param name="prmTopicRef" required="yes"  as="element()?"/>
    <xsl:param name="prmNeedId"   required="yes"  as="xs:boolean"/>

    <fo:list-block>
        <xsl:copy-of select="ahf:getAttributeSet('atsHeader5List')"/>
        <xsl:copy-of select="ahf:getIdAtts(.,$prmTopicRef,$prmNeedId)"/>
        <xsl:copy-of select="ahf:getLocalizationAtts(.)"/>
        <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
                <fo:block>
                    <xsl:copy-of select="ahf:getAttributeSet('atsHeader5Label')"/>
                    <xsl:value-of select="$cLevel5LabelChar"/>
                </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
                <fo:block>
                    <xsl:copy-of select="ahf:getAttributeSet('atsHeader5Body')"/>
                    <xsl:apply-templates>
                        <xsl:with-param name="prmTopicRef" select="$prmTopicRef"/>
                        <xsl:with-param name="prmNeedId"   select="$prmNeedId"/>
                    </xsl:apply-templates>
                </fo:block>
            </fo:list-item-body>
        </fo:list-item>
    </fo:list-block>
</xsl:template>


</xsl:stylesheet>