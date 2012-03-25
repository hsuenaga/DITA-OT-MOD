<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Merged file conversion templates
Copyright © 2009-2009 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="2.0" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
<xsl:output method="xml" encoding="UTF-8"/>

<!-- 
 function:	General template for all element
 param:		none
 return:	copied result
 note:		
 -->
<xsl:template match="*">
    <xsl:copy>
        <xsl:copy-of select="@*"/>
        <xsl:apply-templates/>
    </xsl:copy>
</xsl:template>

<!-- 
 function:	topicgroup
 param:		none
 return:	descendant element
 note:		An topicgroup is redundant for document structure.
            It sometimes bothers counting the nesting level of topicref.
 -->
<xsl:template match="*[contains(@class, ' mapgroup-d/topicgroup ')]" priority="2">
    <xsl:apply-templates/>
</xsl:template>

<!--
 function:	topicref
 param:		none
 return:	self and descendant element or none
 note:		if @print="no", ignore it.
 -->
<xsl:template match="*[contains(@class,' map/topicref ')]">
	<xsl:choose>
		<xsl:when test="@print='no'" />
        <xsl:otherwise>
            <xsl:copy>
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates/>
            </xsl:copy>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<!-- 
 function:	comment template
 param:		none
 return:	comment 
 note:		none
 -->
<xsl:template match="comment()">
    <xsl:copy/>
</xsl:template>

<!-- 
 function:	processing-instruction template
 param:		nome
 return:	processing-instruction
 note:		
 -->
<xsl:template match="processing-instruction()">
    <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
