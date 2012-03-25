<?xml version="1.0" encoding="UTF-8" ?>
<!--
****************************************************************
DITA to XSL-FO Stylesheet
Module: Stylesheet global variables.
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
>
<!-- *************************************** 
        Constants
     ***************************************-->

<!-- External Parameter yes/no value -->
<xsl:variable name="cYes" select="'yes'" as="xs:string"/>
<xsl:variable name="cNo" select="'no'" as="xs:string"/>

<!-- Inner flag/attribute value: true/false -->
<xsl:variable name="true" select="'true'" as="xs:string"/>
<xsl:variable name="false" select="'false'" as="xs:string"/>

<xsl:variable name="NaN" select="'NaN'" as="xs:string"/>
<xsl:variable name="lf" select="'&#x0A;'" as="xs:string"/>
<xsl:variable name="doubleApos" as="xs:string">
	<xsl:text>''</xsl:text>
</xsl:variable>

<xsl:variable name="idSeparator" select="'_'" as="xs:string"/>

<!-- units -->
<xsl:variable name="cUnitPc" select="'pc'" as="xs:string"/>
<xsl:variable name="cUnitPt" select="'pt'" as="xs:string"/>
<xsl:variable name="cUnitPx" select="'px'" as="xs:string"/>
<xsl:variable name="cUnitIn" select="'in'" as="xs:string"/>
<xsl:variable name="cUnitCm" select="'cm'" as="xs:string"/>
<xsl:variable name="cUnitMm" select="'mm'" as="xs:string"/>
<xsl:variable name="cUnitEm" select="'em'" as="xs:string"/>

<!-- Title generation mode
 -->
<xsl:variable name="cRoundBulletTitleMode"   select="1" as="xs:integer"/>
<xsl:variable name="cSquareBulletTitleMode"  select="2" as="xs:integer"/>
<xsl:variable name="cNoRestrictionTitleMode" select="3" as="xs:integer"/>

<!-- *************************************** 
        IDs
     ***************************************-->
<xsl:variable name="cTocId"   select="'__TOC'" as="xs:string"/>
<xsl:variable name="cFigureListId"  select="'__FIGURE_LIST'" as="xs:string"/>
<xsl:variable name="cTableListId"   select="'__TABLE_LIST'" as="xs:string"/>
<xsl:variable name="cIndexId" select="'__INDEX'" as="xs:string"/>

<!-- *************************************** 
        Marker class name
     ***************************************-->
<xsl:variable name="cTitlePrefix" select="'TITLE_PREFIX'" as="xs:string"/>
<xsl:variable name="cTitleBody"   select="'TITLE_BODY'" as="xs:string"/>

<!-- *************************************** 
        Text related variable
     ***************************************-->
<xsl:variable name="cStartIndent"     select="ahf:getVarValue('General_Indent_Value')" as="xs:string"/>
<!-- *************************************** 
        Bookmark related
     ***************************************-->
<!-- common bookmark starting state -->
<xsl:variable name="cStartingState" select="'hide'" as="xs:string"/>
<!-- bookmark nesting level -->
<xsl:variable name="cBookmarkNestMax" select="4" as="xs:integer"/>
<!-- bookmark title separater -->
<xsl:variable name="cTitlePrefixSeparator" select="'.'" as="xs:string"/>

<!-- *************************************** 
        TOC related
     ***************************************-->
<!-- TOC nesting level -->
<xsl:variable name="cTocNestMax" select="4" as="xs:integer"/>

<!-- *************************************** 
        Index related
     ***************************************-->
<xsl:variable name="cIndexSymbolLabel" select="ahf:getVarValue('Index_Symbol_Label')" as="xs:string"/>
<xsl:variable name="cSeePrefixLevel1"  select="ahf:getVarValue('See_Prefix_Level1')" as="xs:string"/>
<xsl:variable name="cSeeSuffixLevel1"  select="ahf:getVarValue('See_Suffix_Level1')" as="xs:string"/>
<xsl:variable name="cSeePrefixLevel2"  select="ahf:getVarValue('See_Prefix_Level2')" as="xs:string"/>
<xsl:variable name="cSeeSuffixLevel2"  select="ahf:getVarValue('See_Suffix_Level2')" as="xs:string"/>

<!-- Index See Also prefix and suffix -->
<xsl:variable name="cSeeAlsoPrefix" select="ahf:getVarValue('See_Also_Prefix')" as="xs:string"/>
<xsl:variable name="cSeeAlsoSuffix" select="ahf:getVarValue('See_Also_Suffix')" as="xs:string"/>

<!-- Index page citation -->
<xsl:variable name="cIndexPageCitationListSeparator" select="ahf:getVarValue('Index_Page_Citation_List_Separator')" as="xs:string"/>
<xsl:variable name="cIndexPageCitationRangeSeparator" select="ahf:getVarValue('Index_Page_Citation_Range_Separator')" as="xs:string"/>

<!-- *************************************** 
     Words which doe not depend on language
     ***************************************-->
<!-- Table caption separater -->
<xsl:variable name="cTitleSeparator" select="'-'" as="xs:string"/>

<!-- *************************************** 
        Words depending on language
     ***************************************-->
<xsl:variable name="cPartTitlePrefix"  select="ahf:getVarValue('Part_Title_Prefix')" as="xs:string"/>
<xsl:variable name="cPartTitleSuffix"  select="ahf:getVarValue('Part_Title_Suffix')" as="xs:string"/>
<xsl:variable name="cChapterTitlePrefix"  select="ahf:getVarValue('Chapter_Title_Prefix')" as="xs:string"/>
<xsl:variable name="cChapterTitleSuffix"  select="ahf:getVarValue('Chapter_Title_Suffix')" as="xs:string"/>


<xsl:variable name="cTocTitle"         select="ahf:getVarValue('Toc_Title')" as="xs:string"/>
<xsl:variable name="cFigureListTitle"  select="ahf:getVarValue('Figure_List_Title')" as="xs:string"/>
<xsl:variable name="cTableListTitle"   select="ahf:getVarValue('Table_List_Title')" as="xs:string"/>
<xsl:variable name="cAppendixTitle"    select="ahf:getVarValue('Appendix_Title')" as="xs:string"/>
<xsl:variable name="cIndexTitle"       select="ahf:getVarValue('Index_Title')" as="xs:string"/>
<xsl:variable name="cNoticeTitle"      select="ahf:getVarValue('Notice_Title')" as="xs:string"/>
<xsl:variable name="cPrefaceTitle"     select="ahf:getVarValue('Preface_Title')" as="xs:string"/>

<xsl:variable name="cBlankPageTitle"   select="ahf:getVarValue('Blank_Page_Title')" as="xs:string"/>

<xsl:variable name="cTableTitle"       select="ahf:getVarValue('Table_Title')" as="xs:string"/>
<xsl:variable name="cFigureTitle"      select="ahf:getVarValue('Figure_Title')" as="xs:string"/>


<!-- ************************************************ 
        Thumbnail label & title
     ************************************************-->
<xsl:variable name="cTocThumbnailLabel"   select="ahf:getVarValue('Toc_Thumbnail_Label')" as="xs:string"/>
<xsl:variable name="cAppendixThumbnailLabel" select="ahf:getVarValue('Appendix_Thumbnail_Label')" as="xs:string"/>
<xsl:variable name="cIndexThumbnailLabel" select="ahf:getVarValue('Index_Thumbnail_Label')" as="xs:string"/>

<xsl:variable name="cTocThumbnailTitle"   select="ahf:getVarValue('Toc_Thumbnail_Title')" as="xs:string"/>
<xsl:variable name="cAppendixThumbnailTitle" select="ahf:getVarValue('Appendix_Thumbnail_Title')" as="xs:string"/>
<xsl:variable name="cIndexThumbnailTitle" select="ahf:getVarValue('Index_Thumbnail_Title')" as="xs:string"/>

<xsl:variable name="cThumbIndexMax"       select="ahf:getVarValue('Thumbnail_Index_Max')" as="xs:string"/>


<!-- *************************************** 
        Bullet character        
     ***************************************-->
<xsl:variable name="cUlLabelChar"      select="ahf:getVarValue('Ul_Label_Char')" as="xs:string"/>
<xsl:variable name="cLevel4LabelChar"  select="ahf:getVarValue('Level4_Label_Char')" as="xs:string"/>
<xsl:variable name="cLevel5LabelChar"  select="ahf:getVarValue('Level5_Label_Char')" as="xs:string"/>

<!-- *************************************** 
        Userinterface 
     ***************************************-->
<xsl:variable name="cMenuCascadeSymbol"  select="ahf:getVarValue('MenuCascade_Symbol')" as="xs:string"/>
<xsl:variable name="cUiControlPrefix"    select="ahf:getVarValue('UiControl_Prefix')" as="xs:string"/>
<xsl:variable name="cUiControlSuffix"    select="ahf:getVarValue('UiControl_Suffix')" as="xs:string"/>


<!-- *************************************** 
        Related-links variable
     ***************************************-->
<xsl:variable name="cRelatedlinkPrefix"     select="ahf:getVarValue('Relatedlink_Prefix')" as="xs:string"/>
<xsl:variable name="cRelatedlinkSuffix"     select="ahf:getVarValue('Relatedlink_Suffix')" as="xs:string"/>
<xsl:variable name="cBulletFont"            select="ahf:getVarValue('General_Bullet_Font')" as="xs:string"/>
<xsl:variable name="cDeadLinkPDF"           select="ahf:getVarValue('Dead_Link_PDF')" as="xs:string"/>
<xsl:variable name="cDeadLinkColor"         select="ahf:getVarValue('Dead_Link_Color')" as="xs:string"/>

<!-- *************************************** 
        Xref 
     ***************************************-->
<xsl:variable name="cXrefPrefix"            select="ahf:getVarValue('Xref_Prefix')" as="xs:string"/>
<xsl:variable name="cXrefSuffix"            select="ahf:getVarValue('Xref_Suffix')" as="xs:string"/>

<!-- *************************************** 
        Choicetable header literal
     ***************************************-->
<xsl:variable name="cChoptionhd"            select="ahf:getVarValue('Choptionhd')" as="xs:string"/>
<xsl:variable name="cChdeschd"              select="ahf:getVarValue('Chdeschd')" as="xs:string"/>

<!-- *************************************** 
        Footnote
     ***************************************-->
<xsl:variable name="cFootnoteTagPrefix"     select="ahf:getVarValue('Footnote_Tag_Prefix')" as="xs:string"/>
<xsl:variable name="cFootnoteTagSuffix"     select="ahf:getVarValue('Footnote_Tag_Suffix')" as="xs:string"/>

<!-- *************************************** 
        Formatting Variables
     ***************************************-->
<!-- Prefix of ol -->
<xsl:variable name="olNumberFormat" as="xs:string*">
    <xsl:variable name="olNumberFormats" select="ahf:getVarValue('Ol_Number_Formats')" as="xs:string"/>
    <xsl:for-each select="tokenize($olNumberFormats, '[\s]+')">
        <xsl:sequence select="."/>
    </xsl:for-each>
</xsl:variable>
<xsl:variable name="olNumberFormatCount" select="count($olNumberFormat)" as="xs:integer"/>

<!-- *************************************** 
        Variables depending on document
     ***************************************-->
<!-- Top level element -->
<xsl:variable name="root" select="/*[1]" as="element()"/>
<xsl:variable name="rootId" select="generate-id($root)" as="xs:string"/>
<xsl:variable name="map" select="$root/*[contains(@class,' map/map ')][1]" as="element()"/>
<xsl:variable name="lastTopicRef" select="$map/descendant::*[contains(@class,' map/topicref ')][@href][position()=last()]"/>

<!-- Map class -->
<xsl:variable name="classMap" select="'map'" as="xs:string"/>
<xsl:variable name="classBookMap" select="'bookmap'" as="xs:string"/>
<xsl:variable name="classUnknown" select="'unknown'" as="xs:string"/>
<xsl:variable name="ditamapClass" as="xs:string">
    <xsl:choose>
        <xsl:when test="$root/*[1][contains(@class,' map/map')][contains(@class,' bookmap/bookmap')]">
            <xsl:value-of select="$classBookMap"/>
        </xsl:when>
        <xsl:when test="$root/*[1][@class='- map/map ']">
            <xsl:value-of select="$classMap"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="errorExit">
                <xsl:with-param name="prmMes">
                    <xsl:value-of select="ahf:replace($stMes100,('%class','%file'),($root/*[1]/@class,$root/*[1]/@xtrf))"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<xsl:variable name="isMap"     select="boolean($ditamapClass=$classMap)" as="xs:boolean"/>
<xsl:variable name="isBookMap" select="boolean($ditamapClass=$classBookMap)" as="xs:boolean"/>

<!-- Document language -->
<xsl:variable name="defaultLang" select="'en'" as="xs:string"/>
<xsl:variable name="documentLang" as="xs:string">
    <xsl:choose>
        <xsl:when test="string($PRM_LANG) and ($PRM_LANG != $doubleApos)">
            <xsl:value-of select="$PRM_LANG"/>
        </xsl:when>
        <xsl:when test="$root/*[1]/@xml:lang">
            <xsl:value-of select="$root/*[1]/@xml:lang"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:call-template name="warningContinue">
                <xsl:with-param name="prmMes">
                    <xsl:value-of select="$stMes101"/>
                </xsl:with-param>
            </xsl:call-template>
            <xsl:value-of select="$defaultLang"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<!-- Part existence (bookmap only) -->
<xsl:variable name="isPartExist" select="boolean($root/*[1][contains(@class, ' bookmap/bookmap ')]/*[contains(@class, ' bookmap/part ')])" as="xs:boolean"/>

<!-- Chapter existence (bookmap only) -->
<xsl:variable name="isChapterExist" select="boolean($root/*[1][contains(@class, ' bookmap/bookmap ')]/*[contains(@class, ' bookmap/chapter ')])" as="xs:boolean"/>

<!-- Keys -->
<!-- topic content by id (topics that is referenced from topicref only)-->
<xsl:key name="topicById" match="/*//*[contains(@class, ' topic/topic')]" use="@id"/>
<!--topicref by href -->
<xsl:key name="topicrefByHref" match="/*/*[contains(@class, ' map/map ')]
                                  //*[contains(@class, ' map/topicref ')]
                                     [not(ancestor::*[contains(@class, ' map/reltable ')])]"
                          use="@href"/>

<!-- Elements by id -->
<xsl:key name="elementById" match="//*[@id]" use="@id"/>

<!-- Elements by oid -->
<xsl:key name="elementByOid" match="//*[@oid]" use="@oid"/>


<!-- *************************************** 
        Document variables
     ***************************************-->
<!-- Book library -->
<xsl:variable name="bookLibrary" as="node()*">
    <xsl:choose>
        <xsl:when test="$isMap">
            <xsl:sequence select="()"/>
        </xsl:when>
        <xsl:when test="$isBookMap">
            <xsl:apply-templates select="$root/*[contains(@class, ' bookmap/bookmap ')]/*[contains(@class, ' bookmap/booktitle ')]/*[contains(@class, ' bookmap/booklibrary ')]">
                <xsl:with-param name="prmTopicRef" select="()"/>
                <xsl:with-param name="prmNeedId"   select="false()"/>
                <xsl:with-param name="prmMakeCover" tunnel="yes" select="true()"/>
            </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="'&lt; Dummy Book Library &gt;'"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<!-- Title -->
<xsl:variable name="bookTitle" as="node()*">
    <xsl:choose>
        <xsl:when test="$isMap">
            <xsl:choose>
                <xsl:when test="$root/*[contains(@class, ' map/map ')]/*[contains(@class, ' topic/title ')]">
                    <xsl:apply-templates select="$root/*[contains(@class, ' map/map ')]/*[contains(@class, ' topic/title ')]" >
                        <xsl:with-param name="prmTopicRef" select="()"/>
                        <xsl:with-param name="prmNeedId"   select="false()"/>
                        <xsl:with-param name="prmMakeCover" tunnel="yes" select="true()"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:when test="$root/*[contains(@class, ' map/map ')]/@title">
                    <fo:inline>
                        <xsl:value-of select="$root/*[contains(@class, ' map/map ')]/@title"/>
                    </fo:inline>
                </xsl:when>
                <xsl:otherwise>
                    <fo:inline/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:when test="$isBookMap">
            <xsl:choose>
                <xsl:when test="$root/*[contains(@class, ' bookmap/bookmap ')]/*[contains(@class, ' bookmap/booktitle ')]">
                    <xsl:apply-templates select="$root/*[contains(@class, ' bookmap/bookmap ')]/*[contains(@class, ' bookmap/booktitle ')]/*[contains(@class, ' bookmap/mainbooktitle ')]">
                        <xsl:with-param name="prmTopicRef" select="()"/>
                        <xsl:with-param name="prmNeedId"   select="false()"/>
                        <xsl:with-param name="prmMakeCover" tunnel="yes" select="true()"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$root/*[contains(@class, ' bookmap/bookmap ')]/*[contains(@class, ' topic/title ')]">
                        <xsl:with-param name="prmTopicRef" select="()"/>
                        <xsl:with-param name="prmNeedId"   select="false()"/>
                        <xsl:with-param name="prmMakeCover" tunnel="yes" select="true()"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
            <fo:inline>
                <xsl:value-of select="'&lt; Dummy Book Title &gt;'"/>
            </fo:inline>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<!-- Alt Title -->
<xsl:variable name="bookAltTitle" as="node()*">
    <xsl:choose>
        <xsl:when test="$isMap">
            <xsl:sequence select="()"/>
        </xsl:when>
        <xsl:when test="$isBookMap">
            <xsl:apply-templates select="$root/*[contains(@class, ' bookmap/bookmap ')]/*[contains(@class, ' bookmap/booktitle ')]/*[contains(@class, ' bookmap/booktitlealt ')]">
                <xsl:with-param name="prmTopicRef" select="()"/>
                <xsl:with-param name="prmNeedId"   select="false()"/>
                <xsl:with-param name="prmMakeCover" tunnel="yes" select="true()"/>
            </xsl:apply-templates>
        </xsl:when>
        <xsl:otherwise>
            <xsl:value-of select="'&lt; Dummy Alt Book Title &gt;'"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

<!-- *************************************** 
        Style definition file
     ***************************************-->
<xsl:variable name="styleDefFile" select="ahf:bsToSlash($PRM_STYLE_DEF_FILE)" as="xs:string"/>
<xsl:variable name="altStyleDefFile" select="if (string($PRM_ALT_STYLE_DEF_FILE)) then ahf:bsToSlash($PRM_ALT_STYLE_DEF_FILE) else ''" as="xs:string"/>

<!-- For message -->
<xsl:variable name="allStyleDefFile" as="xs:string">
    <xsl:choose>
        <xsl:when test="not(string($altStyleDefFile))">
            <xsl:sequence select="$styleDefFile"/>
        </xsl:when>
        <xsl:otherwise>
            <xsl:sequence select="concat($styleDefFile, ' and ',$altStyleDefFile)"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:variable>

</xsl:stylesheet>
