<?xml version='1.0' encoding="UTF-8" ?>
<xsl:stylesheet version="2.0" 
 xmlns:fo="http://www.w3.org/1999/XSL/Format" 
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:xs="http://www.w3.org/2001/XMLSchema"
 xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
 xmlns:ahf="http://www.antennahouse.com/names/XSLT/Functions/Document"
 exclude-result-prefixes="ahf" 
>

    <xsl:template name="frontmatterBeforeLeft">
        <fo:block>
            <!-- confidentiality -->
            <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionBeforeLeftBlock')"/>
            <xsl:attribute name="color">red</xsl:attribute>
            機密
        </fo:block>
    </xsl:template>

    <xsl:template name="chapterBeforeLeft">
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionBeforeLeftBlock')"/>
            <xsl:attribute name="color">red</xsl:attribute>
            機密
        </fo:block>
    </xsl:template>

    <xsl:template name="indexBeforeLeft">
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionBeforeLeftBlock')"/>
            <xsl:attribute name="color">red</xsl:attribute>
            機密
        </fo:block>
    </xsl:template>

    <xsl:template name="backmatterBeforeLeft">
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionBeforeLeftBlock')"/>
            <xsl:attribute name="color">red</xsl:attribute>
            機密
        </fo:block>
    </xsl:template>

    <xsl:template name="frontmatterAfterLeft">
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionAfterLeftBlock')"/>
            <fo:inline>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </fo:inline>
            <fo:inline-container>
                <xsl:copy-of select="ahf:getAttributeSet('atsFrontmatterRegionAfter_InlineContainer')"/>
                <xsl:if test="$pPdfFormatterFop">
	            <fo:block/>
                </xsl:if>
            </fo:inline-container>
            <!-- Book title -->
            <xsl:copy-of select="$bookTitle"/>
            <fo:inline padding-left="1mm">
                Rev.<xsl:value-of select="//*[contains(@class, ' map/map ')]/@rev"/>
            </fo:inline>
        </fo:block>
    </xsl:template>

    <xsl:template name="chapterAfterLeft">
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionAfterLeftBlock')"/>
            <fo:inline>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </fo:inline>
            <fo:inline-container>
                <xsl:copy-of select="ahf:getAttributeSet('atsChapterRegionAfter_InlineContainer')"/>
                <xsl:if test="$pPdfFormatterFop">
	            <fo:block/>
                </xsl:if>
            </fo:inline-container>
            <!-- Book title -->
            <xsl:copy-of select="$bookTitle"/>
            <fo:inline padding-left="1mm">
                Rev.<xsl:value-of select="//*[contains(@class, ' map/map ')]/@rev"/>
            </fo:inline>
        </fo:block>
    </xsl:template>

    <xsl:template name="indexAfterLeft">
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionAfterLeftBlock')"/>
            <fo:inline>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </fo:inline>
            <fo:inline-container>
                <xsl:copy-of select="ahf:getAttributeSet('atsIndexRegionAfter_InlineContainer')"/>
                <xsl:if test="$pPdfFormatterFop">
	            <fo:block/>
                </xsl:if>
            </fo:inline-container>
            <!-- Book title -->
            <xsl:copy-of select="$bookTitle"/>
            <fo:inline padding-left="1mm">
                Rev.<xsl:value-of select="//*[contains(@class, ' map/map ')]/@rev"/>
            </fo:inline>
        </fo:block>
    </xsl:template>

    <xsl:template name="backmatterAfterLeft">
        <fo:block>
            <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionAfterLeftBlock')"/>
            <fo:inline>
                <xsl:copy-of select="ahf:getAttributeSet('atsPageNumber')"/>
                <fo:page-number/>
            </fo:inline>
            <fo:inline-container>
                <xsl:copy-of select="ahf:getAttributeSet('atsBackmatterRegionAfter_InlineContainer')"/>
                <xsl:if test="$pPdfFormatterFop">
	            <fo:block/>
                </xsl:if>
            </fo:inline-container>
            <!-- Book title -->
            <xsl:copy-of select="$bookTitle"/>
            <fo:inline padding-left="1mm">
                Rev.<xsl:value-of select="//*[contains(@class, ' map/map ')]/@rev"/>
            </fo:inline>
        </fo:block>
    </xsl:template>

    <xsl:template name="genCover">
        <fo:page-sequence master-reference="pmsPageSeqCover">
            <xsl:choose>
                <xsl:when test="$pOnlinePdf">
                    <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqBaseOnline')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqBase')"/>
                </xsl:otherwise>
            </xsl:choose>
            <fo:static-content flow-name="xsl-region-before">
                <xsl:attribute name="margin-top">25.4mm</xsl:attribute>
                <xsl:attribute name="margin-left">31.7mm</xsl:attribute>
                <xsl:attribute name="margin-right">31.7mm</xsl:attribute>
                <fo:block>
                    <fo:inline font-size="large" color="red">
                        機密
                    </fo:inline>
                </fo:block>
            </fo:static-content>
            <fo:flow flow-name="xsl-region-body">
                <fo:block-container>
                    <xsl:copy-of select="ahf:getAttributeSet('atsCoverBookTitleBC')"/>
                    <xsl:if test="exists($bookLibrary)">
                        <fo:block>
                            <xsl:copy-of select="ahf:getAttributeSet('atsCoverBookLibrary')"/>
                            <xsl:copy-of select="$bookLibrary"/>
                        </fo:block>
                    </xsl:if>
                    <fo:block>
                        <xsl:copy-of select="ahf:getAttributeSet('atsCoverBookTitle')"/>
                        <xsl:copy-of select="$bookTitle"/>
                        <fo:inline padding-left="1mm">
                            Rev.<xsl:value-of select="//*[contains(@class, ' map/map ')]/@rev"/>
                        </fo:inline>
                    </fo:block>
                    <xsl:if test="exists($bookAltTitle)">
                        <fo:block>
                            <xsl:copy-of select="ahf:getAttributeSet('atsCoverAltBookTitle')"/>
                            <xsl:copy-of select="$bookAltTitle"/>
                        </fo:block>
                    </xsl:if>
                </fo:block-container>
                <fo:block-container>
                    <xsl:copy-of select="ahf:getAttributeSet('atsCoverBookMetaBC')"/>
                    <fo:block>
                        <xsl:copy-of select="ahf:getAttributeSet('atsCoverBookMeta')"/>
                        <xsl:apply-templates select="$map//*[contains(@class,' bookmap/bookmeta ')]" mode="cover"/>
                    </fo:block>
                    <xsl:if test="$isMap">
                        <fo:block>
		            <xsl:copy-of select="ahf:getAttributeSet('atsCoverBookMeta')"/>
		            <xsl:value-of select="(//*/publisher)[1]"/>
		        </fo:block>
		        <fo:block>
		            <xsl:copy-of select="ahf:getAttributeSet('atsCoverBookMeta')"/>
		            <xsl:value-of select="(//*/author)[1]"/>
		        </fo:block>
                    </xsl:if>
                </fo:block-container>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <xsl:template name="processChapterMain">
        <fo:page-sequence>
            <xsl:choose>
                <xsl:when test="$pOnlinePdf">
                    <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqChapterOnline')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:copy-of select="ahf:getAttributeSet('atsPageSeqChapter')"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="preceding-sibling::*[contains(@class, ' bookmap/chapter ')] or preceding-sibling::*[contains(@class, ' bookmap/part ')]">
                <xsl:attribute name="initial-page-number" select="auto-odd"/>
            </xsl:if>
            <xsl:if test="$isMap">
                <xsl:attribute name="initial-page-number" select="auto-odd"/>
                <xsl:attribute name="force-page-count" select="auto"/>
            </xsl:if>
            <fo:static-content flow-name="rgnChapterBeforeLeft">
                <xsl:call-template name="chapterBeforeLeft"/>
            </fo:static-content>
            <fo:static-content flow-name="rgnChapterBeforeRight">
                <xsl:call-template name="chapterBeforeRight"/>
            </fo:static-content>
            <fo:static-content flow-name="rgnChapterAfterLeft">
                <xsl:call-template name="chapterAfterLeft"/>
            </fo:static-content>
            <fo:static-content flow-name="rgnChapterAfterRight">
                <xsl:call-template name="chapterAfterRight"/>
            </fo:static-content>
            <fo:static-content flow-name="rgnChapterEndRight">
                <xsl:call-template name="chapterEndRight"/>
            </fo:static-content>
            <xsl:if test="$pPdfFormatterAh">
                <fo:static-content flow-name="rgnChapterBlankBody">
                    <xsl:call-template name="makeBlankBlock"/>
                </fo:static-content>
            </xsl:if>
            <fo:flow flow-name="xsl-region-body">
                <xsl:apply-templates select="." mode="PROCESS_TOPICREF"/>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>
</xsl:stylesheet>
