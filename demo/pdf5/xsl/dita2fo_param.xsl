<?xml version='1.0' encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Stylesheet parameter and global variables.
Copyright © 2009-2009 Antenna House, Inc. All rights reserved.
Antenna House is a trademark of Antenna House, Inc.
URL    : http://www.antennahouse.com/
E-mail : info@antennahouse.com
****************************************************************
-->
<xsl:stylesheet version="2.0" 
 xmlns:fo="http://www.w3.org/1999/XSL/Format" 
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 exclude-result-prefixes="xs ahf"
>
<!-- Primary style definition file. -->
<xsl:param name="PRM_STYLE_DEF_FILE" select="'../config/default_style.xml'" />

<!-- Second style definition file  : Absolute path or XSL stylesheet relative path -->
<xsl:param name="PRM_ALT_STYLE_DEF_FILE">
    <xsl:variable name="tempAltStyleDefFile" select="concat('../config/', $documentLang, '_style.xml')" as="xs:string"/>
    <xsl:choose>
        <xsl:when test="doc-available($tempAltStyleDefFile)">
            <xsl:value-of select="$tempAltStyleDefFile"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="warningContinue">
                <xsl:with-param name="prmMes" 
                 select="ahf:replace($stMes102,('%file','%default'),($tempAltStyleDefFile,$styleDefFile))"/>
            </xsl:call-template>
            <xsl:value-of select="''"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:param>

<!-- 
    Assume indexterm/primary/@sortas, secondary/@sortas as pinyin 
    when language is zh-CN. 
  -->
<xsl:param name="PRM_ASSUME_SORTAS_PINYIN" select="$cNo"/>
<xsl:variable name="pAssumeSortasPinyin" select="boolean($PRM_ASSUME_SORTAS_PINYIN=$cYes)" as="xs:boolean"/>

<!-- Make link for index-see or index-see-also
     (CAUTION: It sometimes make invalid FO.)
  -->
<xsl:param name="PRM_MAKE_SEE_LINK" select="$cYes"/>
<xsl:variable name="pMakeSeeLink" select="boolean($PRM_MAKE_SEE_LINK=$cYes)" as="xs:boolean"/>

<!-- Include frontmatter to toc
  -->
<xsl:param name="PRM_INCLUDE_FRONTMATTER_TO_TOC" select="$cNo"/>
<xsl:variable name="pIncludeFrontmatterToToc" select="boolean($PRM_INCLUDE_FRONTMATTER_TO_TOC=$cYes)" as="xs:boolean"/>

<!-- Add numbering prefix to part/chapter title
  -->
<xsl:param name="PRM_ADD_NUMBERING_TITLE_PREFIX" select="$cYes"/>
<xsl:variable name="pAddNumberingTitlePrefix" select="boolean($PRM_ADD_NUMBERING_TITLE_PREFIX=$cYes)" as="xs:boolean"/>

<!-- Add part/chapter to title
 -->
<xsl:param name="PRM_ADD_PART_TO_TITLE" select="$cYes"/>
<xsl:variable name="pAddPartToTitle" select="boolean($PRM_ADD_PART_TO_TITLE=$cYes) and $pAddNumberingTitlePrefix" as="xs:boolean"/>

<!-- Add thmbnail index
  -->
<xsl:param name="PRM_ADD_THUMBNAIL_INDEX" select="$cYes"/>
<xsl:variable name="pAddThumbnailIndex" select="boolean($PRM_ADD_THUMBNAIL_INDEX=$cYes)" as="xs:boolean"/>

<!-- Document language -->
<xsl:param name="PRM_LANG" select="$doubleApos" />

<!-- Output draft-comment -->
<xsl:param name="PRM_OUTPUT_DRAFT_COMMENT" select="$cNo"/>
<xsl:variable name="pOutputDraftComment" select="boolean($PRM_OUTPUT_DRAFT_COMMENT=$cYes)" as="xs:boolean"/>

<!-- Output required-cleanup -->
<xsl:param name="PRM_OUTPUT_REQUIRED_CLEANUP" select="$cNo"/>
<xsl:variable name="pOutputRequiredCleanup" select="boolean($PRM_OUTPUT_REQUIRED_CLEANUP=$cYes)" as="xs:boolean"/>

<!-- Generate unique id in XSL-FO -->
<xsl:param name="PRM_GEN_UNIQUE_ID" select="$cYes"/>
<xsl:variable name="pGenUniqueId" select="boolean($PRM_GEN_UNIQUE_ID=$cYes)" as="xs:boolean"/>

<!-- Format dl as block -->
<xsl:param name="PRM_FORMAT_DL_AS_BLOCK" select="$cYes"/>
<xsl:variable name="pFormatDlAsBlock" select="boolean($PRM_FORMAT_DL_AS_BLOCK=$cYes)" as="xs:boolean"/>

<!-- Honor toc="no" or not -->
<xsl:param name="PRM_APPLY_TOC_ATTR" select="$cYes"/>
<xsl:variable name="pApplyTocAttr" select="boolean($PRM_APPLY_TOC_ATTR=$cYes)" as="xs:boolean"/>

<!-- Online or pre-press PDF -->
<xsl:param name="PRM_ONLINE_PDF" select="$cYes"/>
<xsl:variable name="pOnlinePdf" select="boolean($PRM_ONLINE_PDF=$cYes)" as="xs:boolean"/>


</xsl:stylesheet>
