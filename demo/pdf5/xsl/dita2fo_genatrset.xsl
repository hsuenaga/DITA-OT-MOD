<?xml version="1.0" encoding="UTF-8" ?>
<!--
**************************************************************
DITA to XSL-FO Stylesheet
Read attributeset,variable and instream-object from external
style definition file into temporary tree.
**************************************************************
File Name : dita2fo_genatrset.xsl
**************************************************************
Copyright © 2009 2009 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL : http://www.antennahouse.co.jp/
**************************************************************
-->

<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
    xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:l="http://www.antennahouse.com/names/XSLT/Document/Layout"
	exclude-result-prefixes="xs ahf"
>

<!-- 
    ============================================
     Constants
    ============================================
-->
<!-- variable reference symbol char -->
<xsl:variable name="varRefChar" select="'$'"/>
<xsl:variable name="varRefEscapeChar" select="'\'"/>
<xsl:variable name="styleRefChar" select="'%'"/>
<!-- Default delimiter: space and colon(for SVG) -->
<xsl:variable name="defaultDelimChar" select="' ;'"/>

<xsl:variable name="stAltNullValue">
	<xsl:text>''</xsl:text>
</xsl:variable>

<!-- 
    =======================================================
     Style attributes and variables from 
     default_style.xml, [lang-code]_style.xml
    =======================================================
-->

<xsl:variable name="glStyleDefs">
	<xsl:apply-templates select="document($PRM_STYLE_DEF_FILE)//l:attribute-set"/>
</xsl:variable>

<xsl:variable name="glVarDefs">
	<xsl:apply-templates select="document($PRM_STYLE_DEF_FILE)//l:variable">
		<xsl:with-param name="prmStyleDefFile" select="$PRM_STYLE_DEF_FILE"/>
		<xsl:with-param name="prmAltStyleDefFile">
            <xsl:choose>
                <xsl:when test="string($PRM_ALT_STYLE_DEF_FILE) and string($PRM_ALT_STYLE_DEF_FILE) != $stAltNullValue">
                    <xsl:value-of select="$PRM_ALT_STYLE_DEF_FILE"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="''"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:with-param>
	</xsl:apply-templates>
</xsl:variable>

<xsl:variable name="glInstreamObjects">
	<xsl:apply-templates select="document($PRM_STYLE_DEF_FILE)//l:instream-object"/>
</xsl:variable>

<xsl:variable name="glAltStyleDefs">
	<xsl:choose>
		<xsl:when test="string($PRM_ALT_STYLE_DEF_FILE) and string($PRM_ALT_STYLE_DEF_FILE) != $stAltNullValue" >
			<xsl:apply-templates select="document($PRM_ALT_STYLE_DEF_FILE)//l:attribute-set"/>
		</xsl:when>
		<xsl:otherwise>
			<dummy/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="glAltVarDefs">
	<xsl:choose>
		<xsl:when test="string($PRM_ALT_STYLE_DEF_FILE) and string($PRM_ALT_STYLE_DEF_FILE) != $stAltNullValue" >
			<xsl:apply-templates select="document($PRM_ALT_STYLE_DEF_FILE)//l:variable">
				<xsl:with-param name="prmStyleDefFile" select="$PRM_ALT_STYLE_DEF_FILE"/>
        		<xsl:with-param name="prmAltStyleDefFile" select="''"/>
			</xsl:apply-templates>
		</xsl:when>
		<xsl:otherwise>
			<dummy/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<xsl:variable name="glAltInstreamObjects">
	<xsl:choose>
		<xsl:when test="string($PRM_ALT_STYLE_DEF_FILE) and string($PRM_ALT_STYLE_DEF_FILE) != $stAltNullValue" >
			<xsl:apply-templates select="document($PRM_ALT_STYLE_DEF_FILE)//l:instream-object"/>
		</xsl:when>
		<xsl:otherwise>
			<dummy/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>

<!-- 
     l:attr-set
     element name=l:attribute-set/@name
     element attribute=l:attribute-set/l:attribute/@*
  -->
<xsl:template match="l:attribute-set">
    <xsl:variable name="currentElement" select="."/>
	<xsl:element name="{string(@name)}">
	    <xsl:if test="@use-attribute-sets">
            <xsl:for-each select="tokenize(string(@use-attribute-sets), '[,\s]+')">
                <xsl:call-template name="processUseAttributeSet">
                    <xsl:with-param name="prmAttributeSet" select="string(.)"/>
                    <xsl:with-param name="prmCurrentElement" select="$currentElement"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
	    <xsl:apply-templates select="l:attribute"/>
	</xsl:element>
</xsl:template>

<xsl:template name="processUseAttributeSet">
    <xsl:param name="prmAttributeSet" required="yes" as="xs:string"/>
    <xsl:param name="prmCurrentElement" required="yes" as="element()"/>
    <xsl:apply-templates select="root($prmCurrentElement)//l:attribute-set[string(@name)=$prmAttributeSet]" mode="use-attribute-sets"/>
</xsl:template>

<xsl:template match="l:attribute-set" mode="use-attribute-sets">
    <xsl:variable name="currentElement" select="."/>
    <xsl:if test="@use-attribute-sets">
        <xsl:for-each select="tokenize(string(@use-attribute-sets), '[,\s]+')">
            <xsl:call-template name="processUseAttributeSet">
                <xsl:with-param name="prmAttributeSet" select="string(.)"/>
                <xsl:with-param name="prmCurrentElement" select="$currentElement"/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:if>
    <xsl:apply-templates select="l:attribute"/>
</xsl:template>

<!-- 
     l:attribute
     element name=l:attribute/@name
     element attribute=l:attribute/@select (or text node)
  -->

<xsl:template match="l:attribute">
	<xsl:variable name="attName" select="string(@name)"/>
	<xsl:variable name="attValue" select="if (@select) then string(@select) else string(.)"/>
	
	<!--xsl:message>[l:attribute] $attName="<xsl:value-of select="$attName"/>" $attValue="<xsl:value-of select="$attValue"/>"</xsl:message-->
	
	<xsl:attribute name="{$attName}">
		<xsl:choose>
			<!-- '$' means variable reference -->
			<xsl:when test="contains($attValue, $varRefChar)">
				<xsl:call-template name="expandVarRef">
					<xsl:with-param name="srcString" select="$attValue"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$attValue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:attribute>
</xsl:template>

<!-- 
     l:variable
     element name=l:variable/@name
     element attribute=l:variable/@select (or text node)
  -->
<xsl:template match="l:variable">
	<xsl:param name="prmStyleDefFile" required="yes" as="xs:string"/>
	<xsl:param name="prmAltStyleDefFile" required="yes" as="xs:string"/>

	<!--xsl:message>[l:variable] varname="<xsl:value-of select="@name"/>" $attValue="<xsl:value-of select="@select"/>"</xsl:message-->
	<xsl:variable name="varValue" select="if (@select) then string(@select) else string(.)"/>

	<xsl:element name="{@name}">
		<xsl:choose>
			<xsl:when test="substring($varValue,1,1) = $varRefChar">
				<xsl:call-template name="getVarRecursive">
					<xsl:with-param name="prmVarName" select="substring-after($varValue,$varRefChar)"/>
					<xsl:with-param name="prmStyleDefFile" select="$prmStyleDefFile"/>
					<xsl:with-param name="prmAltStyleDefFile" select="$prmAltStyleDefFile"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
			  <xsl:value-of select="$varValue"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:element>
</xsl:template>


<!-- 
     l:variable sub-template
     function: get variable value recursively using document function.
  -->

<xsl:template name="getVarRecursive">
	<xsl:param name="prmVarName" required="yes" as="xs:string"/>
	<xsl:param name="prmStyleDefFile" required="yes" as="xs:string"/>
	<xsl:param name="prmAltStyleDefFile" required="yes" as="xs:string"/>
	
	<xsl:variable name="varValueElem" select="document($prmStyleDefFile)//l:variable[@name=$prmVarName]"/>
    <xsl:variable name="varValue" select="if ($varValueElem/@select) then string($varValueElem/@select) else string($varValueElem)"/>
    
	<xsl:variable name="altVarValue">
        <xsl:choose>
            <xsl:when test="string($prmAltStyleDefFile)">
            	<xsl:variable name="altVarValueElem" select="document($prmAltStyleDefFile)//l:variable[@name=$prmVarName]"/>
                <xsl:variable name="altVarValue" select="if ($altVarValueElem/@select) then string($altVarValueElem/@select) else string($altVarValueElem)"/>
                <xsl:value-of select="$altVarValue"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="''"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
	
	<xsl:choose>
		<xsl:when test="not(string($varValue)) and not(string($altVarValue))">
			<!-- variable not found error! -->
            <xsl:variable name="styleFile" select="if (string($prmAltStyleDefFile)) then concat($prmStyleDefFile,',',$prmAltStyleDefFile) else $prmStyleDefFile" as="xs:string"/>
			<xsl:call-template name="errorExit">
				<xsl:with-param name="prmMes">
                    <xsl:value-of select="ahf:replace($stMes023,('%varname','%stylefile'),($prmVarName, $styleFile))"/>
				</xsl:with-param>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:choose>
                <!-- Set precedence to $prmAltStyleDefFile variable value. -->
                <xsl:when test="string($altVarValue)">
                    <xsl:choose>
                        <xsl:when test="substring($altVarValue,1,1)=$varRefChar">
                            <!-- Call myself recursively -->
        					<xsl:call-template name="getVarRecursive">
        						<xsl:with-param name="prmVarName" select="substring-after($altVarValue, $varRefChar)"/>
        						<xsl:with-param name="prmStyleDefFile" select="$prmStyleDefFile"/>
        						<xsl:with-param name="prmAltStyleDefFile" select="$prmAltStyleDefFile"/>
        					</xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$altVarValue"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
				<xsl:when test="substring($varValue,1,1)=$varRefChar">
					<!-- call myself recursively -->
					<xsl:call-template name="getVarRecursive">
						<xsl:with-param name="prmVarName" select="substring-after($varValue, $varRefChar)"/>
						<xsl:with-param name="prmStyleDefFile" select="$prmStyleDefFile"/>
						<xsl:with-param name="prmAltStyleDefFile" select="$prmAltStyleDefFile"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$varValue"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>


<!-- 
     l:instream-object
     element name=l:instream-object/@name
     descendant elements=@*, *
  -->
<xsl:template match="l:instream-object">
	<xsl:element name="{@name}">
	  <xsl:copy-of select="@*"/>
	  <xsl:apply-templates mode="PROCESS_INSTREAM_OBJECT"/>
	</xsl:element>
</xsl:template>

<!-- Instream svg object -->
<xsl:template match="svg:*" mode="PROCESS_INSTREAM_OBJECT">
	<xsl:element name="{name()}">
		<xsl:for-each select="attribute::node()">
			<xsl:variable name="attName" select="name()"/>
			<xsl:variable name="attValue" select="string(self::node())"/>
			
			<xsl:attribute name="{$attName}">
				<xsl:choose>
					<!-- '%' means CSS style reference -->
					<xsl:when test="contains($attValue, $styleRefChar) and ($attName='style')">
						<xsl:call-template name="expandCssStyleRef">
							<xsl:with-param name="prmAttrSetName" select="$attValue"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$attValue"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
		</xsl:for-each>
		<xsl:apply-templates mode="PROCESS_INSTREAM_OBJECT"/>
	</xsl:element>
</xsl:template>

<xsl:template match="text()" mode="PROCESS_INSTREAM_OBJECT">
    <xsl:variable name="textString" select="string(.)"/>

	<xsl:choose>
		<!-- '$' in text means variable reference -->
		<xsl:when test="contains($textString, $varRefChar) and (parent::svg:text)">
			<xsl:call-template name="expandVarRef">
				<xsl:with-param name="srcString" select="$textString"/>
			</xsl:call-template>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$textString"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!--
    =========================================
			Sub templates
	=========================================
-->
<!-- expand variable reference -->
<xsl:template name="expandVarRef">
	<xsl:param name="srcString" required="yes" as="xs:string"/>
	
	<!-- left of variable reference symbol char -->
	<xsl:variable name="tempLeftOfRef" select="substring-before($srcString, $varRefChar)"/>
    <xsl:variable name="escapedVarRef" select="ends-with($tempLeftOfRef, $varRefEscapeChar)"/>
    <xsl:variable name="leftOfRef">
        <xsl:choose>
            <xsl:when test="$escapedVarRef">
                <xsl:value-of select="substring($tempLeftOfRef,1,string-length($tempLeftOfRef)-1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$tempLeftOfRef"/>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:variable>
	<!-- rest of variable reference symbol char -->
	<xsl:variable name="restOfRef" select="substring-after($srcString, $varRefChar)"/>
	<xsl:variable name="varName">
        <xsl:choose>
            <xsl:when test="$escapedVarRef">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
        		<xsl:call-template name="getToken">
        			<xsl:with-param name="srcString" select="$restOfRef"/>
        			<xsl:with-param name="delimChar" select="$defaultDelimChar"/>
        		</xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:variable>
	
	<!-- variable value -->
	<xsl:variable name="varValue">
        <xsl:choose>
            <xsl:when test="$escapedVarRef">
                <xsl:value-of select="$varRefChar"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ahf:getVarValue($varName)"/>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:variable>
	
	<!-- rest string of variable reference -->
	<xsl:variable name="restOfVarRef">
		<xsl:choose>
			<xsl:when test="contains(substring-after($restOfRef, $varName), $varRefChar)">
				<xsl:call-template name="expandVarRef">
					<xsl:with-param name="srcString" select="substring-after($restOfRef, $varName)"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="substring-after($restOfRef, $varName)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- expand result -->
	<xsl:value-of select="$leftOfRef"/>
	<xsl:value-of select="$varValue"/>
	<xsl:value-of select="$restOfVarRef"/>
</xsl:template>

<!-- get token using delimiter characters -->
<xsl:template name="getToken">
	<xsl:param name="srcString" required="yes" as="xs:string"/>
	<xsl:param name="delimChar" required="yes" as="xs:string"/>
	
	<xsl:variable name="firstChar" select="substring($srcString, 1, 1)"/>
	<xsl:variable name="restString" select="substring($srcString, 2, string-length($srcString) - 1)"/>
	
	<xsl:choose>
		<xsl:when test="string-length($srcString) = 0">
			<xsl:value-of select="''"/>
		</xsl:when>
		<xsl:when test="contains($delimChar, $firstChar)">
			<xsl:value-of select="''"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$firstChar"/>
			<xsl:call-template name="getToken">
				<xsl:with-param name="srcString" select="$restString"/>
				<xsl:with-param name="delimChar" select="$delimChar"/>
			</xsl:call-template>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- expand CSS style reference -->
<xsl:template name="expandCssStyleRef">
	<xsl:param name="prmAttrSetName" required="yes" as="xs:string"/>
	
	<!-- left of variable reference symbol char -->
	<xsl:variable name="tempLeftOfRef" select="substring-before($prmAttrSetName, $styleRefChar)"/>
    <xsl:variable name="escapedStyleRef" select="ends-with($tempLeftOfRef, $varRefEscapeChar)"/>
    <xsl:variable name="leftOfRef">
        <xsl:choose>
            <xsl:when test="$escapedStyleRef">
                <xsl:value-of select="substring($tempLeftOfRef,1,string-length($tempLeftOfRef)-1)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$tempLeftOfRef"/>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:variable>
	<!-- rest of variable reference symbol char -->
	<xsl:variable name="restOfRef" select="substring-after($prmAttrSetName, $styleRefChar)"/>
	<xsl:variable name="styleName">
        <xsl:choose>
            <xsl:when test="$escapedStyleRef">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
        		<xsl:call-template name="getToken">
        			<xsl:with-param name="srcString" select="$restOfRef"/>
        			<xsl:with-param name="delimChar" select="$defaultDelimChar"/>
        		</xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:variable>
	
	<!-- CSS style value -->
	<xsl:variable name="styleValue">
        <xsl:choose>
            <xsl:when test="$escapedStyleRef">
                <xsl:value-of select="$styleRefChar"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="ahf:getCssStyle($styleName)"/>
            </xsl:otherwise>
        </xsl:choose>
	</xsl:variable>
	
	<!-- rest string of variable reference -->
	<xsl:variable name="restOfStyleRef">
		<xsl:choose>
			<xsl:when test="contains(substring-after($restOfRef, $styleName), $styleRefChar)">
				<xsl:call-template name="expandCssStyleRef">
					<xsl:with-param name="prmAttrSetName" select="substring-after($restOfRef, $styleName)"/>
				</xsl:call-template>
			</xsl:when>
            <xsl:when test="false()"/>
			<xsl:otherwise>
				<xsl:value-of select="substring-after($restOfRef, $styleName)"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:variable>

	<!-- expand result -->
	<xsl:value-of select="$leftOfRef"/>
	<xsl:value-of select="$styleValue"/>
	<xsl:value-of select="$restOfStyleRef"/>
</xsl:template>


<!--
	=========================================
			Debug routine
	=========================================
 -->
<xsl:template name="stlyeDump">
	<xsl:message>[styleDump] Variables</xsl:message>
	<xsl:for-each select="$glVarDefs/*">
		<xsl:message>  variable name="<xsl:value-of select="name()"/>" value="<xsl:value-of select="text()"/>"</xsl:message>
	</xsl:for-each>
	
	<xsl:message>[styleDump] Attribute sets</xsl:message>
	<xsl:for-each select="$glStyleDefs/*">
		<xsl:message>  elelemnt name="<xsl:value-of select="name()"/>"</xsl:message>
		<xsl:for-each select="attribute::node()">
			<xsl:message>    attribute name="<xsl:value-of select="name()"/>" value="<xsl:value-of select="self::node()"/>"</xsl:message>
		</xsl:for-each>
	</xsl:for-each>
</xsl:template>


</xsl:stylesheet>
