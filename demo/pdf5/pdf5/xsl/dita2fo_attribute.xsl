<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Common attribute templates
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
 function:	Process %univ-atts; attribute
 param:		prmElement, prmTopicRef,prmNeedId
 return:	attribute node
 note:		
 -->
<xsl:function name="ahf:getUnivAtts" as="attribute()*">
    <xsl:param name="prmElement" as="element()"/>
    <xsl:param name="prmTopicRef" as="element()?"/>
    <xsl:param name="prmNeedId"   as="xs:boolean"/>

    <!-- localization-atts -->
    <xsl:sequence select="ahf:getLocalizationAtts($prmElement)"/>
    
    <!-- id-atts -->
    <xsl:sequence select="ahf:getIdAtts($prmElement, $prmTopicRef, $prmNeedId)"/>
    
</xsl:function>

<!-- 
 function:	Process %id-atts; attribute
 param:		prmElement, prmTopicRef, prmNeedId
 return:	attribute node
 note:		
 -->
<xsl:function name="ahf:getIdAtts" as="attribute()*">
    <xsl:param name="prmElement"  as="element()"/>
    <xsl:param name="prmTopicRef" as="element()?"/>
    <xsl:param name="prmNeedId"   as="xs:boolean"/>

    <!-- id-atts: id -->
    <xsl:if test="($prmElement/@id) and $prmNeedId">
        <xsl:variable name="id" select="$prmElement/@id" as="attribute()"/>
        <!-- topicRefCount: Count of topicref that refers this topic -->
        <xsl:variable name="topicRefCount" select="ahf:countTopicRef($prmTopicRef)"/>
        <xsl:choose>
            <xsl:when test="contains($prmElement/@class, ' topic/topic ')">
                <!-- Topic 
                 -->
                <xsl:choose>
                    <xsl:when test="$pGenUniqueId">
                        <!-- Adopt "oid". -->
                        <xsl:variable name="oid" select="$prmElement/@oid"/>
                        <!--xsl:variable name="oidKeyCount" select="count(key('elementByOid', $oid, $root))"/>
                        <xsl:variable name="oidSeq" select="if ($oidKeyCount=0) then 0 else count($prmElement/preceding::*[string(@oid)=string($oid)])"/-->
                        <xsl:variable name="refedTopic"  select="substring-after($prmTopicRef/@href, '#')=string($id)"/>
                        <xsl:choose>
                            <xsl:when test="$topicRefCount=1">
                                <!-- normal pattern -->
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$oid"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- topic is referenced more than onec or oid exists plurally -->
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$oid"/>
                                    <xsl:value-of select="$idSeparator"/>
                                    <xsl:value-of select="string($topicRefCount)"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                        <xsl:if test="$refedTopic">
                            <!-- Add named destination -->
                            <xsl:attribute name="axf:destination-type" select="'xyz'"/>
                        </xsl:if>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Adopt DITA-OT's id:"uniqueN" -->
                        <xsl:choose>
                            <xsl:when test="$topicRefCount=1">
                                <!-- normal pattern -->
                                <xsl:sequence select="$id"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- topic is referenced more than onec or id exists plurally -->
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$id"/>
                                    <xsl:value-of select="$idSeparator"/>
                                    <xsl:value-of select="string($topicRefCount)"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- Other local elements 
                     The id attribute must be unique only within the topic.
                     This stylesheet make them unique in whole document.
                -->
                <xsl:variable name="idKeyCount" select="count(key('elementById', $id, $root))"/>
                <xsl:variable name="idSeq" select="if ($idKeyCount=0) then 0 else count($prmElement/preceding::*[string(@id)=string($id)])"/>
                <!--xsl:message>id='<xsl:value-of select="$id"/>' idKeyCount='<xsl:value-of select="$idKeyCount"/>'</xsl:message-->
                <xsl:choose>
                    <xsl:when test="$pGenUniqueId">
                        <!-- add topic/oid to every id as prefix to make it unique -->
                        <xsl:variable name="topicOid" 
                        select="string($prmElement/ancestor::*[contains(@class, ' topic/topic ')][1]/@oid)"/>
                        <xsl:choose>
                            <xsl:when test="$topicRefCount=1">
                                <!-- normal pattern -->
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$topicOid"/>
                                    <xsl:value-of select="$idSeparator"/>
                                    <xsl:value-of select="$id"/>
                                </xsl:attribute>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- topic is referenced more than onec -->
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$topicOid"/>
                                    <xsl:value-of select="$idSeparator"/>
                                    <xsl:value-of select="$id"/>
                                    <xsl:value-of select="$idSeparator"/>
                                    <xsl:value-of select="string($topicRefCount)"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="($topicRefCount=1) and ($idSeq=0)">
                                <!-- normal pattern -->
                                <xsl:sequence select="$id"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!-- topic is referenced more than onec or id exists plurally -->
                                <xsl:attribute name="id">
                                    <xsl:value-of select="$id"/>
                                    <xsl:value-of select="$idSeparator"/>
                                    <xsl:value-of select="if ($topicRefCount=1) then '' else string($topicRefCount+1)"/>
                                    <xsl:value-of select="if ($idSeq=0) then '' else $idSeparator"/>
                                    <xsl:value-of select="if ($idSeq=0) then '' else string($idSeq+1)"/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>

</xsl:function>

<!-- 
 function:	Process %localization-atts; attribute
 param:		prmElement
 return:	attribute node
 note:		@dir="lro", "rlo" is not implemented.
 -->
<xsl:function name="ahf:getLocalizationAtts" as="attribute()*">
    <xsl:param name="prmElement" as="element()"/>

    <!-- localization-atts: xml:lang -->
    <xsl:if test="$prmElement/@xml:lang">
        <xsl:sequence select="$prmElement/@xml:lang"/>
    </xsl:if>
    
    <!-- localization-atts: dir -->
    <xsl:if test="$prmElement/@dir">
        <xsl:variable name="dir" select="$prmElement/@dir"/>
        <xsl:choose>
            <xsl:when test="($dir='ltr') or ($dir='rtl')">
                <xsl:attribute name="direction" select="$dir"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:if>
</xsl:function>

<!-- 
 function:	Process %display-atts; attribute
 param:		prmElement, prmStyleName
 return:	attribute node
 note:		
 -->
<xsl:function name="ahf:getDisplayAtts" as="attribute()*">
    <xsl:param name="prmElement" as="element()"/>
    <xsl:param name="prmStyleName" as="xs:string"/>

    <!-- @scale -->
    <xsl:sequence select="ahf:getScaleAtts($prmElement, $prmStyleName)"/>
    
    <!-- @frame -->
    <xsl:sequence select="ahf:getFrameAtts($prmElement)"/>
    
    <!-- @expanse -->
    <xsl:sequence select="ahf:getExpanseAtts($prmElement)"/>

</xsl:function>

<!-- 
 function:	Process scale attribute
 param:		prmElement, prmStyleName
 return:	attribute node
 note:		
 -->
<xsl:function name="ahf:getScaleAtts" as="attribute()*">
    <xsl:param name="prmElement" as="element()"/>
    <xsl:param name="prmStyleName" as="xs:string"/>

    <xsl:if test="$prmElement/@scale">
        <xsl:variable name="scale" select="ahf:percentToNumber($prmElement/@scale,$prmElement)" as="xs:double"/>
        <xsl:variable name="fontSize" select="ahf:getAttributeValue($prmStyleName, 'font-size')" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="string($fontSize)">
                <xsl:variable name="fontSizeNu" select="ahf:getPropertyNu($fontSize)" as="xs:double"/>
                <xsl:variable name="fontSizeUnit" select="ahf:getPropertyUnit($fontSize)" as="xs:string"/>
                <xsl:variable name="fontSizeScaled" select="$fontSizeNu * $scale" as="xs:double"/>
                <xsl:attribute name="font-size" select="concat(string($fontSizeScaled), $fontSizeUnit)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="font-size">
                    <xsl:text>inherited-property-value(font-size) * </xsl:text>
                    <xsl:value-of select="string($scale)"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
</xsl:function>

<!-- 
 function:	Process frame attribute
 param:		prmElement
 return:	attribute node
 note:		
 -->
<xsl:function name="ahf:getFrameAtts" as="attribute()*">
    <xsl:param name="prmElement" as="element()"/>

    <xsl:if test="$prmElement/@frame">
        <xsl:variable name="frame" select="$prmElement/@frame"/>
        
        <xsl:choose>
            <xsl:when test="contains($prmElement/@class, ' topic/simpletable ')
                         or contains($prmElement/@class, ' topic/table ')">
                <xsl:choose>
                    <xsl:when test="$frame='top'">
                        <xsl:sequence select="ahf:getAttributeSet('atsTableBorderTop')"/>
                    </xsl:when>
                    <xsl:when test="$frame='bottom'">
                        <xsl:sequence select="ahf:getAttributeSet('atsTableBorderBottom')"/>
                    </xsl:when>
                    <xsl:when test="$frame='topbot'">
                        <xsl:sequence select="ahf:getAttributeSet('atsTableBorderTopBottom')"/>
                    </xsl:when>
                    <xsl:when test="$frame='all'">
                        <xsl:sequence select="ahf:getAttributeSet('atsTableBorderAll')"/>
                    </xsl:when>
                    <xsl:when test="$frame='sides'">
                        <xsl:sequence select="ahf:getAttributeSet('atsTableBorderSides')"/>
                    </xsl:when>
                    <xsl:when test="$frame='none'">
                        <xsl:sequence select="ahf:getAttributeSet('atsTableBorderNone')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$frame='top'">
                        <xsl:sequence select="ahf:getAttributeSet('atsBlockBorderTop')"/>
                    </xsl:when>
                    <xsl:when test="$frame='bottom'">
                        <xsl:sequence select="ahf:getAttributeSet('atsBlockBorderBottom')"/>
                    </xsl:when>
                    <xsl:when test="$frame='topbot'">
                        <xsl:sequence select="ahf:getAttributeSet('atsBlockBorderTopBottom')"/>
                    </xsl:when>
                    <xsl:when test="$frame='all'">
                        <xsl:sequence select="ahf:getAttributeSet('atsBlockBorderAll')"/>
                    </xsl:when>
                    <xsl:when test="$frame='sides'">
                        <xsl:sequence select="ahf:getAttributeSet('atsBlockBorderSides')"/>
                    </xsl:when>
                    <xsl:when test="$frame='none'">
                        <xsl:sequence select="ahf:getAttributeSet('atsBlockBorderNone')"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:if>
</xsl:function>

<!-- 
 function:	Process expanse/pgwide attribute
 param:		prmElement
 return:	attribute node
 note:		
 -->
<xsl:function name="ahf:getExpanseAtts" as="attribute()*">
    <xsl:param name="prmElement" as="element()"/>

    <xsl:if test="$prmElement/@expanse">
        <xsl:variable name="expanse" select="string($prmElement/@expanse)"/>
        
        <xsl:choose>
            <xsl:when test="contains($prmElement/@class, ' topic/simpletable ')">
                <xsl:if test="($expanse='page') or ($expanse='column')">
                    <xsl:sequence select="ahf:getAttributeSet('atsTableExpanse')"/>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:if>

    <xsl:if test="$prmElement/@pgwide='1'">
        <xsl:choose>
            <xsl:when test="contains($prmElement/@class, ' topic/table ')">
                <xsl:sequence select="ahf:getAttributeSet('atsTablePgWide')"/>
            </xsl:when>
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:if>

</xsl:function>


<!-- 
 function:	Percent to number
 param:		prmPercent,prmElement
 return:	number
 note:		
 -->
<xsl:function name="ahf:percentToNumber" as="xs:double">
    <xsl:param name="prmPercent" as="xs:string"/>
    <xsl:param name="prmElement" as="element()"/>
    
    <xsl:choose>
        <xsl:when test="string(number($prmPercent))=$NaN">
            <xsl:call-template name="warningContinue">
                <xsl:with-param name="prmMes" 
                 select="ahf:replace($stMes028,('%scale','%elem','%file'),($prmPercent,name($prmElement),$prmElement/@xtrf))"/>
            </xsl:call-template>
            <xsl:sequence select="1"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:sequence select="number($prmPercent) div 100"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:function>

<!-- 
 function:	Generate unique id cosidering multiple topic reference
 param:		prmElement,prmTopicRef
 return:	id string
 note:		About the indexterm in topicref/topicmeta, the parameter 
            $prmTopicRef is empty.
 -->
<xsl:function name="ahf:generateId" as="xs:string">
    <xsl:param name="prmElement" as="element()"/>
    <xsl:param name="prmTopicRef" as="element()?"/>

    <xsl:variable name="topicRefCount" select="if (exists($prmTopicRef)) then ahf:countTopicRef($prmTopicRef) else 0" as="xs:integer"/>

    <xsl:variable name="id1" select="generate-id($prmElement)" as="xs:string"/>
    <xsl:variable name="id2" select="if ($topicRefCount &gt; 1) then $idSeparator else ''" as="xs:string"/>
    <xsl:variable name="id3" select="if ($topicRefCount &gt; 1) then string($topicRefCount) else ''" as="xs:string"/>
    <xsl:sequence select="concat($id1,$id2,$id3)"/>
</xsl:function>

<!-- 
 function:	Generate unique id cosidering multiple topic reference
 param:		prmElement,prmTopicRefCount
 return:	id string
 note:		
 -->
<xsl:function name="ahf:generateIdByTrCount" as="xs:string">
    <xsl:param name="prmElement" as="element()"/>
    <xsl:param name="prmTopicRefCount" as="xs:integer"/>

    <xsl:variable name="id1" select="generate-id($prmElement)" as="xs:string"/>
    <xsl:variable name="id2" select="if ($prmTopicRefCount &gt; 1) then $idSeparator else ''" as="xs:string"/>
    <xsl:variable name="id3" select="if ($prmTopicRefCount &gt; 1) then string($prmTopicRefCount) else ''" as="xs:string"/>
    <xsl:sequence select="concat($id1,$id2,$id3)"/>
</xsl:function>

<!-- 
 function:	Generate unique id cosidering multiple topic reference
 param:		prmId,prmTopicRef
 return:	id string
 note:		
 -->
<xsl:function name="ahf:generateIdByTopicRef" as="xs:string">
    <xsl:param name="prmId" as="xs:string"/>
    <xsl:param name="prmTopicRef" as="element()"/>

    <xsl:variable name="topicRefCount" select="ahf:countTopicRef($prmTopicRef)" as="xs:integer"/>

    <xsl:variable name="id1" select="$prmId" as="xs:string"/>
    <xsl:variable name="id2" select="if ($topicRefCount &gt; 1) then $idSeparator else ''" as="xs:string"/>
    <xsl:variable name="id3" select="if ($topicRefCount &gt; 1) then string($topicRefCount) else ''" as="xs:string"/>
    <xsl:sequence select="concat($id1,$id2,$id3)"/>
</xsl:function>


</xsl:stylesheet>
