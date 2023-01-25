<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://www.loc.gov/mods/v3" xmlns:f="http://functions"
    xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:marccountry="http://www.local.gov/marc/countries"
    xmlns:nalsubcat="http://nal-subject-category-codes" xmlns:saxon="http://saxon.sf.net/"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="f marc marccountry nalsubcat saxon xd xlink xs xsi">

    <!-- includes -->

    <xsl:include href="NAL-MARC21slimUtils.xsl"/>
    <xsl:include href="commons/functions.xsl"/>
    <xsl:include href="commons/params.xsl"/>

    <!-- outputs -->
    <xsl:output encoding="UTF-8" indent="yes" method="xml" name="original"
        saxon:next-in-chain="fix_characters.xsl"/>

    <!-- whitespace control -->
    <xsl:strip-space elements="*"/>

    <!-- Maintenance note: For each revision, change the content of &lt;recordInfo&gt;&lt;recordOrigin&gt; to reflect the new revision number.
			MARC21slim2MODS3-4 (Revision 1.98) 20141216
		
			Revision 2.13 - added if test to prevent extra whitespace. 2022/12/23 cm3
			Revision 2.12 - added conditional statement above issuance to focus on monographs, single part items and multipart monographs cm3 12/08/2022
	        Revision 2.11 - added condtional statement if agid:# is empty from 773, use 914 subfield a cm3 12/09/2022
	        Revision 2.10 - added condtional statement if ISSN is empty from 773, use 914 subfield b cm3 12/09/2022
    		Revision 2.09 - added custom function to map Category Code to Subject. cm3 2022/12/08
    		Revision 2.08 - Commented out condiontal statements within issuance element for serials, contininuing resources, and integrating resources. cm3 2022/12/08	
            Revision 2.07 - used substring-before function to get subfield b (ie., publisher) and subfield c (i.e., dateIssued). cm3 2022/12/08
			Revision 2.06 - added conditional statement outside of issuance element to allow monographs, multipart monographs, and single items only. cm3 2022/12/08 
			Revision 2.05 - controlField008-35-37replace, uses replace function and regex to capture 3 letter string. cm3 2022/12/05
			Revision 2.04 - updated recordOrigin to reflect the XSLT filename used in transform. cm3 2022/12/08
			Revision 2.03 - Added if tests to originInfo producer elements to avoid empty tag cm3 2022/11/10
			Revision 2.02 - used analyze-string function 008 to pull out 2-3 letter text and apply custom marc country conversion function
			Revision 2.01 - Removed marc: prefix from XSLT to accomodate prefix-less elements from Alma 
			Revision 2.00 - Upgraded stylesheet to use XSLT 2.0 cm3 2022/10/05 
			Revision 1.99 - Fixed dateIssued to include year only date from the 008  JG 2014/12/16
			Revision 1.98 - Fixed dateIssued to include month and date from the 008  JG 2014/08/18
			Revision 1.97 - Added displayForm to 700 JG 2014/05/29
			Revision 1.96 - Added subject from 072, classification from 070, identifier from 024, identifier from 001, and notes from 910, 930, 945, 946, 974 LC 2014/04/23
		┌ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ┐ 
		│   NAL Revisions   │  
		└ ━ ━ ━ ━ ━ ━ ━ ━ ━ ━ ┘ 
			Revision 1.95 - Added a xsl:when to deal with '#' and ' ' in $marcLeader19 and $controlField008-18 - ws 2014/12/19
			Revision 1.94 - Leader 07 b mapping changed from "continuing" to "serial" tmee 2014/02/21
			Revision 1.93 - Fixed personal name transform for ind1=0 tmee 2014/01/31
			Revision 1.92 - Removed duplicate code for 856 1.51 tmee tmee 2014/01/31
			Revision 1.91 - Fixed createnameFrom720 duplication tmee tmee 2014/01/31
			Revision 1.90 - Fixed 520 displayLabel tmee tmee 2014/01/31
			Revision 1.89 - Fixed 008-06 when value = 's' for cartographics tmee tmee 2014/01/31
			Revision 1.88 - Fixed 510c mapping - tmee 2013/08/29
			Revision 1.87 - Fixed expressions of &lt;accessCondition&gt; type values - tmee 2013/08/29
			Revision 1.86 - Fixed 008 &lt;frequency&gt; subfield to occur w/i &lt;originiInfo&gt; - tmee 2013/08/29
			Revision 1.85 - Fixed 245 $c - tmee 2013/03/07
			Revision 1.84 - Fixed 1.35 and 1.36 date mapping for 008 when 008/06=e,p,r,s,t so only 008/07-10 displays, rather than 008/07-14 - tmee 2013/02/01
			Revision 1.83 - Deleted mapping for 534 to note - tmee 2013/01/18
			Revision 1.82 - Added mapping for 264 ind 0,1,2,3 to originInfo - 2013/01/15 tmee
			Revision 1.81 - Added mapping for 336$a$2, 337$a$2, 338$a$2 - 2012/12/03 tmee
			Revision 1.80 - Added 100/700 mapping for "family" - 2012/09/10 tmee
			Revision 1.79 - Added 245 $s mapping - 2012/07/11 tmee
			Revision 1.78 - Fixed 852 mapping &lt;shelfLocation&gt; was changed to &lt;shelfLocator&gt; - 2012/05/07 tmee
			Revision 1.77 - Fixed 008-06 when value = 's' - 2012/04/19 tmee
			Revision 1.76 - Fixed 242 - 2012/02/01 tmee
			Revision 1.75 - Fixed 653 - 2012/01/31 tmee
			Revision 1.74 - Fixed 510 note - 2011/07/15 tmee
			Revision 1.73 - Fixed 506 540 - 2011/07/11 tmee
			Revision 1.72 - Fixed frequency error - 2011/07/07 and 2011/07/14 tmee
			Revision 1.71 - Fixed subject titles for subfields t - 2011/04/26 tmee
			Revision 1.70 - Added mapping for OCLC numbers in 035s to go into &lt;identifier type="oclc"&gt; 2011/02/27 - tmee
			Revision 1.69 - Added mapping for untyped identifiers for 024 - 2011/02/27 tmee
			Revision 1.68 - Added &lt;subject&gt;&lt;titleInfo&gt; mapping for 600/610/611 subfields t,p,n - 2010/12/22 tmee
			Revision 1.67 - Added frequency values and authority="marcfrequency" for 008/18 - 2010/12/09 tmee
			Revision 1.66 - Fixed 008/06=c,d,i,m,k,u, from dateCreated to dateIssued - 2010/12/06 tmee
			Revision 1.65 - Added back marcsmd and marccategory for 007 cr- 2010/12/06 tmee
			Revision 1.64 - Fixed identifiers - removed isInvalid template - 2010/12/06 tmee
			Revision 1.63 - Fixed descriptiveStandard value from aacr2 to aacr - 2010/12/06 tmee
			Revision 1.62 - Fixed date mapping for 008/06=e,p,r,s,t - 2010/12/01 tmee
			Revision 1.61 - Added 007 mappings for marccategory - 2010/11/12 tmee
			Revision 1.60 - Added altRepGroups and 880 linkages for relevant fields, see mapping - 2010/11/26 tmee
			Revision 1.59 - Added scriptTerm type=text to language for 546b and 066c - 2010/09/23 tmee
			Revision 1.58 - Expanded script template to include code conversions for extended scripts - 2010/09/22 tmee
			Revision 1.57 - Added Ldr/07 and Ldr/19 mappings - 2010/09/17 tmee
			Revision 1.56 - Mapped 1xx usage="primary" - 2010/09/17 tmee
			Revision 1.55 - Mapped UT 240/1xx nameTitleGroup - 2010/09/17 tmee
		┌ ━ ━ ━ ━ ━ ┐ 
		│ MODS 3.4 │  
		└ ━ ━ ━ ━ ━ ┘
			Revision 1.54 - Fixed 086 redundancy - 2010/07/27 tmee
			Revision 1.53 - Added direct href for MARC21slimUtils - 2010/07/27 tmee
			Revision 1.52 - Mapped 046 subfields c,e,k,l - 2010/04/09 tmee
			Revision 1.51 - Corrected 856 transform - 2010/01/29 tmee
			Revision 1.50 - Added 210 $2 authority attribute in &lt;titleInfo type=”abbreviated”&gt; 2009/11/23 tmee
			Revision 1.49 - Aquifer revision 1.14 - Added 240s (version) data to &lt;titleInfo type="uniform"&gt;&lt;title&gt; 2009/11/23 tmee
			Revision 1.48 - Aquifer revision 1.27 - Added mapping of 242 second indicator (for nonfiling characters) to &lt;titleInfo&gt;&lt;nonSort &gt; subelement  2007/08/08 tmee/dlf
			Revision 1.47 - Aquifer revision 1.26 - Mapped 300 subfield f (type of unit) - and g (size of unit) 2009 ntra
			Revision 1.46 - Aquifer revision 1.25 - Changed mapping of 767 so that &lt;type="otherVersion&gt;  2009/11/20  tmee
			Revision 1.45 - Aquifer revision 1.24 - Changed mapping of 765 so that &lt;type="otherVersion&gt;  2009/11/20  tmee
			Revision 1.44 - Added &lt;recordInfo&gt;&lt;recordOrigin&gt; canned text about the version of this stylesheet 2009 ntra
			Revision 1.43 - Mapped 351 subfields a,b,c 2009/11/20 tmee
			Revision 1.42 - Changed 856 second indicator=1 to go to &lt;location&gt;&lt;url displayLabel=”electronic resource”&gt; instead of to &lt;relatedItem type=”otherVersion”&gt;&lt;url&gt; 2009/11/20 tmee
			Revision 1.41 - Aquifer revision 1.9 Added variable and choice protocol for adding usage=”primary display” 2009/11/19 tmee
			Revision 1.40 - Dropped &lt;note&gt; for 510 and added &lt;relatedItem type="isReferencedBy"&gt; for 510 2009/11/19 tmee
			Revision 1.39 - Aquifer revision 1.23 Changed mapping for 762 (Subseries Entry) from &lt;relatedItem type="series"&gt; to &lt;relatedItem type="constituent"&gt; 2009/11/19 tmee
			Revision 1.38 - Aquifer revision 1.29 Dropped 007s for electronic versions 2009/11/18 tmee
			Revision 1.37 - Fixed date redundancy in output (with questionable dates) 2009/11/16 tmee
			Revision 1.36 - If mss material (Ldr/06=d,p,f,t) map 008 dates and 260$c/$g dates to dateCreated 2009/11/24, otherwise map 008 and 260$c/$g to dateIssued 2010/01/08 tmee
			Revision 1.35 - Mapped appended detailed dates from 008/07-10 and 008/11-14 to dateIssued or DateCreated w/encoding="marc" 2010/01/12 tmee
			Revision 1.34 - Mapped 045b B.C. and C.E. date range info to iso8601-compliant dates in &lt;subject&gt;&lt;temporal&gt; 2009/01/08 ntra
			Revision 1.33 - Mapped Ldr/06 "o" to &lt;typeOfResource&gt;kit 2009/11/16 tmee
			Revision 1.32 - Mapped specific note types from the MODS Note Type list &lt;http://www.loc.gov/standards/mods/mods-notes.html&gt; tmee 2009/11/17
			Revision 1.31 - Mapped 540 to &lt;accessCondition type="use and reproduction"&gt; and 506 to &lt;accessCondition type="restriction on access"&gt; and delete mappings of 540 and 506 to &lt;note&gt;
			Revision 1.30 - Mapped 037c to &lt;identifier displayLabel=""&gt; 2009/11/13 tmee
			Revision 1.29 - Corrected schemaLocation to 3.3 2009/11/13 tmee
			Revision 1.28 - Changed mapping from 752,662 g going to mods:hierarchicalGeographic/area instead of "region" 2009/07/30 ntra
			Revision 1.27 - Mapped 648 to &lt;subject&gt; 2009/03/13 tmee
			Revision 1.26 - Added subfield $s mapping for 130/240/730  2008/10/16 tmee
			Revision 1.25 - Mapped 040e to &lt;descriptiveStandard&gt; and Leader/18 to &lt;descriptive standard&gt;aacr2  2008/09/18 tmee
			Revision 1.24 - Mapped 852 subfields $h, $i, $j, $k, $l, $m, $t to &lt;shelfLocation&gt; and 852 subfield $u to &lt;physicalLocation&gt; with @xlink 2008/09/17 tmee
			Revision 1.23 - Commented out xlink/uri for subfield 0 for 130/240/730, 100/700, 110/710, 111/711 as these are currently unactionable  2008/09/17 tmee
			Revision 1.22 - Mapped 022 subfield $l to type "issn-l" subfield $m to output identifier element with corresponding @type and @invalid eq 'yes'2008/09/17 tmee
			Revision 1.21 - Mapped 856 ind2=1 or ind2=2 to &lt;relatedItem&gt;&lt;location&gt;&lt;url&gt;  2008/07/03 tmee
			Revision 1.20 - Added genre w/@auth="contents of 2" and type= "musical composition"  2008/07/01 tmee
			Revision 1.19 - Added genre offprint for 008/24+ BK code 2  2008/07/01  tmee
			Revision 1.18 - Added xlink/uri for subfield 0 for 130/240/730, 100/700, 110/710, 111/711  2008/06/26 tmee
			Revision 1.17 - Added mapping of 662 2008/05/14 tmee
			Revision 1.16 - Changed @authority from "marc" to "marcgt" for 007 and 008 codes mapped to a term in &lt;genre&gt; 2007/07/10 tmee
			Revision 1.15 - For field 630, moved call to part template outside title element  2007/07/10 tmee
			Revision 1.14 - Fixed template isValid and fields 010, 020, 022, 024, 028, and 037 to output additional identifier elements with corresponding @type and @invalid eq 'yes' when subfields z or y (in the case of 022) exist in the MARCXML ::: 2007/01/04 17:35:20 cred
			Revision 1.13 - Changed order of output under cartographics to reflect schema  2006/11/28 tmee
			Revision 1.12 - Updated to reflect MODS 3.2 Mapping  2006/10/11 tmee
			Revision 1.11 - The attribute objectPart moved from &lt;languageTerm&gt; to &lt;language&gt;  2006/04/08  jrad
			Revision 1.10 - MODS 3.1 revisions to language and classification elements (plus ability to find collection embedded in wrapper elements such as SRU zs: wrappers)  2006/02/06  ggar
			Revision 1.09 - Subfield $y was added to field 242 2004/09/02 10:57 jrad
			Revision 1.08 - Subject chopPunctuation expanded and attribute fixes 2004/08/12 jrad
			Revision 1.07 - 2004/03/25 08:29 jrad
			Revision 1.06 - Various validation fixes 2004/02/20 ntra
			Revision 1.05 - MODS2 to MODS3 updates, language unstacking and de-duping, chopPunctuation expanded  2003/10/02 16:18:58  ntra
			Revision 1.03 - Additional Changes not related to MODS Version 2.0 by ntra
			Revision 1.02 - Added Log Comment  2003/03/24 19:37:42  ckeith
		-->
    <!--href="{replace(saxon:system-id(),'(.*/)(.*)(\.xml)','$1')}N-{replace(saxon:system-id(),'(.*/)(.*)(\.xml)','$2')}_{position()}.xml">-->

    <!--href="file:///{$workingDir}N-{replace($originalFilename,'(.*/)(.*)(\.xml)','$2')}_{position()}.xml">-->

    <xd:doc id="root" scope="stylesheet">
        <xd:desc>Processes the marcRecord template</xd:desc>
    </xd:doc>
    <xsl:template match="/">
        <xsl:result-document encoding="UTF-8" version="1.0" method="xml" media-type="text/xml"
            indent="yes" format="original"
            href="file:///{$workingDir}N-{replace($originalFilename,'(.*/)(.*)(\.xml)','$2')}_{position()}.xml"
            > S <xsl:choose>
                <xsl:when test="//collection/record">
                    <modsCollection xmlns="http://www.loc.gov/mods/v3"
                        xmlns:mods="http://www.loc.gov/mods/v3"
                        xmlns:xlink="http://www.w3.org/1999/xlink"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3">
                        <xsl:for-each select="//collection/record">
                            <mods version="3.4">
                                <xsl:call-template name="marcRecord"/>
                            </mods>
                        </xsl:for-each>
                    </modsCollection>
                </xsl:when>
                <xsl:when test="//record and not(//collection)">
                    <xsl:for-each select="//record">
                        <mods xmlns:xlink="http://www.w3.org/1999/xlink"
                            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                            xmlns="http://www.loc.gov/mods/v3"
                            xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd"
                            version="3.4">
                            <xsl:call-template name="marcRecord"/>
                        </mods>
                    </xsl:for-each>
                </xsl:when>
                <xsl:otherwise>
                    <mods xmlns:xlink="http://www.w3.org/1999/xlink"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                        xmlns="http://www.loc.gov/mods/v3"
                        xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-4.xsd"
                        version="3.4">
                        <xsl:for-each select="//record">
                            <xsl:call-template name="marcRecord"/>
                        </xsl:for-each>
                    </mods>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:result-document>
    </xsl:template>
    <xd:doc id="marcRecord" scope="component">
        <xd:desc>marcRecord</xd:desc>
    </xd:doc>
    <xsl:template name="marcRecord">
        <xsl:variable name="marcLeader" select="leader"/>
        <xsl:variable name="marcLeader6" select="substring($marcLeader, 7, 1)"/>
        <xsl:variable name="marcLeader7" select="substring($marcLeader, 8, 1)"/>
        <xsl:variable name="marcLeader19" select="substring($marcLeader, 20, 1)"/>
        <xsl:variable name="controlField008" select="controlfield[@tag = '008']"/>
        <xsl:variable name="typeOf008">
            <xsl:choose>
                <xsl:when test="$marcLeader6 = 'a'">
                    <xsl:choose>
                        <xsl:when
                            test="$marcLeader7 = 'a' or $marcLeader7 = 'c' or $marcLeader7 = 'd' or $marcLeader7 = 'm'"
                            >BK</xsl:when>
                        <xsl:when
                            test="$marcLeader7 = 'b' or $marcLeader7 = 'i' or $marcLeader7 = 's'"
                            >SE</xsl:when>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="$marcLeader6 = 't'">BK</xsl:when>
                <xsl:when test="$marcLeader6 = 'p'">MM</xsl:when>
                <xsl:when test="$marcLeader6 = 'm'">CF</xsl:when>
                <xsl:when test="$marcLeader6 = 'e' or $marcLeader6 = 'f'">MP</xsl:when>
                <xsl:when
                    test="$marcLeader6 = 'g' or $marcLeader6 = 'k' or $marcLeader6 = 'o' or $marcLeader6 = 'r'"
                    >VM</xsl:when>
                <xsl:when
                    test="$marcLeader6 = 'c' or $marcLeader6 = 'd' or $marcLeader6 = 'i' or $marcLeader6 = 'j'"
                    >MU</xsl:when>
            </xsl:choose>
        </xsl:variable>

        <!-- titleInfo -->

        <xsl:for-each select="datafield[@tag = '245']">
            <xsl:call-template name="createTitleInfoFrom245"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '210']">
            <xsl:call-template name="createTitleInfoFrom210"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '246']">
            <xsl:call-template name="createTitleInfoFrom246"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '240']">
            <xsl:call-template name="createTitleInfoFrom240"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '740']">
            <xsl:call-template name="createTitleInfoFrom740"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '130']">
            <xsl:call-template name="createTitleInfoFrom130"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '730']">
            <xsl:call-template name="createTitleInfoFrom730"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '242']">
            <titleInfo type="translated">
                <!--09/01/04 Added subfield $y-->
                <xsl:for-each select="subfield[@code = 'y']">
                    <xsl:attribute name="lang">
                        <xsl:value-of select="text()"/>
                    </xsl:attribute>
                </xsl:for-each>

                <!-- AQ1.27 tmee/dlf -->
                <xsl:variable name="title">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="subfieldSelect">
                                <!-- 1/04 removed $h, b -->
                                <xsl:with-param name="codes">a</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:variable name="titleChop">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="$title"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="@ind2 > 0">
                        <nonSort>
                            <xsl:value-of select="substring($titleChop, 1, @ind2)"/>
                        </nonSort>
                        <title>
                            <xsl:variable name="this">
                                <xsl:value-of select="substring($titleChop, @ind2 + 1)"/>
                            </xsl:variable>
                            <!-- 2.13 -->
                            <xsl:value-of select="normalize-space($this)"/>
                        </title>
                    </xsl:when>
                    <xsl:otherwise>
                        <title>
                            <xsl:variable name="this">
                                <xsl:value-of select="$titleChop"/>
                            </xsl:variable>
                            <!-- 2.13 -->
                            <xsl:value-of select="normalize-space($this)"/>
                        </title>
                    </xsl:otherwise>
                </xsl:choose>


                <!-- 1/04 fix -->
                <xsl:call-template name="subtitle"/>
                <xsl:call-template name="part"/>
            </titleInfo>
        </xsl:for-each>

        <!-- name -->

        <xsl:for-each select="datafield[@tag = '100']">
            <xsl:call-template name="createNameFrom100"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '110']">
            <xsl:call-template name="createNameFrom110"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '111']">
            <xsl:call-template name="createNameFrom111"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '700']">
            <xsl:call-template name="createNameFrom700"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '710']">
            <xsl:call-template name="createNameFrom710"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '711']">
            <xsl:call-template name="createNameFrom711"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '720']">
            <xsl:call-template name="createNameFrom720"/>
        </xsl:for-each>

        <!--old 7XXs
		<xsl:for-each select="datafield[@tag='700'][not(subfield[@code='t'])]">
			<name type="personal">
				<xsl:call-template name="nameABCDQ"/>
				<xsl:call-template name="affiliation"/>
				<xsl:call-template name="role"/>
			</name>
		</xsl:for-each>
		<xsl:for-each select="datafield[@tag='710'][not(subfield[@code='t'])]">
			<name type="corporate">
				<xsl:call-template name="nameABCDN"/>
				<xsl:call-template name="role"/>
			</name>
		</xsl:for-each>
		<xsl:for-each select="datafield[@tag='711'][not(subfield[@code='t'])]">
			<name type="conference">
				<xsl:call-template name="nameACDEQ"/>
				<xsl:call-template name="role"/>
			</name>
		</xsl:for-each>

		<xsl:for-each select="datafield[@tag='720'][not(subfield[@code='t'])]">
		<name>
		<xsl:if test="@ind1='1'">
		<xsl:attribute name="type">
		<xsl:text>personal</xsl:text>
		</xsl:attribute>
		</xsl:if>
		<namePart>
		<xsl:value-of select="subfield[@code='a']"/>
		</namePart>
		<xsl:call-template name="role"/>
		</name>
		</xsl:for-each>
-->

        <typeOfResource>
            <xsl:if test="$marcLeader7 = 'c'">
                <xsl:attribute name="collection">yes</xsl:attribute>
            </xsl:if>
            <xsl:if
                test="$marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't'">
                <xsl:attribute name="manuscript">yes</xsl:attribute>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$marcLeader6 = 'a' or $marcLeader6 = 't'">text</xsl:when>
                <xsl:when test="$marcLeader6 = 'e' or $marcLeader6 = 'f'">cartographic</xsl:when>
                <xsl:when test="$marcLeader6 = 'c' or $marcLeader6 = 'd'">notated music</xsl:when>
                <xsl:when test="$marcLeader6 = 'i'">sound recording-nonmusical</xsl:when>
                <xsl:when test="$marcLeader6 = 'j'">sound recording-musical</xsl:when>
                <xsl:when test="$marcLeader6 = 'k'">still image</xsl:when>
                <xsl:when test="$marcLeader6 = 'g'">moving image</xsl:when>
                <xsl:when test="$marcLeader6 = 'r'">three dimensional object</xsl:when>
                <xsl:when test="$marcLeader6 = 'm'">software, multimedia</xsl:when>
                <xsl:when test="$marcLeader6 = 'p'">mixed material</xsl:when>
            </xsl:choose>
        </typeOfResource>
        <xsl:if test="substring($controlField008, 26, 1) = 'd'">
            <genre authority="marcgt">globe</genre>
        </xsl:if>
        <xsl:if
            test="controlfield[@tag = '007'][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'r']">
            <genre authority="marcgt">remote-sensing image</genre>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'MP'">
            <xsl:variable name="controlField008-25" select="substring($controlField008, 26, 1)"/>
            <xsl:choose>
                <xsl:when
                    test="$controlField008-25 = 'a' or $controlField008-25 = 'b' or $controlField008-25 = 'c' or controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'j']">
                    <genre authority="marcgt">map</genre>
                </xsl:when>
                <xsl:when
                    test="$controlField008-25 = 'e' or controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'd']">
                    <genre authority="marcgt">atlas</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'SE'">
            <xsl:variable name="controlField008-21" select="substring($controlField008, 22, 1)"/>
            <xsl:choose>
                <xsl:when test="$controlField008-21 = 'd'">
                    <genre authority="marcgt">database</genre>
                </xsl:when>
                <xsl:when test="$controlField008-21 = 'l'">
                    <genre authority="marcgt">loose-leaf</genre>
                </xsl:when>
                <xsl:when test="$controlField008-21 = 'm'">
                    <genre authority="marcgt">series</genre>
                </xsl:when>
                <xsl:when test="$controlField008-21 = 'n'">
                    <genre authority="marcgt">newspaper</genre>
                </xsl:when>
                <xsl:when test="$controlField008-21 = 'p'">
                    <genre authority="marcgt">periodical</genre>
                </xsl:when>
                <xsl:when test="$controlField008-21 = 'w'">
                    <genre authority="marcgt">web site</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'BK' or $typeOf008 = 'SE'">
            <xsl:variable name="controlField008-24" select="substring($controlField008, 25, 4)"/>
            <xsl:choose>
                <xsl:when test="contains($controlField008-24, 'a')">
                    <genre authority="marcgt">abstract or summary</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'b')">
                    <genre authority="marcgt">bibliography</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'c')">
                    <genre authority="marcgt">catalog</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'd')">
                    <genre authority="marcgt">dictionary</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'e')">
                    <genre authority="marcgt">encyclopedia</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'f')">
                    <genre authority="marcgt">handbook</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'g')">
                    <genre authority="marcgt">legal article</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'i')">
                    <genre authority="marcgt">index</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'k')">
                    <genre authority="marcgt">discography</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'l')">
                    <genre authority="marcgt">legislation</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'm')">
                    <genre authority="marcgt">theses</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'n')">
                    <genre authority="marcgt">survey of literature</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'o')">
                    <genre authority="marcgt">review</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'p')">
                    <genre authority="marcgt">programmed text</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'q')">
                    <genre authority="marcgt">filmography</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'r')">
                    <genre authority="marcgt">directory</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 's')">
                    <genre authority="marcgt">statistics</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 't')">
                    <genre authority="marcgt">technical report</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'v')">
                    <genre authority="marcgt">legal case and case notes</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'w')">
                    <genre authority="marcgt">law report or digest</genre>
                </xsl:when>
                <xsl:when test="contains($controlField008-24, 'z')">
                    <genre authority="marcgt">treaty</genre>
                </xsl:when>
            </xsl:choose>
            <xsl:variable name="controlField008-29" select="substring($controlField008, 30, 1)"/>
            <xsl:choose>
                <xsl:when test="$controlField008-29 = '1'">
                    <genre authority="marcgt">conference publication</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'CF'">
            <xsl:variable name="controlField008-26" select="substring($controlField008, 27, 1)"/>
            <xsl:choose>
                <xsl:when test="$controlField008-26 = 'a'">
                    <genre authority="marcgt">numeric data</genre>
                </xsl:when>
                <xsl:when test="$controlField008-26 = 'e'">
                    <genre authority="marcgt">database</genre>
                </xsl:when>
                <xsl:when test="$controlField008-26 = 'f'">
                    <genre authority="marcgt">font</genre>
                </xsl:when>
                <xsl:when test="$controlField008-26 = 'g'">
                    <genre authority="marcgt">game</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'BK'">
            <xsl:if test="substring($controlField008, 25, 1) = 'j'">
                <genre authority="marcgt">patent</genre>
            </xsl:if>
            <xsl:if test="substring($controlField008, 25, 1) = '2'">
                <genre authority="marcgt">offprint</genre>
            </xsl:if>
            <xsl:if test="substring($controlField008, 31, 1) = '1'">
                <genre authority="marcgt">festschrift</genre>
            </xsl:if>
            <xsl:variable name="controlField008-34" select="substring($controlField008, 35, 1)"/>
            <xsl:if
                test="$controlField008-34 = 'a' or $controlField008-34 = 'b' or $controlField008-34 = 'c' or $controlField008-34 = 'd'">
                <genre authority="marcgt">biography</genre>
            </xsl:if>
            <xsl:variable name="controlField008-33" select="substring($controlField008, 34, 1)"/>
            <xsl:choose>
                <xsl:when test="$controlField008-33 = 'e'">
                    <genre authority="marcgt">essay</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'd'">
                    <genre authority="marcgt">drama</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'c'">
                    <genre authority="marcgt">comic strip</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'l'">
                    <genre authority="marcgt">fiction</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'h'">
                    <genre authority="marcgt">humor, satire</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'i'">
                    <genre authority="marcgt">letter</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'f'">
                    <genre authority="marcgt">novel</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'j'">
                    <genre authority="marcgt">short story</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 's'">
                    <genre authority="marcgt">speech</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'MU'">
            <xsl:variable name="controlField008-30-31" select="substring($controlField008, 31, 2)"/>
            <xsl:if test="contains($controlField008-30-31, 'b')">
                <genre authority="marcgt">biography</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'c')">
                <genre authority="marcgt">conference publication</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'd')">
                <genre authority="marcgt">drama</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'e')">
                <genre authority="marcgt">essay</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'f')">
                <genre authority="marcgt">fiction</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'o')">
                <genre authority="marcgt">folktale</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'h')">
                <genre authority="marcgt">history</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'k')">
                <genre authority="marcgt">humor, satire</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'm')">
                <genre authority="marcgt">memoir</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'p')">
                <genre authority="marcgt">poetry</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'r')">
                <genre authority="marcgt">rehearsal</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'g')">
                <genre authority="marcgt">reporting</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 's')">
                <genre authority="marcgt">sound</genre>
            </xsl:if>
            <xsl:if test="contains($controlField008-30-31, 'l')">
                <genre authority="marcgt">speech</genre>
            </xsl:if>
        </xsl:if>
        <xsl:if test="$typeOf008 = 'VM'">
            <xsl:variable name="controlField008-33" select="substring($controlField008, 34, 1)"/>
            <xsl:choose>
                <xsl:when test="$controlField008-33 = 'a'">
                    <genre authority="marcgt">art original</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'b'">
                    <genre authority="marcgt">kit</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'c'">
                    <genre authority="marcgt">art reproduction</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'd'">
                    <genre authority="marcgt">diorama</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'f'">
                    <genre authority="marcgt">filmstrip</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'g'">
                    <genre authority="marcgt">legal article</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'i'">
                    <genre authority="marcgt">picture</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'k'">
                    <genre authority="marcgt">graphic</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'l'">
                    <genre authority="marcgt">technical drawing</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'm'">
                    <genre authority="marcgt">motion picture</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'n'">
                    <genre authority="marcgt">chart</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'o'">
                    <genre authority="marcgt">flash card</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'p'">
                    <genre authority="marcgt">microscope slide</genre>
                </xsl:when>
                <xsl:when
                    test="$controlField008-33 = 'q' or controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'q']">
                    <genre authority="marcgt">model</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'r'">
                    <genre authority="marcgt">realia</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 's'">
                    <genre authority="marcgt">slide</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 't'">
                    <genre authority="marcgt">transparency</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'v'">
                    <genre authority="marcgt">videorecording</genre>
                </xsl:when>
                <xsl:when test="$controlField008-33 = 'w'">
                    <genre authority="marcgt">toy</genre>
                </xsl:when>
            </xsl:choose>
        </xsl:if>

        <!-- genre -->

        <xsl:for-each select="datafield[@tag = 047]">
            <xsl:call-template name="createGenreFrom047"/>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 336]">
            <xsl:call-template name="createGenreFrom336"/>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 655]">
            <xsl:call-template name="createGenreFrom655"/>
        </xsl:for-each>

        <!-- originInfo 250 and 260 
			MODS elements place and PlaceTerm: Guidelines for Use: 
	
  	  	If both a code and a term are given that represent the same
	    	place, use one <place> and multiple occurrences of <placeTerm>. 
			For different places, use different occurrences of <place>.
	     -->

        <originInfo>
            <xsl:call-template name="scriptCode"/>
            <xsl:for-each
                select="datafield[(@tag = 260 or @tag = 250) and subfield[@code = 'a' or code = 'b' or @code = 'c' or code = 'g']]">
                <xsl:call-template name="z2xx880"/>
            </xsl:for-each>
            <!--for marcCountryCode-->
            <xsl:variable name="marcCountryCode">
                <xsl:analyze-string select="substring($controlField008, 1, 19)"
                    regex="(\d+\w\d+)(x{{2}}|[a-z]{{3}}|\D+)">
                    <xsl:matching-substring>
                        <xsl:value-of
                            select="normalize-space(substring(translate(regex-group(2), '0123456789|# ', ''), 1, 3))"
                        />
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:variable name="marcPublicationCode"
                            select="normalize-space(substring(translate(replace($controlField008, '(\d+[a-z]\d+)(\D{2,3})', '$2'), '0123456789|', ' '), 1, 3))"/>
                        <xsl:if test="matches($marcPublicationCode, '\D{3,4}')">
                            <place>
                                <!-- marccountry code -->
                                <placeTerm>
                                    <xsl:attribute name="type">code</xsl:attribute>
                                    <xsl:attribute name="authority">marccountry</xsl:attribute>
                                    <xsl:value-of select="$marcPublicationCode"/>
                                </placeTerm>
                                <!-- decodes MARC Country Codes -->
                                <placeTerm>
                                    <xsl:attribute name="type">text</xsl:attribute>
                                    <xsl:value-of select="f:decodeMARCCountry($marcPublicationCode)"
                                    />
                                </placeTerm>
                            </place>
                        </xsl:if>
                    </xsl:non-matching-substring>
                    <xsl:fallback>
                        <xsl:variable name="MARCpublicationCode"
                            select="normalize-space(substring($controlField008, 16, 3))"/>
                        <xsl:if test="translate($MARCpublicationCode, '|', '')">
                            <place>
                                <placeTerm>
                                    <xsl:attribute name="type">code</xsl:attribute>
                                    <xsl:attribute name="authority">marccountry</xsl:attribute>
                                    <xsl:value-of select="$MARCpublicationCode"/>
                                </placeTerm>
                            </place>
                        </xsl:if>
                    </xsl:fallback>
                </xsl:analyze-string>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="contains($marcCountryCode, 'xx')"/>
                <xsl:when test="matches($marcCountryCode, '[a-z]{3}')">
                    <place>
                        <!-- marccountry code -->
                        <placeTerm>
                            <xsl:attribute name="type">code</xsl:attribute>
                            <xsl:attribute name="authority">marccountry</xsl:attribute>
                            <xsl:value-of select="$marcCountryCode"/>
                        </placeTerm>
                        <!-- decodes MARC Country Codes -->
                        <placeTerm>
                            <xsl:attribute name="type">text</xsl:attribute>
                            <xsl:value-of select="f:decodeMARCCountry($marcCountryCode)"/>
                        </placeTerm>
                    </place>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
            <!-- placeTerm from 044-->
            <xsl:for-each select="datafield[@tag = 044]/subfield[@code = 'c']">
                <place>
                    <placeTerm>
                        <xsl:attribute name="type">code</xsl:attribute>
                        <xsl:attribute name="authority">iso3166</xsl:attribute>
                        <xsl:value-of select="."/>
                    </placeTerm>
                </place>
            </xsl:for-each>
            <xsl:for-each select="datafield[@tag = 260]/subfield[@code = 'a']">
                <place>
                    <placeTerm>
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:call-template name="chopPunctuationFront">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="."/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </placeTerm>
                </place>
            </xsl:for-each>
            <xsl:for-each select="datafield[@tag = 046]/subfield[@code = 'm']">
                <dateValid point="start">
                    <xsl:value-of select="."/>
                </dateValid>
            </xsl:for-each>
            <xsl:for-each select="datafield[@tag = 046]/subfield[@code = 'n']">
                <dateValid point="end">
                    <xsl:value-of select="."/>
                </dateValid>
            </xsl:for-each>
            <xsl:for-each select="datafield[@tag = 046]/subfield[@code = 'j']">
                <dateModified>
                    <xsl:value-of select="."/>
                </dateModified>
            </xsl:for-each>

            <!-- tmee 1.52 -->

            <xsl:for-each select="datafield[@tag = 046]/subfield[@code = 'c']">
                <dateIssued encoding="marc" point="start">
                    <xsl:value-of select="."/>
                </dateIssued>
            </xsl:for-each>
            <xsl:for-each select="datafield[@tag = 046]/subfield[@code = 'e']">
                <dateIssued encoding="marc" point="end">
                    <xsl:value-of select="."/>
                </dateIssued>
            </xsl:for-each>

            <xsl:for-each select="datafield[@tag = 046]/subfield[@code = 'k']">
                <dateCreated encoding="marc" point="start">
                    <xsl:value-of select="."/>
                </dateCreated>
            </xsl:for-each>
            <xsl:for-each select="datafield[@tag = 046]/subfield[@code = 'l']">
                <dateCreated encoding="marc" point="end">
                    <xsl:value-of select="."/>
                </dateCreated>
            </xsl:for-each>

            <!-- tmee 1.35 1.36 dateIssued/nonMSS vs dateCreated/MSS -->
            <xsl:for-each
                select="datafield[@tag = 260]/subfield[@code = 'b' or @code = 'c' or @code = 'g']">
                <xsl:choose>
                    <xsl:when test="@code = 'b'">
                        <publisher>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString" select="."/>
                                <xsl:with-param name="punctuation">
                                    <xsl:text>:,;/ </xsl:text>
                                </xsl:with-param>
                            </xsl:call-template>
                        </publisher>
                    </xsl:when>
                    <xsl:when test="(@code = 'c')">
                        <xsl:if
                            test="$marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't'">
                            <dateCreated>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="."/>
                                </xsl:call-template>
                            </dateCreated>
                        </xsl:if>

                        <xsl:if
                            test="not($marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't')">
                            <dateIssued>
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="."/>
                                </xsl:call-template>
                            </dateIssued>
                        </xsl:if>
                    </xsl:when>
                    <xsl:when test="@code = 'g'">
                        <xsl:if
                            test="$marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't'">
                            <dateCreated>
                                <xsl:value-of select="."/>
                            </dateCreated>
                        </xsl:if>
                        <xsl:if
                            test="not($marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't')">
                            <dateCreated>
                                <xsl:value-of select="."/>
                            </dateCreated>
                        </xsl:if>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <xsl:variable name="dataField260c">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString"
                        select="datafield[@tag = 260]/subfield[@code = 'c']"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:variable name="controlField008-7-10"
                select="normalize-space(substring($controlField008, 8, 4))"/>
            <xsl:variable name="controlField008-11-14"
                select="normalize-space(substring($controlField008, 12, 4))"/>
            <!-- 2014-08-17 JG -->
            <xsl:variable name="controlField008-11-12"
                select="normalize-space(substring($controlField008, 12, 6))"/>
            <xsl:variable name="controlField008-6"
                select="normalize-space(substring($controlField008, 7, 1))"/>
            <!-- 2022-12-05 CM3 -->
            <xsl:variable name="controlfield008-7-12">
                <xsl:analyze-string select="replace($controlField008, '(\d+[a-z])(\d+.*)', '$2')"
                    regex="(\d+)(.*)">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="$controlField008-7-10"/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:variable>


            <!-- tmee 1.35 and 1.36 and 1.84-->
            <!--
	Example: <controlfield tag="008">221003s2022 flu 001 0 eng </controlfield> 
	Fixed field 008: Character Positions	
			All materials
			00-05 - Date entered on file
			06 - Type of date/Publication status
			07-10 - Date 1
			11-14 - Date 2
			15-17 - Place of publication, production, or execution
			18-34 - [See one of the seven separate 008/18-34 configuration sections for these elements.]
			35-37 - Language
			38 - Modified record
			39 - Cataloging source
		
    Question: Where was this item published?
    Answer: Reading lines 15-17 you can determine it was in "flu" which decode is Florida. 
    -->

            <xsl:if
                test="($controlField008-6 = 'e' or $controlField008-6 = 'p' or $controlField008-6 = 'r' or $controlField008-6 = 's' or $controlField008-6 = 't') and ($marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't')">
                <xsl:if test="$controlField008-7-10 and ($controlField008-7-10 != $dataField260c)">
                    <dateCreated encoding="marc">
                        <xsl:value-of select="$controlField008-7-10"/>
                    </dateCreated>
                </xsl:if>
            </xsl:if>
            <!-- 2014-08-17 JG -->
            <!-- 2022-11-23 CM3, added $controlField008-0-14 variable -->
            <xsl:choose>
                <!--YYYYMMDD -->
                <xsl:when
                    test="($controlField008-6 = 'e' or $controlField008-6 = 'p' or $controlField008-6 = 'r' or $controlField008-6 = 's' or $controlField008-6 = 't') and not($marcLeader6 = 'd' or $marcLeader6 = 'f' or $marcLeader6 = 'p' or $marcLeader6 = 't')">
                    <!-- use substring to limit for dates-->
                    <xsl:variable name="controlField008-0-14"
                        select="substring(controlfield[@tag = '008'], 1, 15)"/>
                    <xsl:choose>
                        <xsl:when test="matches($controlField008-0-14, '(\d+)(\w)(.*)')">
                            <xsl:analyze-string select="substring($controlField008-0-14, 1, 15)"
                                regex="(\d+)(\w)(\d+)">
                                <xsl:matching-substring>
                                    <dateIssued encoding="w3cdtf" keyDate="yes">
                                        <xsl:choose>
                                            <xsl:when test="matches(regex-group(3), '\d{8}')">
                                                <!--YYYY-->
                                                <xsl:number value="substring(regex-group(3), 1, 4)"
                                                  format="0001"/>
                                                <xsl:text>-</xsl:text>
                                                <!--MM-->
                                                <xsl:number value="substring(regex-group(3), 5, 2)"
                                                  format="01"/>
                                                <xsl:text>-</xsl:text>
                                                <!--DD-->
                                                <xsl:number value="substring(regex-group(3), 7, 2)"
                                                  format="01"/>
                                            </xsl:when>
                                            <xsl:when test="matches(regex-group(3), '\d{6}')">
                                                <!--YYYY-->
                                                <xsl:number value="substring(regex-group(3), 1, 4)"
                                                  format="0001"/>
                                                <xsl:text>-</xsl:text>
                                                <!--MM-->
                                                <xsl:number value="substring(regex-group(3), 5, 2)"
                                                  format="01"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <!--YYYY-->
                                                <xsl:number value="substring(regex-group(3), 1, 4)"
                                                  format="0001"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </dateIssued>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                        <xsl:when test="contains(., $controlfield008-7-12)">
                            <dateIssued encoding="marc">
                                <xsl:value-of select="$controlfield008-7-12"/>
                            </dateIssued>
                        </xsl:when>
                        <xsl:when test="contains(., $controlField008-11-14)">
                            <dateIssued encoding="marc">
                                <xsl:value-of
                                    select="concat($controlField008-7-10, $controlField008-11-14)"/>
                            </dateIssued>
                        </xsl:when>
                    </xsl:choose>
                </xsl:when>
            </xsl:choose>



            <xsl:if
                test="$controlField008-6 = 'c' or $controlField008-6 = 'd' or $controlField008-6 = 'i' or $controlField008-6 = 'k' or $controlField008-6 = 'm' or $controlField008-6 = 'u'">
                <xsl:if test="$controlField008-7-10">
                    <dateIssued encoding="marc" point="start">
                        <xsl:value-of select="$controlField008-7-10"/>
                    </dateIssued>
                </xsl:if>
            </xsl:if>

            <xsl:if
                test="$controlField008-6 = 'c' or $controlField008-6 = 'd' or $controlField008-6 = 'i' or $controlField008-6 = 'k' or $controlField008-6 = 'm' or $controlField008-6 = 'u'">
                <xsl:if test="$controlField008-11-14">
                    <dateIssued encoding="marc" point="end">
                        <xsl:value-of select="$controlField008-11-14"/>
                    </dateIssued>
                </xsl:if>
            </xsl:if>

            <xsl:if test="$controlField008-6 = 'q'">
                <xsl:if test="$controlField008-7-10">
                    <dateIssued encoding="marc" point="start" qualifier="questionable">
                        <xsl:value-of select="$controlField008-7-10"/>
                    </dateIssued>
                </xsl:if>
            </xsl:if>
            <xsl:if test="$controlField008-6 = 'q'">
                <xsl:if test="$controlField008-11-14">
                    <dateIssued encoding="marc" point="end" qualifier="questionable">
                        <xsl:value-of select="$controlField008-11-14"/>
                    </dateIssued>
                </xsl:if>
            </xsl:if>


            <!-- tmee 1.77 008-06 dateIssued for value 's' 1.89 removed 20130920
			<xsl:if test="$controlField008-6='s'">
				<xsl:if test="$controlField008-7-10">
					<dateIssued encoding="marc">
						<xsl:value-of select="$controlField008-7-10"/>
					</dateIssued>
				</xsl:if>
			</xsl:if>
			-->

            <xsl:if test="$controlField008-6 = 't'">
                <xsl:if test="$controlField008-11-14">
                    <copyrightDate encoding="marc">
                        <xsl:value-of select="$controlField008-11-14"/>
                    </copyrightDate>
                </xsl:if>
            </xsl:if>
            <xsl:for-each
                select="datafield[@tag = 033][@ind1 = '0' or @ind1 = '1']/subfield[@code = 'a']">
                <dateCaptured encoding="iso8601">
                    <xsl:value-of select="."/>
                </dateCaptured>
            </xsl:for-each>
            <xsl:for-each select="datafield[@tag = 033][@ind1 = '2']/subfield[@code = 'a'][1]">
                <dateCaptured encoding="iso8601" point="start">
                    <xsl:value-of select="."/>
                </dateCaptured>
            </xsl:for-each>
            <xsl:for-each select="datafield[@tag = 033][@ind1 = '2']/subfield[@code = 'a'][2]">
                <dateCaptured encoding="iso8601" point="end">
                    <xsl:value-of select="."/>
                </dateCaptured>
            </xsl:for-each>
            <xsl:for-each select="datafield[@tag = 250]/subfield[@code = 'a']">
                <edition>
                    <xsl:value-of select="."/>
                </edition>
            </xsl:for-each>

            <!-- 2.12 cm3 -->
            <!-- 1.94 -->
            <xsl:if
                test="$marcLeader7 = 'a' or $marcLeader7 = 'c' or $marcLeader7 = 'd' or $marcLeader7 = 'm' or $marcLeader7 = 'm' and ($marcLeader19 = 'a' or $marcLeader19 = 'b' or $marcLeader19 = 'c') or $marcLeader7 = 'm' and ($marcLeader19 = '#')">
                <xsl:for-each select="leader">
                    <issuance>
                        <!-- 2.08 cm3 -->
                        <xsl:choose>
                            <xsl:when
                                test="$marcLeader7 = 'a' or $marcLeader7 = 'c' or $marcLeader7 = 'd' or $marcLeader7 = 'm'"
                                >monographic</xsl:when>
                            <!-- <xsl:when test="$marcLeader7 = 'b'">continuing</xsl:when> -->
                            <xsl:when
                                test="$marcLeader7 = 'm' and ($marcLeader19 = 'a' or $marcLeader19 = 'b' or $marcLeader19 = 'c')"
                                >multipart monograph</xsl:when>
                            <xsl:when test="$marcLeader7 = 'm' and ($marcLeader19 = '#')">single
                                unit</xsl:when>
                            <!-- <xsl:when test="$marcLeader7 = 'i'">integrating resource</xsl:when>
                        <xsl:when test="$marcLeader7 = 'b' or $marcLeader7 = 's'">serial</xsl:when>-->
                        </xsl:choose>
                    </issuance>
                </xsl:for-each>
            </xsl:if>
            <xsl:for-each select="datafield[@tag = 310] | datafield[@tag = 321]">
                <frequency authority="marcfrequency">
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">ab</xsl:with-param>
                    </xsl:call-template>
                </frequency>
            </xsl:for-each>

            <!--	1.67 1.72 updated fixed location issue 201308 1.86	-->

            <xsl:if test="$typeOf008 = 'SE'">
                <xsl:for-each select="controlfield[@tag = 008]">
                    <xsl:variable name="controlField008-18"
                        select="substring($controlField008, 19, 1)"/>
                    <xsl:variable name="frequency">
                        <frequency>
                            <xsl:choose>
                                <xsl:when test="$controlField008-18 = 'a'">Annual</xsl:when>
                                <xsl:when test="$controlField008-18 = 'b'">Bimonthly</xsl:when>
                                <xsl:when test="$controlField008-18 = 'c'">Semiweekly</xsl:when>
                                <xsl:when test="$controlField008-18 = 'd'">Daily</xsl:when>
                                <xsl:when test="$controlField008-18 = 'e'">Biweekly</xsl:when>
                                <xsl:when test="$controlField008-18 = 'f'">Semiannual</xsl:when>
                                <xsl:when test="$controlField008-18 = 'g'">Biennial</xsl:when>
                                <xsl:when test="$controlField008-18 = 'h'">Triennial</xsl:when>
                                <xsl:when test="$controlField008-18 = 'i'">Three times a
                                    week</xsl:when>
                                <xsl:when test="$controlField008-18 = 'j'">Three times a
                                    month</xsl:when>
                                <xsl:when test="$controlField008-18 = 'k'">Continuously
                                    updated</xsl:when>
                                <xsl:when test="$controlField008-18 = 'm'">Monthly</xsl:when>
                                <xsl:when test="$controlField008-18 = 'q'">Quarterly</xsl:when>
                                <xsl:when test="$controlField008-18 = 's'">Semimonthly</xsl:when>
                                <xsl:when test="$controlField008-18 = 't'">Three times a
                                    year</xsl:when>
                                <xsl:when test="$controlField008-18 = 'u'">Unknown</xsl:when>
                                <xsl:when test="$controlField008-18 = 'w'">Weekly</xsl:when>
                                <xsl:when test="$controlField008-18 = '#'">Completely
                                    irregular</xsl:when>
                                <xsl:otherwise/>
                            </xsl:choose>
                        </frequency>
                    </xsl:variable>
                    <xsl:if test="$frequency != ''">
                        <frequency>
                            <xsl:value-of select="$frequency"/>
                        </frequency>
                    </xsl:if>
                </xsl:for-each>
            </xsl:if>
        </originInfo>



        <!-- originInfo - 264 -->

        <xsl:for-each select="datafield[@tag = 264][@ind2 = 0]">
            <!-- 2.03 added if test to originInfo producer cm3 2022/10 -->
            <originInfo displayLabel="producer">
                <!-- Template checks for altRepGroup - 880 $6 -->

                <xsl:call-template name="xxx880"/>
                <xsl:if test="subfield[@code = 'a'] != ''">
                    <place>
                        <placeTerm>
                            <xsl:value-of select="subfield[@code = 'a']"/>
                        </placeTerm>
                    </place>
                </xsl:if>
                <xsl:if test="subfield[@code = 'b'] != ''">
                    <publisher>
                        <xsl:value-of select="subfield[@code = 'b']"/>
                    </publisher>
                </xsl:if>
                <xsl:if test="subfield[@code = 'c'] != ''">
                    <dateOther type="production">
                        <xsl:value-of select="subfield[@code = 'c']"/>
                    </dateOther>
                </xsl:if>
            </originInfo>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 264][@ind2 = 1]">
            <originInfo displayLabel="publisher">
                <!-- Revision 2.07 used substring-before function to get subfield b (ie., publisher) and subfield c (i.e., dateIssued) 2022/12/08 -->
                <!-- Template checks for altRepGroup - 880 $6 1.88 20130829 added chopPunc-->
                <xsl:call-template name="xxx880"/>
                <place>
                    <placeTerm>
                        <xsl:attribute name="type">text</xsl:attribute>
                        <xsl:call-template name="chopPunctuationFront">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="chopPunctuation">
                                    <xsl:with-param name="chopString" select="."/>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </placeTerm>
                </place>
                <publisher>
                    <xsl:value-of select="substring-before(subfield[@code = 'b'], ',')"/>
                </publisher>
                <dateIssued>
                    <xsl:value-of select="substring-before(subfield[@code = 'c'], '.')"/>
                </dateIssued>
            </originInfo>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 264][@ind2 = '2']">
            <originInfo displayLabel="distributor">
                <!-- Template checks for altRepGroup - 880 $6 -->
                <xsl:call-template name="xxx880"/>
                <place>
                    <placeTerm>
                        <xsl:value-of select="subfield[@code = 'a']"/>
                    </placeTerm>
                </place>
                <publisher>
                    <xsl:value-of select="subfield[@code = 'b']"/>
                </publisher>
                <dateOther type="distribution">
                    <xsl:value-of select="subfield[@code = 'c']"/>
                </dateOther>
            </originInfo>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 264][@ind2 = '3']">
            <originInfo displayLabel="manufacturer">
                <!-- Template checks for altRepGroup - 880 $6 -->
                <xsl:call-template name="xxx880"/>
                <place>
                    <placeTerm>
                        <xsl:value-of select="subfield[@code = 'a']"/>
                    </placeTerm>
                </place>
                <publisher>
                    <xsl:value-of select="subfield[@code = 'b']"/>
                </publisher>
                <dateOther type="manufacture">
                    <xsl:value-of select="subfield[@code = 'c']"/>
                </dateOther>
            </originInfo>
        </xsl:for-each>





        <xsl:for-each select="datafield[@tag = 880]">
            <xsl:variable name="related_datafield"
                select="substring-before(subfield[@code = '6'], '-')"/>
            <xsl:variable name="occurence_number"
                select="substring(substring-after(subfield[@code = '6'], '-'), 1, 2)"/>
            <xsl:variable name="hit"
                select="../datafield[@tag = $related_datafield and contains(subfield[@code = '6'], concat('880-', $occurence_number))]/@tag"/>

            <xsl:choose>
                <xsl:when test="$hit = '260'">
                    <originInfo>
                        <xsl:call-template name="scriptCode"/>
                        <xsl:for-each
                            select="../datafield[@tag = 260 and subfield[@code = 'a' or code = 'b' or @code = 'c' or code = 'g']]">
                            <xsl:call-template name="z2xx880"/>
                        </xsl:for-each>
                        <xsl:if test="subfield[@code = 'a']">
                            <place>
                                <placeTerm type="text">
                                    <xsl:value-of select="subfield[@code = 'a']"/>
                                </placeTerm>
                            </place>
                        </xsl:if>
                        <xsl:if test="subfield[@code = 'b']">
                            <publisher>
                                <xsl:value-of select="subfield[@code = 'b']"/>
                            </publisher>
                        </xsl:if>
                        <xsl:if test="subfield[@code = 'c']">
                            <dateIssued>
                                <xsl:value-of select="subfield[@code = 'c']"/>
                            </dateIssued>
                        </xsl:if>
                        <xsl:if test="subfield[@code = 'g']">
                            <dateCreated>
                                <xsl:value-of select="subfield[@code = 'g']"/>
                            </dateCreated>
                        </xsl:if>
                        <xsl:for-each
                            select="../datafield[@tag = 880]/subfield[@code = 6][contains(text(), '250')]">
                            <edition>
                                <xsl:value-of select="following-sibling::subfield"/>
                            </edition>
                        </xsl:for-each>
                    </originInfo>
                </xsl:when>

                <xsl:when test="$hit = '300'">
                    <physicalDescription>
                        <xsl:for-each select="../datafield[@tag = 300]">
                            <xsl:call-template name="z3xx880"/>
                        </xsl:for-each>
                        <extent>
                            <xsl:for-each select="subfield">
                                <xsl:if
                                    test="@code = 'a' or @code = '3' or @code = 'b' or @code = 'c'">
                                    <xsl:value-of select="."/>
                                    <xsl:text>&#160;</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </extent>
                        <!-- form 337 338 -->
                        <form>
                            <xsl:attribute name="authority">
                                <xsl:value-of select="subfield[@code = '2']"/>
                            </xsl:attribute>
                            <xsl:call-template name="xxx880"/>
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">a</xsl:with-param>
                            </xsl:call-template>
                        </form>
                        <form>
                            <xsl:attribute name="authority">
                                <xsl:value-of select="subfield[@code = '2']"/>
                            </xsl:attribute>
                            <xsl:call-template name="xxx880"/>
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">ab</xsl:with-param>
                            </xsl:call-template>
                        </form>
                    </physicalDescription>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>

        <!-- 008 language -->
        <!--Revision 2.05 controlField008-35-37replace, uses replace function and regex to pinpoint 3 letter string-->
        <xsl:variable name="controlField008-36-38"
            select="normalize-space(translate(substring($controlField008, 36, 3), '|', ''))"/>
        <xsl:variable name="controlField008-35-37"
            select="normalize-space(translate(substring($controlField008, 35, 3), '|', ''))"/>
        <xsl:choose>
            <xsl:when test="matches($controlField008-36-38, '[a-z]{3}')">
                <language>
                    <languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="$controlField008-36-38"/>
                    </languageTerm>
                    <languageTerm type="text">
                        <xsl:value-of select="f:isoTwo2Lang($controlField008-36-38)"/>
                    </languageTerm>
                </language>
            </xsl:when>
            <xsl:when test="matches($controlField008-35-37, '[a-z]{3}')">
                <language>
                    <languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="$controlField008-35-37"/>
                    </languageTerm>
                    <languageTerm type="text">
                        <xsl:value-of select="f:isoTwo2Lang($controlField008-35-37)"/>
                    </languageTerm>
                </language>
            </xsl:when>
            <xsl:otherwise>

                <xsl:analyze-string select="$controlField008"
                    regex="(\d+[a-z]\d+)(\D+)([a-z]{{3}})(\|{{2}})">
                    <xsl:matching-substring>
                        <language>
                            <languageTerm authority="iso639-2b" type="code">
                                <xsl:value-of select="regex-group(3)"/>
                            </languageTerm>
                            <xsl:if test="matches(regex-group(1), '[a-z]{2,3}')">
                                <languageTerm type="text">
                                    <xsl:value-of select="f:isoTwo2Lang(regex-group(1))"/>
                                </languageTerm>
                            </xsl:if>

                        </language>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring> </xsl:non-matching-substring>
                </xsl:analyze-string>


            </xsl:otherwise>
        </xsl:choose>
        <!-- language 041 -->
        <xsl:for-each select="datafield[@tag = 041]">
            <xsl:for-each
                select="subfield[@code = 'a' or @code = 'b' or @code = 'd' or @code = 'e' or @code = 'f' or @code = 'g' or @code = 'h']">
                <xsl:variable name="langCodes" select="."/>
                <xsl:choose>
                    <xsl:when test="../subfield[@code = '2'] = 'rfc3066'">
                        <!-- not stacked but could be repeated -->
                        <xsl:call-template name="rfcLanguages">
                            <xsl:with-param name="nodeNum">
                                <xsl:value-of select="1"/>
                            </xsl:with-param>
                            <xsl:with-param name="usedLanguages">
                                <xsl:text/>
                            </xsl:with-param>
                            <xsl:with-param name="controlField008-35-37">
                                <xsl:value-of select="$controlField008-35-37"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- iso -->
                        <xsl:variable name="allLanguages">
                            <xsl:copy-of select="$langCodes"/>
                        </xsl:variable>
                        <xsl:variable name="currentLanguage">
                            <xsl:value-of select="substring($allLanguages, 1, 3)"/>
                        </xsl:variable>
                        <xsl:call-template name="isoLanguage">
                            <xsl:with-param name="currentLanguage">
                                <xsl:value-of select="substring($allLanguages, 1, 3)"/>
                            </xsl:with-param>
                            <xsl:with-param name="remainingLanguages">
                                <xsl:value-of
                                    select="substring($allLanguages, 4, string-length($allLanguages) - 3)"
                                />
                            </xsl:with-param>
                            <xsl:with-param name="usedLanguages">
                                <xsl:if test="$controlField008-35-37">
                                    <xsl:value-of select="$controlField008-35-37"/>
                                </xsl:if>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:for-each>
        </xsl:for-each>

        <!-- physicalDescription -->

        <xsl:variable name="physicalDescription">
            <!--3.2 change tmee 007/11 -->
            <xsl:if test="$typeOf008 = 'CF' and controlfield[@tag = 007][substring(., 12, 1) = 'a']">
                <digitalOrigin>reformatted digital</digitalOrigin>
            </xsl:if>
            <xsl:if test="$typeOf008 = 'CF' and controlfield[@tag = 007][substring(., 12, 1) = 'b']">
                <digitalOrigin>digitized microfilm</digitalOrigin>
            </xsl:if>
            <xsl:if test="$typeOf008 = 'CF' and controlfield[@tag = 007][substring(., 12, 1) = 'd']">
                <digitalOrigin>digitized other analog</digitalOrigin>
            </xsl:if>
            <xsl:variable name="controlField008-23" select="substring($controlField008, 24, 1)"/>
            <xsl:variable name="controlField008-29" select="substring($controlField008, 30, 1)"/>
            <xsl:variable name="check008-23">
                <xsl:if
                    test="$typeOf008 = 'BK' or $typeOf008 = 'MU' or $typeOf008 = 'SE' or $typeOf008 = 'MM'">
                    <xsl:value-of select="true()"/>
                </xsl:if>
            </xsl:variable>
            <xsl:variable name="check008-29">
                <xsl:if test="$typeOf008 = 'MP' or $typeOf008 = 'VM'">
                    <xsl:value-of select="true()"/>
                </xsl:if>
            </xsl:variable>
            <xsl:choose>
                <xsl:when
                    test="($check008-23 and $controlField008-23 = 'f') or ($check008-29 and $controlField008-29 = 'f')">
                    <form authority="marcform">braille</form>
                </xsl:when>
                <xsl:when
                    test="($controlField008-23 = ' ' and ($marcLeader6 = 'c' or $marcLeader6 = 'd')) or (($typeOf008 = 'BK' or $typeOf008 = 'SE') and ($controlField008-23 = ' ' or $controlField008 = 'r'))">
                    <form authority="marcform">print</form>
                </xsl:when>
                <xsl:when
                    test="$marcLeader6 = 'm' or ($check008-23 and $controlField008-23 = 's') or ($check008-29 and $controlField008-29 = 's')">
                    <form authority="marcform">electronic</form>
                </xsl:when>
                <!-- 1.33 -->
                <xsl:when test="$marcLeader6 = 'o'">
                    <form authority="marcform">kit</form>
                </xsl:when>
                <xsl:when
                    test="($check008-23 and $controlField008-23 = 'b') or ($check008-29 and $controlField008-29 = 'b')">
                    <form authority="marcform">microfiche</form>
                </xsl:when>
                <xsl:when
                    test="($check008-23 and $controlField008-23 = 'a') or ($check008-29 and $controlField008-29 = 'a')">
                    <form authority="marcform">microfilm</form>
                </xsl:when>
            </xsl:choose>

            <!-- 1/04 fix -->
            <xsl:if test="datafield[@tag = 130]/subfield[@code = 'h']">
                <form authority="gmd">
                    <xsl:call-template name="chopBrackets">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="datafield[@tag = 130]/subfield[@code = 'h']"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </form>
            </xsl:if>
            <xsl:if test="datafield[@tag = 240]/subfield[@code = 'h']">
                <form authority="gmd">
                    <xsl:call-template name="chopBrackets">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="datafield[@tag = 240]/subfield[@code = 'h']"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </form>
            </xsl:if>
            <xsl:if test="datafield[@tag = 242]/subfield[@code = 'h']">
                <form authority="gmd">
                    <xsl:call-template name="chopBrackets">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="datafield[@tag = 242]/subfield[@code = 'h']"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </form>
            </xsl:if>
            <xsl:if test="datafield[@tag = 245]/subfield[@code = 'h']">
                <form authority="gmd">
                    <xsl:call-template name="chopBrackets">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="datafield[@tag = 245]/subfield[@code = 'h']"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </form>
            </xsl:if>
            <xsl:if test="datafield[@tag = 246]/subfield[@code = 'h']">
                <form authority="gmd">
                    <xsl:call-template name="chopBrackets">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="datafield[@tag = 246]/subfield[@code = 'h']"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </form>
            </xsl:if>
            <xsl:if test="datafield[@tag = 730]/subfield[@code = 'h']">
                <form authority="gmd">
                    <xsl:call-template name="chopBrackets">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="datafield[@tag = 730]/subfield[@code = 'h']"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </form>
            </xsl:if>
            <xsl:for-each select="datafield[@tag = 256]/subfield[@code = 'a']">
                <form>
                    <xsl:value-of select="."/>
                </form>
            </xsl:for-each>
            <xsl:for-each select="controlfield[@tag = 007][substring(text(), 1, 1) = 'c']">
                <xsl:choose>
                    <xsl:when test="substring(text(), 14, 1) = 'a'">
                        <reformattingQuality>access</reformattingQuality>
                    </xsl:when>
                    <xsl:when test="substring(text(), 14, 1) = 'p'">
                        <reformattingQuality>preservation</reformattingQuality>
                    </xsl:when>
                    <xsl:when test="substring(text(), 14, 1) = 'r'">
                        <reformattingQuality>replacement</reformattingQuality>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <!--3.2 change tmee 007/01 -->
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'b']">
                <form authority="marccategory">electronic resource</form>
                <form authority="marcsmd">chip cartridge</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'c']">
                <form authority="marccategory">electronic resource</form>
                <form authority="marcsmd">computer optical disc cartridge</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'j']">
                <form authority="marccategory">electronic resource</form>
                <form authority="marcsmd">magnetic disc</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'm']">
                <form authority="marccategory">electronic resource</form>
                <form authority="marcsmd">magneto-optical disc</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'o']">
                <form authority="marccategory">electronic resource</form>
                <form authority="marcsmd">optical disc</form>
            </xsl:if>

            <!-- 1.38 AQ 1.29 tmee 	1.66 added marccategory and marcsmd as part of 3.4 -->
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'r']">
                <form authority="marccategory">electronic resource</form>
                <form authority="marcsmd">remote</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'a']">
                <form authority="marccategory">electronic resource</form>
                <form authority="marcsmd">tape cartridge</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'f']">
                <form authority="marccategory">electronic resource</form>
                <form authority="marcsmd">tape cassette</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'c'][substring(text(), 2, 1) = 'h']">
                <form authority="marccategory">electronic resource</form>
                <form authority="marcsmd">tape reel</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'd'][substring(text(), 2, 1) = 'a']">
                <form authority="marccategory">globe</form>
                <form authority="marcsmd">celestial globe</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'd'][substring(text(), 2, 1) = 'e']">
                <form authority="marccategory">globe</form>
                <form authority="marcsmd">earth moon globe</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'd'][substring(text(), 2, 1) = 'b']">
                <form authority="marccategory">globe</form>
                <form authority="marcsmd">planetary or lunar globe</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'd'][substring(text(), 2, 1) = 'c']">
                <form authority="marccategory">globe</form>
                <form authority="marcsmd">terrestrial globe</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'o'][substring(text(), 2, 1) = 'o']">
                <form authority="marccategory">kit</form>
                <form authority="marcsmd">kit</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'd']">
                <form authority="marccategory">map</form>
                <form authority="marcsmd">atlas</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'g']">
                <form authority="marccategory">map</form>
                <form authority="marcsmd">diagram</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'j']">
                <form authority="marccategory">map</form>
                <form authority="marcsmd">map</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'q']">
                <form authority="marccategory">map</form>
                <form authority="marcsmd">model</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'k']">
                <form authority="marccategory">map</form>
                <form authority="marcsmd">profile</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'r']">
                <form authority="marcsmd">remote-sensing image</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 's']">
                <form authority="marccategory">map</form>
                <form authority="marcsmd">section</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'a'][substring(text(), 2, 1) = 'y']">
                <form authority="marccategory">map</form>
                <form authority="marcsmd">view</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'a']">
                <form authority="marccategory">microform</form>
                <form authority="marcsmd">aperture card</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'e']">
                <form authority="marccategory">microform</form>
                <form authority="marcsmd">microfiche</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'f']">
                <form authority="marccategory">microform</form>
                <form authority="marcsmd">microfiche cassette</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'b']">
                <form authority="marccategory">microform</form>
                <form authority="marcsmd">microfilm cartridge</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'c']">
                <form authority="marccategory">microform</form>
                <form authority="marcsmd">microfilm cassette</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'd']">
                <form authority="marccategory">microform</form>
                <form authority="marcsmd">microfilm reel</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'h'][substring(text(), 2, 1) = 'g']">
                <form authority="marccategory">microform</form>
                <form authority="marcsmd">microopaque</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'm'][substring(text(), 2, 1) = 'c']">
                <form authority="marccategory">motion picture</form>
                <form authority="marcsmd">film cartridge</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'm'][substring(text(), 2, 1) = 'f']">
                <form authority="marccategory">motion picture</form>
                <form authority="marcsmd">film cassette</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'm'][substring(text(), 2, 1) = 'r']">
                <form authority="marccategory">motion picture</form>
                <form authority="marcsmd">film reel</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'n']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">chart</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'c']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">collage</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'd']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">drawing</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'o']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">flash card</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'e']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">painting</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'f']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">photomechanical print</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'g']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">photonegative</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'h']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">photoprint</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'i']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">picture</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'j']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">print</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'k'][substring(text(), 2, 1) = 'l']">
                <form authority="marccategory">nonprojected graphic</form>
                <form authority="marcsmd">technical drawing</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'q'][substring(text(), 2, 1) = 'q']">
                <form authority="marccategory">notated music</form>
                <form authority="marcsmd">notated music</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 'd']">
                <form authority="marccategory">projected graphic</form>
                <form authority="marcsmd">filmslip</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 'c']">
                <form authority="marccategory">projected graphic</form>
                <form authority="marcsmd">filmstrip cartridge</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 'o']">
                <form authority="marccategory">projected graphic</form>
                <form authority="marcsmd">filmstrip roll</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 'f']">
                <form authority="marccategory">projected graphic</form>
                <form authority="marcsmd">other filmstrip type</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 's']">
                <form authority="marccategory">projected graphic</form>
                <form authority="marcsmd">slide</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'g'][substring(text(), 2, 1) = 't']">
                <form authority="marccategory">projected graphic</form>
                <form authority="marcsmd">transparency</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'r'][substring(text(), 2, 1) = 'r']">
                <form authority="marccategory">remote-sensing image</form>
                <form authority="marcsmd">remote-sensing image</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'e']">
                <form authority="marccategory">sound recording</form>
                <form authority="marcsmd">cylinder</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'q']">
                <form authority="marccategory">sound recording</form>
                <form authority="marcsmd">roll</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'g']">
                <form authority="marccategory">sound recording</form>
                <form authority="marcsmd">sound cartridge</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 's']">
                <form authority="marccategory">sound recording</form>
                <form authority="marcsmd">sound cassette</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'd']">
                <form authority="marccategory">sound recording</form>
                <form authority="marcsmd">sound disc</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 't']">
                <form authority="marccategory">sound recording</form>
                <form authority="marcsmd">sound-tape reel</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'i']">
                <form authority="marccategory">sound recording</form>
                <form authority="marcsmd">sound-track film</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 's'][substring(text(), 2, 1) = 'w']">
                <form authority="marccategory">sound recording</form>
                <form authority="marcsmd">wire recording</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'f'][substring(text(), 2, 1) = 'c']">
                <form authority="marccategory">tactile material</form>
                <form authority="marcsmd">braille</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'f'][substring(text(), 2, 1) = 'b']">
                <form authority="marccategory">tactile material</form>
                <form authority="marcsmd">combination</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'f'][substring(text(), 2, 1) = 'a']">
                <form authority="marccategory">tactile material</form>
                <form authority="marcsmd">moon</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'f'][substring(text(), 2, 1) = 'd']">
                <form authority="marccategory">tactile material</form>
                <form authority="marcsmd">tactile, with no writing system</form>
            </xsl:if>

            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 't'][substring(text(), 2, 1) = 'c']">
                <form authority="marccategory">text</form>
                <form authority="marcsmd">braille</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 't'][substring(text(), 2, 1) = 'b']">
                <form authority="marccategory">text</form>
                <form authority="marcsmd">large print</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 't'][substring(text(), 2, 1) = 'a']">
                <form authority="marccategory">text</form>
                <form authority="marcsmd">regular print</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 't'][substring(text(), 2, 1) = 'd']">
                <form authority="marccategory">text</form>
                <form authority="marcsmd">text in looseleaf binder</form>
            </xsl:if>

            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'v'][substring(text(), 2, 1) = 'c']">
                <form authority="marccategory">videorecording</form>
                <form authority="marcsmd">videocartridge</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'v'][substring(text(), 2, 1) = 'f']">
                <form authority="marccategory">videorecording</form>
                <form authority="marcsmd">videocassette</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'v'][substring(text(), 2, 1) = 'd']">
                <form authority="marccategory">videorecording</form>
                <form authority="marcsmd">videodisc</form>
            </xsl:if>
            <xsl:if
                test="controlfield[@tag = 007][substring(text(), 1, 1) = 'v'][substring(text(), 2, 1) = 'r']">
                <form authority="marccategory">videorecording</form>
                <form authority="marcsmd">videoreel</form>
            </xsl:if>

            <xsl:for-each
                select="datafield[@tag = 856]/subfield[@code = 'q'][string-length(.) &gt; 1]">
                <internetMediaType>
                    <xsl:value-of select="."/>
                </internetMediaType>
            </xsl:for-each>

            <xsl:for-each select="datafield[@tag = 300]">
                <extent>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abce3fg</xsl:with-param>
                    </xsl:call-template>
                </extent>
            </xsl:for-each>


            <xsl:for-each select="datafield[@tag = 337]">
                <form type="media">
                    <xsl:attribute name="authority">
                        <xsl:value-of select="subfield[@code = '2']"/>
                    </xsl:attribute>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">a</xsl:with-param>
                    </xsl:call-template>
                </form>
            </xsl:for-each>

            <xsl:for-each select="datafield[@tag = 338]">
                <form type="carrier">
                    <xsl:attribute name="authority">
                        <xsl:value-of select="subfield[@code = '2']"/>
                    </xsl:attribute>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">a</xsl:with-param>
                    </xsl:call-template>
                </form>
            </xsl:for-each>


            <!-- 1.43 tmee 351 $3$a$b$c-->
            <xsl:for-each select="datafield[@tag = 351]">
                <note type="arrangement">
                    <xsl:for-each select="subfield[@code = '3']">
                        <xsl:value-of select="."/>
                        <xsl:text>: </xsl:text>
                    </xsl:for-each>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abc</xsl:with-param>
                    </xsl:call-template>
                </note>
            </xsl:for-each>

        </xsl:variable>


        <xsl:if test="string-length(normalize-space($physicalDescription))">
            <physicalDescription>
                <xsl:for-each select="datafield[@tag = 300]">
                    <!-- Template checks for altRepGroup - 880 $6 -->
                    <xsl:call-template name="z3xx880"/>
                </xsl:for-each>
                <xsl:for-each select="datafield[@tag = 337]">
                    <!-- Template checks for altRepGroup - 880 $6 -->
                    <xsl:call-template name="xxx880"/>
                </xsl:for-each>
                <xsl:for-each select="datafield[@tag = 338]">
                    <!-- Template checks for altRepGroup - 880 $6 -->
                    <xsl:call-template name="xxx880"/>
                </xsl:for-each>

                <xsl:copy-of select="$physicalDescription"/>
            </physicalDescription>
        </xsl:if>


        <xsl:for-each select="datafield[@tag = 520]">
            <xsl:call-template name="createAbstractFrom520"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 505]">
            <xsl:call-template name="createTOCFrom505"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 521]">
            <xsl:call-template name="createTargetAudienceFrom521"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 506]">
            <xsl:call-template name="createAccessConditionFrom506"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 540]">
            <xsl:call-template name="createAccessConditionFrom540"/>
        </xsl:for-each>


        <xsl:if
            test="$typeOf008 = 'BK' or $typeOf008 = 'CF' or $typeOf008 = 'MU' or $typeOf008 = 'VM'">
            <xsl:variable name="controlField008-22" select="substring($controlField008, 23, 1)"/>
            <xsl:choose>
                <!-- 01/04 fix -->
                <xsl:when test="$controlField008-22 = 'd'">
                    <targetAudience authority="marctarget">adolescent</targetAudience>
                </xsl:when>
                <xsl:when test="$controlField008-22 = 'e'">
                    <targetAudience authority="marctarget">adult</targetAudience>
                </xsl:when>
                <xsl:when test="$controlField008-22 = 'g'">
                    <targetAudience authority="marctarget">general</targetAudience>
                </xsl:when>
                <xsl:when
                    test="$controlField008-22 = 'b' or $controlField008-22 = 'c' or $controlField008-22 = 'j'">
                    <targetAudience authority="marctarget">juvenile</targetAudience>
                </xsl:when>
                <xsl:when test="$controlField008-22 = 'a'">
                    <targetAudience authority="marctarget">preschool</targetAudience>
                </xsl:when>
                <xsl:when test="$controlField008-22 = 'f'">
                    <targetAudience authority="marctarget">specialized</targetAudience>
                </xsl:when>
            </xsl:choose>
        </xsl:if>

        <!-- 1.32 tmee Drop note mapping for 510 and map only to <relatedItem>
		<xsl:for-each select="datafield[@tag=510]">
			<note type="citation/reference">
				<xsl:call-template name="uri"/>
				<xsl:variable name="str">
					<xsl:for-each select="subfield[@code!='6' or @code!='8']">
						<xsl:value-of select="."/>
						<xsl:text>&#160;</xsl:text>
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="substring($str,1,string-length($str)-1)"/>
			</note>
		</xsl:for-each>
		-->

        <!-- 245c 362az 502-585 5XX-->

        <!--	JG removed statement of responsibility -->
        <xsl:if test="datafield[@tag = 245]/subfield[@code = 'c']">
            <xsl:for-each select="datafield[@tag = 245]">
                <xsl:call-template name="createNoteFrom245c"/>
            </xsl:for-each>
        </xsl:if>

        <xsl:for-each select="datafield[@tag = 362]">
            <xsl:call-template name="createNoteFrom362"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 500]">
            <xsl:call-template name="createNoteFrom500"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 502]">
            <xsl:call-template name="createNoteFrom502"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 504]">
            <xsl:call-template name="createNoteFrom504"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 508]">
            <xsl:call-template name="createNoteFrom508"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 511]">
            <xsl:call-template name="createNoteFrom511"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 515]">
            <xsl:call-template name="createNoteFrom515"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 518]">
            <xsl:call-template name="createNoteFrom518"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 524]">
            <xsl:call-template name="createNoteFrom524"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 530]">
            <xsl:call-template name="createNoteFrom530"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 533]">
            <xsl:call-template name="createNoteFrom533"/>
        </xsl:for-each>
        <!--
		<xsl:for-each select="datafield[@tag=534]">
			<xsl:call-template name="createNoteFrom534"/>
		</xsl:for-each>
-->

        <xsl:for-each select="datafield[@tag = 535]">
            <xsl:call-template name="createNoteFrom535"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 536]">
            <xsl:call-template name="createNoteFrom536"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 538]">
            <xsl:call-template name="createNoteFrom538"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 541]">
            <xsl:call-template name="createNoteFrom541"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 545]">
            <xsl:call-template name="createNoteFrom545"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 546]">
            <xsl:call-template name="createNoteFrom546"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 561]">
            <xsl:call-template name="createNoteFrom561"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 562]">
            <xsl:call-template name="createNoteFrom562"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 581]">
            <xsl:call-template name="createNoteFrom581"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 583]">
            <xsl:call-template name="createNoteFrom583"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 585]">
            <xsl:call-template name="createNoteFrom585"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 588]">
            <xsl:call-template name="createNoteFrom500"/>
        </xsl:for-each>

        <xsl:for-each
            select="datafield[@tag = 501 or @tag = 507 or @tag = 513 or @tag = 514 or @tag = 516 or @tag = 522 or @tag = 525 or @tag = 526 or @tag = 544 or @tag = 547 or @tag = 550 or @tag = 552 or @tag = 555 or @tag = 556 or @tag = 565 or @tag = 567 or @tag = 580 or @tag = 584 or @tag = 586]">
            <xsl:call-template name="createNoteFrom5XX"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 034]">
            <xsl:call-template name="createSubGeoFrom034"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 043]">
            <xsl:call-template name="createSubGeoFrom043"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 045]">
            <xsl:call-template name="createSubTemFrom045"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 255]">
            <xsl:call-template name="createSubGeoFrom255"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 600]">
            <xsl:call-template name="createSubNameFrom600"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 610]">
            <xsl:call-template name="createSubNameFrom610"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 611]">
            <xsl:call-template name="createSubNameFrom611"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 630]">
            <xsl:call-template name="createSubTitleFrom630"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 648]">
            <xsl:call-template name="createSubChronFrom648"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 650]">
            <xsl:call-template name="createSubTopFrom650"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 651]">
            <xsl:call-template name="createSubGeoFrom651"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 653]">
            <xsl:call-template name="createSubFrom653"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 656]">
            <xsl:call-template name="createSubFrom656"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 662]">
            <xsl:call-template name="createSubGeoFrom662752"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 752]">
            <xsl:call-template name="createSubGeoFrom662752"/>
        </xsl:for-each>

        <!--Revision 2.09 added custom function to map Category Code to Subject. cm3 2022/12/08-->
        <!-- <xd:doc><xd:desc><xd:p>NAL Subject Category Codes</xd:p>
	    <xd:p>Mapped from MARC 072</xd:p>
	    <xd:ref name="subjCatCode" type="function">f:subjCatCode[XPath]</xd:ref> 
	    <xd:p>Matches the category code to its corresponding subject</xd:p>
	    </xd:desc>
	    </xd:doc>-->
        <xsl:for-each select="datafield[@tag = 072][@ind2 = '0']">
            <xsl:if test="matches(., '[A-Z]\d{3}')">
                <subject authority="agricola">
                    <topic>
                        <xsl:value-of select="f:subjCatCode(normalize-space(subfield[@code = 'a']))"
                        />
                    </topic>
                </subject>
            </xsl:if>
        </xsl:for-each>

        <!-- createClassificationFrom 0XX-->
        <xsl:for-each select="datafield[@tag = '050']">
            <xsl:call-template name="createClassificationFrom050"/>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '060']">
            <xsl:call-template name="createClassificationFrom060"/>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '080']">
            <xsl:call-template name="createClassificationFrom080"/>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '082']">
            <xsl:call-template name="createClassificationFrom082"/>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '084']">
            <xsl:call-template name="createClassificationFrom084"/>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '086']">
            <xsl:call-template name="createClassificationFrom086"/>
        </xsl:for-each>

        <!-- LC classification from 070 -->
        <xsl:if test="datafield[@tag = 070][@ind1 = '0']/subfield[@code = 'a']">
            <classification authority="nal">
                <xsl:value-of select="datafield[@tag = 070][@ind1 = '0']/subfield[@code = 'a']"/>
                <xsl:if test="datafield[@tag = 070]/subfield[@code = 'b']">
                    <xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="datafield[@tag = 070]/subfield[@code = 'b']"/>
                </xsl:if>
            </classification>
        </xsl:if>


        <!--	location	-->

        <xsl:for-each select="datafield[@tag = 852]">
            <xsl:call-template name="createLocationFrom852"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 856]">
            <xsl:call-template name="createLocationFrom856"/>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 490][@ind1 = '0']">
            <xsl:call-template name="createRelatedItemFrom490"/>
        </xsl:for-each>


        <xsl:for-each select="datafield[@tag = 440]">
            <relatedItem type="series">
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="subfieldSelect">
                                        <xsl:with-param name="codes">av</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
            </relatedItem>
        </xsl:for-each>

        <!-- tmee 1.40 1.74 1.88 fixed 510c mapping 20130829-->

        <xsl:for-each select="datafield[@tag = 510]">
            <relatedItem type="isReferencedBy">
                <xsl:for-each select="subfield[@code = 'a']">
                    <titleInfo>
                        <title>
                            <xsl:value-of select="normalize-space(.)"/>
                        </title>
                    </titleInfo>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'b']">
                    <originInfo>
                        <dateOther type="coverage">
                            <xsl:value-of select="normalize-space(.)"/>
                        </dateOther>
                    </originInfo>
                </xsl:for-each>

                <part>
                    <detail type="part">
                        <number>
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="subfieldSelect">
                                        <xsl:with-param name="codes">c</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </number>
                    </detail>
                </part>
            </relatedItem>
        </xsl:for-each>


        <xsl:for-each select="datafield[@tag = 534]">
            <relatedItem type="original">
                <xsl:call-template name="relatedTitle"/>
                <xsl:call-template name="relatedName"/>
                <xsl:if test="subfield[@code = 'b' or @code = 'c']">
                    <originInfo>
                        <xsl:for-each select="subfield[@code = 'c']">
                            <publisher>
                                <xsl:value-of select="."/>
                            </publisher>
                        </xsl:for-each>
                        <xsl:for-each select="subfield[@code = 'b']">
                            <edition>
                                <xsl:value-of select="."/>
                            </edition>
                        </xsl:for-each>
                    </originInfo>
                </xsl:if>
                <xsl:call-template name="relatedIdentifierISSN"/>
                <xsl:for-each select="subfield[@code = 'z']">
                    <identifier type="isbn">
                        <xsl:value-of select="."/>
                    </identifier>
                </xsl:for-each>
                <xsl:call-template name="relatedNote"/>
            </relatedItem>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 700][subfield[@code = 't']]">
            <relatedItem>
                <xsl:call-template name="constituentOrRelatedType"/>
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="specialSubfieldSelect">
                                        <xsl:with-param name="anyCodes">tfklmorsv</xsl:with-param>
                                        <xsl:with-param name="axis">t</xsl:with-param>
                                        <xsl:with-param name="afterCodes">g</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
                <name type="personal">
                    <namePart>
                        <xsl:call-template name="specialSubfieldSelect">
                            <xsl:with-param name="anyCodes">aq</xsl:with-param>
                            <xsl:with-param name="axis">t</xsl:with-param>
                            <xsl:with-param name="beforeCodes">g</xsl:with-param>
                        </xsl:call-template>
                    </namePart>
                    <xsl:call-template name="termsOfAddress"/>
                    <xsl:call-template name="nameDate"/>
                    <xsl:call-template name="role"/>
                </name>
                <xsl:call-template name="relatedForm"/>
                <xsl:call-template name="relatedIdentifierISSN"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 710][subfield[@code = 't']]">
            <relatedItem>
                <xsl:call-template name="constituentOrRelatedType"/>
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="specialSubfieldSelect">
                                        <xsl:with-param name="anyCodes">tfklmorsv</xsl:with-param>
                                        <xsl:with-param name="axis">t</xsl:with-param>
                                        <xsl:with-param name="afterCodes">dg</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="relatedPartNumName"/>
                </titleInfo>
                <name type="corporate">
                    <xsl:for-each select="subfield[@code = 'a']">
                        <namePart>
                            <xsl:value-of select="."/>
                        </namePart>
                    </xsl:for-each>
                    <xsl:for-each select="subfield[@code = 'b']">
                        <namePart>
                            <xsl:value-of select="."/>
                        </namePart>
                    </xsl:for-each>
                    <xsl:variable name="tempNamePart">
                        <xsl:call-template name="specialSubfieldSelect">
                            <xsl:with-param name="anyCodes">c</xsl:with-param>
                            <xsl:with-param name="axis">t</xsl:with-param>
                            <xsl:with-param name="beforeCodes">dgn</xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:if test="normalize-space($tempNamePart)">
                        <namePart>
                            <xsl:value-of select="$tempNamePart"/>
                        </namePart>
                    </xsl:if>
                    <xsl:call-template name="role"/>
                </name>
                <xsl:call-template name="relatedForm"/>
                <xsl:call-template name="relatedIdentifierISSN"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 711][subfield[@code = 't']]">
            <relatedItem>
                <xsl:call-template name="constituentOrRelatedType"/>
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="specialSubfieldSelect">
                                        <xsl:with-param name="anyCodes">tfklsv</xsl:with-param>
                                        <xsl:with-param name="axis">t</xsl:with-param>
                                        <xsl:with-param name="afterCodes">g</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="relatedPartNumName"/>
                </titleInfo>
                <name type="conference">
                    <namePart>
                        <xsl:call-template name="specialSubfieldSelect">
                            <xsl:with-param name="anyCodes">aqdc</xsl:with-param>
                            <xsl:with-param name="axis">t</xsl:with-param>
                            <xsl:with-param name="beforeCodes">gn</xsl:with-param>
                        </xsl:call-template>
                    </namePart>
                </name>
                <xsl:call-template name="relatedForm"/>
                <xsl:call-template name="relatedIdentifierISSN"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 730][@ind2 = '2']">
            <relatedItem>
                <xsl:call-template name="constituentOrRelatedType"/>
                <titleInfo>
                    <!-- Revision 2.09 added custom function to map Category Code to Subject. cm3 2022/12/08 -->
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="subfieldSelect">
                                        <xsl:with-param name="codes">adfgklmorsv</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
                <xsl:call-template name="relatedForm"/>
                <xsl:call-template name="relatedIdentifierISSN"/>
            </relatedItem>
        </xsl:for-each>


        <xsl:for-each select="datafield[@tag = 740][@ind2 = '2']">
            <relatedItem>
                <xsl:call-template name="constituentOrRelatedType"/>
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:value-of select="subfield[@code = 'a']"/>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
                <xsl:call-template name="relatedForm"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 760]">
            <relatedItem type="series">
                <xsl:call-template name="relatedItem76X-78X"/>
            </relatedItem>
        </xsl:for-each>

        <!--AQ1.23 tmee/dlf -->
        <xsl:for-each select="datafield[@tag = 762]">
            <relatedItem type="constituent">
                <xsl:call-template name="relatedItem76X-78X"/>
            </relatedItem>
        </xsl:for-each>

        <!-- AQ1.5, AQ1.7 deleted tags 777 and 787 from the following select for relatedItem mapping -->
        <!-- 1.45 and 1.46 - AQ1.24 and 1.25 tmee-->
        <xsl:for-each select="datafield[@tag = 765] | datafield[@tag = 767] | datafield[@tag = 775]">
            <relatedItem type="otherVersion">
                <xsl:call-template name="relatedItem76X-78X"/>
            </relatedItem>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 770] | datafield[@tag = 774]">
            <relatedItem type="constituent">
                <xsl:call-template name="relatedItem76X-78X"/>
            </relatedItem>
        </xsl:for-each>


        <xsl:for-each select="datafield[@tag = 772] | datafield[@tag = 773]">
            <relatedItem type="host">
                <xsl:call-template name="relatedItem76X-78X"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 776]">
            <relatedItem type="otherFormat">
                <xsl:call-template name="relatedItem76X-78X"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 780]">
            <relatedItem type="preceding">
                <xsl:call-template name="relatedItem76X-78X"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 785]">
            <relatedItem type="succeeding">
                <xsl:call-template name="relatedItem76X-78X"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 786]">
            <relatedItem type="original">
                <xsl:call-template name="relatedItem76X-78X"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 800]">
            <relatedItem type="series">
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="specialSubfieldSelect">
                                        <xsl:with-param name="anyCodes">tfklmorsv</xsl:with-param>
                                        <xsl:with-param name="axis">t</xsl:with-param>
                                        <xsl:with-param name="afterCodes">g</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
                <name type="personal">
                    <namePart>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="specialSubfieldSelect">
                                    <xsl:with-param name="anyCodes">aq</xsl:with-param>
                                    <xsl:with-param name="axis">t</xsl:with-param>
                                    <xsl:with-param name="beforeCodes">g</xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </namePart>
                    <xsl:call-template name="termsOfAddress"/>
                    <xsl:call-template name="nameDate"/>
                    <xsl:call-template name="role"/>
                </name>
                <xsl:call-template name="relatedForm"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 810]">
            <relatedItem type="series">
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="specialSubfieldSelect">
                                        <xsl:with-param name="anyCodes">tfklmorsv</xsl:with-param>
                                        <xsl:with-param name="axis">t</xsl:with-param>
                                        <xsl:with-param name="afterCodes">dg</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="relatedPartNumName"/>
                </titleInfo>
                <name type="corporate">
                    <xsl:for-each select="subfield[@code = 'a']">
                        <namePart>
                            <xsl:value-of select="."/>
                        </namePart>
                    </xsl:for-each>
                    <xsl:for-each select="subfield[@code = 'b']">
                        <namePart>
                            <xsl:value-of select="."/>
                        </namePart>
                    </xsl:for-each>
                    <namePart>
                        <xsl:call-template name="specialSubfieldSelect">
                            <xsl:with-param name="anyCodes">c</xsl:with-param>
                            <xsl:with-param name="axis">t</xsl:with-param>
                            <xsl:with-param name="beforeCodes">dgn</xsl:with-param>
                        </xsl:call-template>
                    </namePart>
                    <xsl:call-template name="role"/>
                </name>
                <xsl:call-template name="relatedForm"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 811]">
            <relatedItem type="series">
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="specialSubfieldSelect">
                                        <xsl:with-param name="anyCodes">tfklsv</xsl:with-param>
                                        <xsl:with-param name="axis">t</xsl:with-param>
                                        <xsl:with-param name="afterCodes">g</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="relatedPartNumName"/>
                </titleInfo>
                <name type="conference">
                    <namePart>
                        <xsl:call-template name="specialSubfieldSelect">
                            <xsl:with-param name="anyCodes">aqdc</xsl:with-param>
                            <xsl:with-param name="axis">t</xsl:with-param>
                            <xsl:with-param name="beforeCodes">gn</xsl:with-param>
                        </xsl:call-template>
                    </namePart>
                    <xsl:call-template name="role"/>
                </name>
                <xsl:call-template name="relatedForm"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '830']">
            <relatedItem type="series">
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="subfieldSelect">
                                        <xsl:with-param name="codes">adfgklmorsv</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
                <xsl:call-template name="relatedForm"/>
            </relatedItem>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '856'][@ind2 = '2']/subfield[@code = 'q']">
            <relatedItem>
                <internetMediaType>
                    <xsl:value-of select="."/>
                </internetMediaType>
            </relatedItem>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '880']">
            <xsl:apply-templates select="self::*" mode="trans880"/>
        </xsl:for-each>


        <!-- 856, 020, 024, 022, 028, 010, 035, 037 -->

        <xsl:for-each select="datafield[@tag = '020']">
            <xsl:if test="subfield[@code = 'a']">
                <identifier type="isbn">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '020']">
            <xsl:if test="subfield[@code = 'z']">
                <identifier type="isbn" invalid="yes">
                    <xsl:value-of select="subfield[@code = 'z']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '024'][@ind1 = '0']">
            <xsl:if test="subfield[@code = 'a']">
                <identifier type="isrc">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '024'][@ind1 = '2']">
            <xsl:if test="subfield[@code = 'a']">
                <identifier type="ismn">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '024'][@ind1 = '4']">
            <identifier type="sici">
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">ab</xsl:with-param>
                </xsl:call-template>
            </identifier>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '024'][@ind1 = '8']">
            <identifier>
                <xsl:value-of select="subfield[@code = 'a']"/>
            </identifier>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '022'][subfield[@code = 'a']]">
            <xsl:if test="subfield[@code = 'a']">
                <identifier type="issn">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '022'][subfield[@code = 'z']]">
            <xsl:if test="subfield[@code = 'z']">
                <identifier type="issn" invalid="yes">
                    <xsl:value-of select="subfield[@code = 'z']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '022'][subfield[@code = 'y']]">
            <xsl:if test="subfield[@code = 'y']">
                <identifier type="issn" invalid="yes">
                    <xsl:value-of select="subfield[@code = 'y']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '022'][subfield[@code = 'l']]">
            <xsl:if test="subfield[@code = 'l']">
                <identifier type="issn-l">
                    <xsl:value-of select="subfield[@code = 'l']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = '022'][subfield[@code = 'm']]">
            <xsl:if test="subfield[@code = 'm']">
                <identifier type="issn-l" invalid="yes">
                    <xsl:value-of select="subfield[@code = 'm']"/>
                </identifier>
            </xsl:if>
        </xsl:for-each>

        <!-- NAL identifier from 024 -->
        <xsl:if test="datafield[@tag = 024][@ind1 = '7']">
            <identifier type="doi">
                <xsl:value-of select="datafield[@tag = 024][@ind1 = '7']/subfield[@code = 'a']"/>
            </identifier>
        </xsl:if>

        <!-- NAL identifier from 001 -->
        <xsl:if test="controlfield[@tag = 001]">
            <identifier type="control">
                <xsl:value-of select="controlfield[@tag = 001]"/>
            </identifier>
        </xsl:if>

        <xsl:for-each select="datafield[@tag = '010'][subfield[@code = 'a']]">
            <identifier type="lccn">
                <xsl:value-of select="normalize-space(subfield[@code = 'a'])"/>
            </identifier>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '010'][subfield[@code = 'z']]">
            <identifier type="lccn" invalid="yes">
                <xsl:value-of select="normalize-space(subfield[@code = 'z'])"/>
            </identifier>
        </xsl:for-each>


        <!-- NAL: Map Agricola accession ID to identifier -->

        <xsl:for-each select="datafield[@tag = '016'][subfield[@code = 'a']]">
            <identifier type="agricola">
                <xsl:value-of select="normalize-space(subfield[@code = 'a'])"/>
            </identifier>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '028']">
            <identifier>
                <xsl:attribute name="type">
                    <xsl:choose>
                        <xsl:when test="@ind1 = '0'">issue number</xsl:when>
                        <xsl:when test="@ind1 = '1'">matrix number</xsl:when>
                        <xsl:when test="@ind1 = '2'">music plate</xsl:when>
                        <xsl:when test="@ind1 = '3'">music publisher</xsl:when>
                        <xsl:when test="@ind1 = '4'">videorecording identifier</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">
                        <xsl:choose>
                            <xsl:when test="@ind1 = '0'">ba</xsl:when>
                            <xsl:otherwise>ab</xsl:otherwise>
                        </xsl:choose>
                    </xsl:with-param>
                </xsl:call-template>
            </identifier>
        </xsl:for-each>

        <xsl:for-each
            select="datafield[@tag = '035'][subfield[@code = 'a'][contains(text(), '(OCoLC)')]]">
            <identifier type="oclc">
                <xsl:value-of
                    select="normalize-space(substring-after(subfield[@code = 'a'], '(OCoLC)'))"/>
            </identifier>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = '037']">
            <identifier type="stock number">
                <xsl:if test="subfield[@code = 'c']">
                    <xsl:attribute name="displayLabel">
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">c</xsl:with-param>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">ab</xsl:with-param>
                </xsl:call-template>
            </identifier>
        </xsl:for-each>


        <!-- 1.51 tmee 20100129-->
        <xsl:for-each select="datafield[@tag = '856'][subfield[@code = 'u']]">
            <xsl:if
                test="starts-with(subfield[@code = 'u'], 'urn:hdl') or starts-with(subfield[@code = 'u'], 'hdl') or starts-with(subfield[@code = 'u'], 'http://hdl.loc.gov')">
                <identifier>
                    <xsl:attribute name="type">
                        <xsl:if
                            test="starts-with(subfield[@code = 'u'], 'urn:doi') or starts-with(subfield[@code = 'u'], 'doi')"
                            >doi</xsl:if>
                        <xsl:if
                            test="starts-with(subfield[@code = 'u'], 'urn:hdl') or starts-with(subfield[@code = 'u'], 'hdl') or starts-with(subfield[@code = 'u'], 'http://hdl.loc.gov')"
                            >hdl</xsl:if>
                    </xsl:attribute>
                    <xsl:value-of
                        select="concat('hdl:', substring-after(subfield[@code = 'u'], 'http://hdl.loc.gov/'))"
                    />
                </identifier>
            </xsl:if>
            <xsl:if
                test="starts-with(subfield[@code = 'u'], 'urn:hdl') or starts-with(subfield[@code = 'u'], 'hdl')">
                <identifier type="hdl">
                    <xsl:if test="subfield[@code = 'y' or @code = '3' or @code = 'z']">
                        <xsl:attribute name="displayLabel">
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">y3z</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of
                        select="concat('hdl:', substring-after(subfield[@code = 'u'], 'http://hdl.loc.gov/'))"
                    />
                </identifier>
            </xsl:if>
        </xsl:for-each>

        <xsl:for-each select="datafield[@tag = 024][@ind1 = 1]">
            <identifier type="upc">
                <xsl:value-of select="subfield[@code = 'a']"/>
            </identifier>
        </xsl:for-each>


        <!-- 1.51 tmee 20100129 removed duplicate code 20131217
		<xsl:for-each select="datafield[@tag='856'][subfield[@code='u']]">
			<xsl:if
				test="starts-with(subfield[@code='u'],'urn:hdl') or starts-with(subfield[@code='u'],'hdl') or starts-with(subfield[@code='u'],'http://hdl.loc.gov') ">
				<identifier>
					<xsl:attribute name="type">
						<xsl:if
							test="starts-with(subfield[@code='u'],'urn:doi') or starts-with(subfield[@code='u'],'doi')"
							>doi</xsl:if>
						<xsl:if
							test="starts-with(subfield[@code='u'],'urn:hdl') or starts-with(subfield[@code='u'],'hdl') or starts-with(subfield[@code='u'],'http://hdl.loc.gov')"
							>hdl</xsl:if>
					</xsl:attribute>
					<xsl:value-of
						select="concat('hdl:',substring-after(subfield[@code='u'],'http://hdl.loc.gov/'))"
					/>
				</identifier>
			</xsl:if>

			<xsl:if
				test="starts-with(subfield[@code='u'],'urn:hdl') or starts-with(subfield[@code='u'],'hdl')">
				<identifier type="hdl">
					<xsl:if test="subfield[@code='y' or @code='3' or @code='z']">
						<xsl:attribute name="displayLabel">
							<xsl:call-template name="subfieldSelect">
								<xsl:with-param name="codes">y3z</xsl:with-param>
							</xsl:call-template>
						</xsl:attribute>
					</xsl:if>
					<xsl:value-of
						select="concat('hdl:',substring-after(subfield[@code='u'],'http://hdl.loc.gov/'))"
					/>
				</identifier>
			</xsl:if>
		</xsl:for-each>
		-->


        <xsl:for-each select="datafield[@tag = 856][@ind2 = '2'][subfield[@code = 'u']]">
            <relatedItem>
                <location>
                    <url>
                        <xsl:if test="subfield[@code = 'y' or @code = '3']">
                            <xsl:attribute name="displayLabel">
                                <xsl:call-template name="subfieldSelect">
                                    <xsl:with-param name="codes">y3</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:if test="subfield[@code = 'z']">
                            <xsl:attribute name="note">
                                <xsl:call-template name="subfieldSelect">
                                    <xsl:with-param name="codes">z</xsl:with-param>
                                </xsl:call-template>
                            </xsl:attribute>
                        </xsl:if>
                        <xsl:value-of select="subfield[@code = 'u']"/>
                    </url>
                </location>
            </relatedItem>
        </xsl:for-each>

        <!--NAL notes 910, 930, 945, 946, 974 -->
        <extension>
            <xsl:call-template name="createNoteFrom910"/>
            <xsl:call-template name="createNoteFrom930"/>
            <xsl:call-template name="createNoteFrom945"/>
            <xsl:call-template name="createNoteFrom946"/>
            <xsl:call-template name="createNoteFrom974"/>
        </extension>

        <recordInfo>
            <xsl:for-each select="leader[substring($marcLeader, 19, 1) = 'a']">
                <descriptionStandard>aacr</descriptionStandard>
            </xsl:for-each>
            <!-- 040$e = Description Conventions (e.g., RDA) -->
            <xsl:for-each select="datafield[@tag = 040]">
                <xsl:if test="subfield[@code = 'e']">
                    <descriptionStandard>
                        <xsl:value-of select="subfield[@code = 'e']"/>
                    </descriptionStandard>
                </xsl:if>
                <recordContentSource authority="marcorg">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </recordContentSource>
            </xsl:for-each>

            <xsl:for-each select="controlfield[@tag = 008]">
                <recordCreationDate encoding="marc">
                    <xsl:value-of select="substring(., 1, 6)"/>
                </recordCreationDate>
            </xsl:for-each>
            <xsl:for-each select="controlfield[@tag = 005]">
                <recordChangeDate encoding="iso8601">
                    <xsl:value-of select="."/>
                </recordChangeDate>
            </xsl:for-each>
            <xsl:for-each select="controlfield[@tag = 001]">
                <recordIdentifier>
                    <xsl:if test="../controlfield[@tag = 003]">
                        <xsl:attribute name="source">
                            <xsl:value-of select="../controlfield[@tag = 003]"/>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </recordIdentifier>
            </xsl:for-each>

            <!-- Revision 2.04 updated recordOrigin to reflect the XSLT filename used in transform cm 2022/12/08 -->
            <recordOrigin>
                <xsl:variable name="transform"
                    select="string(tokenize(base-uri(document('')), '/')[last()])" as="xs:string"/>
                <xsl:value-of
                    select="normalize-space(concat('Converted from MARCXML to MODS version 3.4 using', ' ', $transform, ' ', '(Revision 2.03 2022/10/27)'))"
                />
            </recordOrigin>

            <xsl:for-each select="datafield[@tag = 040]/subfield[@code = 'b']">
                <languageOfCataloging>
                    <languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="."/>
                    </languageTerm>
                </languageOfCataloging>
            </xsl:for-each>

        </recordInfo>
    </xsl:template>
    <!--marcRecord ends -->
    <xd:doc id="displayForm" scope="component">
        <xd:desc>displayForm</xd:desc>
    </xd:doc>
    <xsl:template name="displayForm">

        <xsl:for-each select="subfield[@code = 'a']">
            <!-- cm3 Revision 2.00 added namePart -->
            <namePart type="given">
                <xsl:choose>
                    <!-- when given name contains initials -->
                    <xsl:when test="matches(substring-after(., ','), '([A-Z]\.$|[A-Z]\.[A-Z]\.$)')">
                        <xsl:value-of select="normalize-space(substring-after(., ','))"/>
                    </xsl:when>
                    <!-- when it does not-->
                    <xsl:otherwise>
                        <xsl:value-of
                            select="normalize-space(replace(substring-after(., ','), '(\s)(.*)(,|\.)', '$2'))"
                        />
                    </xsl:otherwise>
                </xsl:choose>
            </namePart>

            <namePart type="family">
                <xsl:value-of select="substring-before(normalize-space(.), ',')"/>
            </namePart>
            <displayForm>
                <xsl:choose>
                    <!--same as above, leaves period at end of inititals only-->
                    <xsl:when test="matches(substring-after(., ','), '([A-Z]\.$|[A-Z]\.[A-Z]\.$)')">
                        <xsl:value-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="replace(., '(.*,.*)(,|\.)', '$1')"/>
                    </xsl:otherwise>
                </xsl:choose>
            </displayForm>
        </xsl:for-each>

    </xsl:template>
    <xd:doc id="affiliation" scope="component">
        <xd:desc>affiliation</xd:desc>
    </xd:doc>
    <xsl:template name="affiliation">

        <xsl:for-each select="subfield[@code = 'u']">
            <affiliation>
                <xsl:value-of select="."/>
            </affiliation>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="uri" scope="component">
        <xd:desc>uri</xd:desc>
    </xd:doc>
    <xsl:template name="uri">

        <xsl:for-each select="subfield[@code = 'u'] | subfield[@code = '0']">
            <xsl:attribute name="xlink:href">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="role" scope="component">
        <xd:desc>role</xd:desc>
    </xd:doc>
    <xsl:template name="role">

        <xsl:for-each select="subfield[@code = 'e']">
            <role>
                <roleTerm type="text">
                    <xsl:value-of select="replace(., '^(.*)(\.$)', '$1')"/>
                </roleTerm>
            </role>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = '4']">
            <role>
                <roleTerm authority="marcrelator" type="code">
                    <xsl:value-of select="."/>
                </roleTerm>
            </role>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="part" scope="component">
        <xd:desc>part</xd:desc>
    </xd:doc>
    <xsl:template name="part">

        <xsl:variable name="partNumber">
            <xsl:call-template name="specialSubfieldSelect">
                <xsl:with-param name="axis">n</xsl:with-param>
                <xsl:with-param name="anyCodes">n</xsl:with-param>
                <xsl:with-param name="afterCodes">fgkdlmor</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="partName">
            <xsl:call-template name="specialSubfieldSelect">
                <xsl:with-param name="axis">p</xsl:with-param>
                <xsl:with-param name="anyCodes">p</xsl:with-param>
                <xsl:with-param name="afterCodes">fgkdlmor</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length(normalize-space($partNumber))">
            <partNumber>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="$partNumber"/>
                </xsl:call-template>
            </partNumber>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($partName))">
            <partName>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="$partName"/>
                </xsl:call-template>
            </partName>
        </xsl:if>
    </xsl:template>
    <xd:doc id="relatedPart" scope="component">
        <xd:desc>relatedPart</xd:desc>
    </xd:doc>
    <xsl:template name="relatedPart">

        <xsl:if test="@tag = 773">
            <xsl:for-each select="subfield[@code = 'g']">
                <part>
                    <xsl:analyze-string select="." regex="(\d{{4,6}}.\w{{0,4}})(.+)">
                        <xsl:matching-substring>
                            <!-- volume -->
                            <detail type="volume">
                                <number>
                                    <xsl:value-of
                                        select="replace(regex-group(2), '(.*, v\.\s)(\d+)(.*)', '$2')"
                                    />
                                </number>
                                <caption>v.</caption>
                            </detail>
                            <!-- issue -->
                            <xsl:if test="matches(regex-group(2), 'no. ')">
                                <detail type="issue">
                                    <number>
                                        <xsl:value-of
                                            select="replace(regex-group(2), '(.*)(no. )(\d+|pt.\d+)(.*)', '$3')"
                                        />
                                    </number>
                                    <caption>no.</caption>
                                </detail>
                            </xsl:if>
                            <xsl:choose>
                                <!-- extent (pages) -->
                                <xsl:when test="matches(regex-group(2), '\d+\-\d+')">
                                    <extent unit="pages">
                                        <start>
                                            <xsl:value-of
                                                select="replace(regex-group(2), '(.*)(p.)(\d+)(\-)(\d+)', '$3')"
                                            />
                                        </start>
                                        <end>
                                            <xsl:value-of
                                                select="replace(regex-group(2), '(.*)(p.)(\d+)(\-)(\d+)', '$5')"
                                            />
                                        </end>
                                        <xsl:variable name="firstPage" as="xs:double"
                                            select="number(replace(regex-group(2), '(.*)(p.)(\d+)(\-)(\d+)', '$3'))"/>
                                        <xsl:variable name="lastPage" as="xs:double"
                                            select="number(replace(regex-group(2), '(.*)(p.)(\d+)(\-)(\d+)', '$5'))"/>
                                        <total>
                                            <xsl:value-of
                                                select="f:calculateTotalPgs($firstPage, $lastPage)"
                                            />
                                        </total>
                                    </extent>
                                </xsl:when>
                                <xsl:otherwise>
                                    <!-- extent (page total) -->
                                    <xsl:if test="ends-with(regex-group(2), '-')">
                                        <extent unit="pages">
                                            <xsl:variable name="clean-regex-group-2"
                                                select="substring-before(substring-after(regex-group(2), 'p.'), '-')"/>
                                            <total>
                                                <xsl:value-of
                                                  select="translate($clean-regex-group-2, 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz', '')"
                                                />
                                            </total>
                                        </extent>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>

                            <text type="year">
                                <xsl:value-of select="substring-before(regex-group(1), ' ')"/>
                            </text>
                            <text type="month">
                                <xsl:value-of select="substring-after(regex-group(1), ' ')"/>
                            </text>
                        </xsl:matching-substring>
                    </xsl:analyze-string>

                </part>
            </xsl:for-each>
            <xsl:for-each select="subfield[@code = 'q']">
                <part>
                    <xsl:call-template name="parsePart"/>
                </part>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>
    <xd:doc id="relatedPartNumName" scope="component">
        <xd:desc>relatedPartNumName</xd:desc>
    </xd:doc>
    <xsl:template name="relatedPartNumName">

        <xsl:variable name="partNumber">
            <xsl:call-template name="specialSubfieldSelect">
                <xsl:with-param name="axis">g</xsl:with-param>
                <xsl:with-param name="anyCodes">g</xsl:with-param>
                <xsl:with-param name="afterCodes">pst</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="partName">
            <xsl:call-template name="specialSubfieldSelect">
                <xsl:with-param name="axis">p</xsl:with-param>
                <xsl:with-param name="anyCodes">p</xsl:with-param>
                <xsl:with-param name="afterCodes">fgkdlmor</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="string-length(normalize-space($partNumber))">
            <partNumber>
                <xsl:value-of select="$partNumber"/>
            </partNumber>
        </xsl:if>
        <xsl:if test="string-length(normalize-space($partName))">
            <partName>
                <xsl:value-of select="$partName"/>
            </partName>
        </xsl:if>
    </xsl:template>
    <xd:doc id="relatedName" scope="component">
        <xd:desc>relatedName</xd:desc>
    </xd:doc>
    <xsl:template name="relatedName">

        <xsl:for-each select="subfield[@code = 'a']">
            <name>
                <namePart>
                    <xsl:value-of select="substring-before(., '.')"/>
                </namePart>
            </name>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="relatedForm" scope="component">
        <xd:desc>relatedForm</xd:desc>
    </xd:doc>
    <xsl:template name="relatedForm">

        <xsl:for-each select="subfield[@code = 'h']">
            <physicalDescription>
                <form>
                    <xsl:value-of select="."/>
                </form>
            </physicalDescription>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="relatedExtent" scope="component">
        <xd:desc>relatedExtent</xd:desc>
    </xd:doc>
    <xsl:template name="relatedExtent">

        <xsl:for-each select="subfield[@code = 'h']">
            <physicalDescription>
                <extent>
                    <xsl:value-of select="."/>
                </extent>
            </physicalDescription>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="relatedNote" scope="component">
        <xd:desc>relatedNote</xd:desc>
    </xd:doc>
    <xsl:template name="relatedNote">

        <xsl:for-each select="subfield[@code = 'n']">
            <note>
                <xsl:value-of select="."/>
            </note>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="relatedSubject" scope="component">
        <xd:desc>relatedSubject</xd:desc>
    </xd:doc>
    <xsl:template name="relatedSubject">

        <xsl:for-each select="subfield[@code = 'j']">
            <subject>
                <temporal encoding="iso8601">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                </temporal>
            </subject>
        </xsl:for-each>
    </xsl:template>

    <!--Revision 2.10 added condtional statement if ISSN is empty from 773, use 914 subfield b cm3 12/09/2022-->
    <xd:doc id="relatedIdentifierISSN" scope="component">
        <xd:desc>relatedIdentifierISSN</xd:desc>
    </xd:doc>
    <xsl:template name="relatedIdentifierISSN">
        <xsl:choose>
            <xsl:when test="subfield[@code = 'x'] != ''">
                <xsl:for-each select="subfield[@code = 'x']">
                    <identifier type="issn">
                        <xsl:value-of select="."/>
                    </identifier>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="../datafield[@tag = 914]/subfield[@code = 'b'] != ''">
                <xsl:for-each select="../datafield[@tag = 914]/subfield[@code = 'b']">
                    <identifier type="issn">
                        <xsl:value-of select="."/>
                    </identifier>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--Revision 2.11 added condtional statement if agid:# is empty from 773, use 914 subfield a cm3 12/09/2022-->
    <xd:doc id="relatedIdentifierLocal" scope="component">
        <xd:desc>relatedIdentifierLocal</xd:desc>
    </xd:doc>
    <xsl:template name="relatedIdentifierLocal">
        <xsl:choose>
            <xsl:when test="subfield[@code = 'w'] != ''">
                <xsl:for-each select="subfield[@code = 'w']">
                    <identifier type="local">
                        <xsl:value-of select="."/>
                    </identifier>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="../datafield[@tag = 914]/subfield[@code = 'a']">
                    <identifier type="local">
                        <xsl:value-of select="."/>
                    </identifier>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <xd:doc id="relatedIdentifier" scope="component">
        <xd:desc>relatedIdentifier</xd:desc>
    </xd:doc>
    <xsl:template name="relatedIdentifier">

        <xsl:for-each select="subfield[@code = 'o']">
            <identifier>
                <xsl:value-of select="."/>
            </identifier>
        </xsl:for-each>
    </xsl:template>


    <xd:doc id="relatedItem510" scope="component">
        <xd:desc>tmee 1.40 510 isReferencedBy </xd:desc>
    </xd:doc>
    <xsl:template name="relatedItem510">
        <xsl:call-template name="displayLabel"/>
        <xsl:call-template name="relatedTitle76X-78X"/>
        <xsl:call-template name="relatedName"/>
        <!--<xsl:call-template name="relatedOriginInfo510"/>-->
        <xsl:call-template name="relatedLanguage"/>
        <xsl:call-template name="relatedExtent"/>
        <xsl:call-template name="relatedNote"/>
        <xsl:call-template name="relatedSubject"/>
        <xsl:call-template name="relatedIdentifier"/>
        <xsl:call-template name="relatedIdentifierISSN"/>
        <xsl:call-template name="relatedIdentifierLocal"/>
        <xsl:call-template name="relatedPart"/>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="relatedItem76X-78X">
        <xsl:call-template name="displayLabel"/>
        <xsl:call-template name="relatedTitle76X-78X"/>
        <xsl:call-template name="relatedName"/>
        <!--<xsl:call-template name="relatedOriginInfo"/>-->
        <xsl:call-template name="relatedLanguage"/>
        <xsl:call-template name="relatedExtent"/>
        <xsl:call-template name="relatedNote"/>
        <xsl:call-template name="relatedSubject"/>
        <xsl:call-template name="relatedIdentifier"/>
        <xsl:call-template name="relatedIdentifierISSN"/>
        <xsl:call-template name="relatedIdentifierLocal"/>
        <xsl:call-template name="relatedPart"/>
    </xsl:template>
    <xd:doc id="subjectGeographicZ" scope="component">
        <xd:desc>subjectGeographicZ</xd:desc>
    </xd:doc>
    <xsl:template name="subjectGeographicZ">

        <geographic>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
        </geographic>
    </xsl:template>
    <xd:doc id="subjectTemporalY" scope="component">
        <xd:desc>subjectTemporalY</xd:desc>
    </xd:doc>
    <xsl:template name="subjectTemporalY">

        <temporal>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
        </temporal>
    </xsl:template>
    <xd:doc id="subjectTopic" scope="component">
        <xd:desc>subjectTopic</xd:desc>
    </xd:doc>
    <xsl:template name="subjectTopic">

        <topic>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>

        </topic>
    </xsl:template>



    <xd:doc id="subjectGenre" scope="component">
        <xd:desc> 3.2 change tmee 6xx $v genre </xd:desc>
    </xd:doc>
    <xsl:template name="subjectGenre">
        <genre>
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="."/>
            </xsl:call-template>
        </genre>
    </xsl:template>

    <xd:doc id="nameABCDN" scope="component">
        <xd:desc>nameABCDN</xd:desc>
    </xd:doc>
    <xsl:template name="nameABCDN">

        <xsl:for-each select="subfield[@code = 'a']">
            <namePart>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
            </namePart>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'b']">
            <namePart>
                <xsl:value-of select="."/>
            </namePart>
        </xsl:for-each>
        <xsl:if test="subfield[@code = 'c'] or subfield[@code = 'd'] or subfield[@code = 'n']">
            <namePart>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">cdn</xsl:with-param>
                </xsl:call-template>
            </namePart>
        </xsl:if>
    </xsl:template>
    <xd:doc id="nameABCDQ" scope="component">
        <xd:desc>nameABCDQ</xd:desc>
    </xd:doc>
    <xsl:template name="nameABCDQ">

        <!--<namePart>
			<xsl:call-template name="chopPunctuation">
				<xsl:with-param name="chopString">
					<xsl:call-template name="subfieldSelect">
						<xsl:with-param name="codes">aq</xsl:with-param>
					</xsl:call-template>-\->
				</xsl:with-param>
				<xsl:with-param name="punctuation">
					<xsl:text>.:,;/ </xsl:text>
				</xsl:with-param>
			</xsl:call-template>-->
        <!--</namePart>-->
        <xsl:call-template name="termsOfAddress"/>
        <xsl:call-template name="nameDate"/>
    </xsl:template>
    <xd:doc id="nameACDEQ" scope="component">
        <xd:desc>nameACDEQ</xd:desc>
    </xd:doc>
    <xsl:template name="nameACDEQ">

        <namePart>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">acdeq</xsl:with-param>
            </xsl:call-template>
        </namePart>
    </xsl:template>
    <xd:doc id="constituentOrRelatedType" scope="component">
        <xd:desc>constituentOrRelatedType</xd:desc>
    </xd:doc>
    <xsl:template name="constituentOrRelatedType">

        <xsl:if test="@ind2 = '2'">
            <xsl:attribute name="type">constituent</xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xd:doc id="relatedTitle" scope="component">
        <xd:desc>relatedTitle</xd:desc>
    </xd:doc>
    <xsl:template name="relatedTitle">

        <xsl:for-each select="subfield[@code = 't']">
            <titleInfo>
                <title>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </title>
            </titleInfo>
        </xsl:for-each>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="relatedTitle76X-78X">
        <xsl:for-each select="subfield[@code = 't']">
            <titleInfo>
                <title>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </title>
                <xsl:if test="datafield[@tag != 773] and subfield[@code = 'g']">
                    <xsl:call-template name="relatedPartNumName"/>
                </xsl:if>
            </titleInfo>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'p']">
            <titleInfo type="abbreviated">
                <title>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </title>
                <xsl:if test="datafield[@tag != 773] and subfield[@code = 'g']">
                    <xsl:call-template name="relatedPartNumName"/>
                </xsl:if>
            </titleInfo>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 's']">
            <titleInfo type="uniform">
                <title>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="normalize-space(.)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </title>
                <xsl:if test="datafield[@tag != 773] and subfield[@code = 'g']">
                    <xsl:call-template name="relatedPartNumName"/>
                </xsl:if>
            </titleInfo>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="relatedOriginInfo" scope="component">
        <xd:desc>relatedOriginInfo</xd:desc>
    </xd:doc>
    <xsl:template name="relatedOriginInfo">

        <xsl:if test="subfield[@code = 'b' or @code = 'd'] or subfield[@code = 'f']">
            <originInfo>
                <xsl:if test="@tag = 775">
                    <xsl:for-each select="subfield[@code = 'f']">
                        <place>
                            <placeTerm>
                                <xsl:attribute name="type">code</xsl:attribute>
                                <xsl:attribute name="authority">marcgac</xsl:attribute>
                                <xsl:value-of select="."/>
                            </placeTerm>
                        </place>
                    </xsl:for-each>
                </xsl:if>
                <xsl:for-each select="subfield[@code = 'd']">
                    <publisher>
                        <xsl:value-of select="."/>
                    </publisher>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'b']">
                    <edition>
                        <xsl:value-of select="."/>
                    </edition>
                </xsl:for-each>
            </originInfo>
        </xsl:if>
    </xsl:template>
    <xd:doc id="relatedOriginInfo510" scope="component">
        <xd:desc>relatedOriginInfo510</xd:desc>
    </xd:doc>
    <xsl:template name="relatedOriginInfo510">

        <xsl:for-each select="subfield[@code = 'b']">
            <originInfo>
                <dateOther type="coverage">
                    <xsl:value-of select="."/>
                </dateOther>
            </originInfo>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="relatedLanguage" scope="component">
        <xd:desc>relatedLanguage</xd:desc>
    </xd:doc>
    <xsl:template name="relatedLanguage">

        <xsl:for-each select="subfield[@code = 'e']">
            <xsl:call-template name="getLanguage">
                <xsl:with-param name="langString">
                    <xsl:value-of select="."/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="nameDate" scope="component">
        <xd:desc>nameDate</xd:desc>
    </xd:doc>
    <xsl:template name="nameDate">

        <xsl:for-each select="subfield[@code = 'd']">
            <namePart type="date">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString" select="."/>
                </xsl:call-template>
            </namePart>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="subjectAuthority" scope="component">
        <xd:desc>subjectAuthority</xd:desc>
    </xd:doc>
    <xsl:template name="subjectAuthority">

        <xsl:if test="@ind2 != '4'">
            <xsl:if test="@ind2 != ' '">
                <xsl:if test="@ind2 != '8'">
                    <xsl:if test="@ind2 != '9'">
                        <xsl:attribute name="authority">
                            <xsl:choose>
                                <xsl:when test="@ind2 = '0'">lcsh</xsl:when>
                                <xsl:when test="@ind2 = '1'">lcshac</xsl:when>
                                <xsl:when test="@ind2 = '2'">mesh</xsl:when>
                                <!-- 1/04 fix
								06/14 Change nal code to atg code for NALT terms-->
                                <xsl:when test="@ind2 = '3'">atg</xsl:when>
                                <xsl:when test="@ind2 = '5'">csh</xsl:when>
                                <xsl:when test="@ind2 = '6'">rvm</xsl:when>
                                <xsl:when test="@ind2 = '7'">
                                    <xsl:value-of select="subfield[@code = '2']"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc> 1.75 fix </xd:desc>
    </xd:doc>
    <xsl:template name="subject653Type">
        <xsl:if test="@ind2 != ' '">
            <xsl:if test="@ind2 != '0'">
                <xsl:if test="@ind2 != '4'">
                    <xsl:if test="@ind2 != '5'">
                        <xsl:if test="@ind2 != '6'">
                            <xsl:if test="@ind2 != '7'">
                                <xsl:if test="@ind2 != '8'">
                                    <xsl:if test="@ind2 != '9'">
                                        <xsl:attribute name="type">
                                            <xsl:choose>
                                                <xsl:when test="@ind2 = '1'">personal</xsl:when>
                                                <xsl:when test="@ind2 = '2'">corporate</xsl:when>
                                                <xsl:when test="@ind2 = '3'">conference</xsl:when>
                                            </xsl:choose>
                                        </xsl:attribute>
                                    </xsl:if>
                                </xsl:if>
                            </xsl:if>
                        </xsl:if>
                    </xsl:if>
                </xsl:if>
            </xsl:if>
        </xsl:if>


    </xsl:template>
    <xd:doc id="subjectAnyOrder" scope="component">
        <xd:desc>subjectAnyOrder</xd:desc>
    </xd:doc>
    <xsl:template name="subjectAnyOrder">

        <xsl:for-each select="subfield[@code = 'v' or @code = 'x' or @code = 'y' or @code = 'z']">
            <xsl:choose>
                <xsl:when test="@code = 'v'">
                    <xsl:call-template name="subjectGenre"/>
                </xsl:when>
                <xsl:when test="@code = 'x'">
                    <xsl:call-template name="subjectTopic"/>
                </xsl:when>
                <xsl:when test="@code = 'y'">
                    <xsl:call-template name="subjectTemporalY"/>
                </xsl:when>
                <xsl:when test="@code = 'z'">
                    <xsl:call-template name="subjectGeographicZ"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="specialSubfieldSelect" scope="component">
        <xd:desc>Special Subfield Select</xd:desc>
        <xd:param name="anyCodes"/>
        <xd:param name="axis"/>
        <xd:param name="beforeCodes"/>
        <xd:param name="afterCodes"/>
    </xd:doc>
    <xsl:template name="specialSubfieldSelect">
        <xsl:param name="anyCodes"/>
        <xsl:param name="axis"/>
        <xsl:param name="beforeCodes"/>
        <xsl:param name="afterCodes"/>
        <xsl:variable name="str">
            <xsl:for-each select="subfield">
                <xsl:if
                    test="contains($anyCodes, @code) or (contains($beforeCodes, @code) and following-sibling::subfield[@code = $axis]) or (contains($afterCodes, @code) and preceding-sibling::subfield[@code = $axis])">
                    <xsl:value-of select="text()"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:variable>
        <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
    </xsl:template>


    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="datafield[@tag = 656]">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:if test="subfield[@code = '2']">
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
            </xsl:if>
            <occupation>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="subfield[@code = 'a']"/>
                    </xsl:with-param>
                </xsl:call-template>
            </occupation>
        </subject>
    </xsl:template>
    <xd:doc id="termsOfAddress" scope="component">
        <xd:desc/>
    </xd:doc>
    <xsl:template name="termsOfAddress">

        <xsl:if test="subfield[@code = 'b' or @code = 'c']">
            <namePart type="termsOfAddress">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">bc</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </namePart>
        </xsl:if>
    </xsl:template>
    <xd:doc id="displayLabel" scope="component">
        <xd:desc>displayLabel</xd:desc>
    </xd:doc>
    <xsl:template name="displayLabel">

        <xsl:if test="subfield[@code = 'i']">
            <xsl:attribute name="displayLabel">
                <xsl:value-of select="subfield[@code = 'i']"/>
            </xsl:attribute>
        </xsl:if>
        <xsl:if test="subfield[@code = '3']">
            <xsl:attribute name="displayLabel">
                <xsl:value-of select="subfield[@code = '3']"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>


    <!--  <xd:doc>
        <xd:desc> isInvalid </xd:desc>
    </xd:doc>
    <xsl:template name="isInvalid">
        <xsl:param name="type"/>
        <xsl:if test="subfield[@code = 'z'] or subfield[@code = 'y'] or subfield[@code = 'm']">
            <identifier>
                <xsl:attribute name="type">
                    <xsl:value-of select="$type"/>
                </xsl:attribute>
                <xsl:attribute name="invalid">
                    <xsl:text>yes</xsl:text>
                </xsl:attribute>
                <xsl:if test="subfield[@code = 'z']">
                    <xsl:value-of select="subfield[@code = 'z']"/>
                </xsl:if>
                <xsl:if test="subfield[@code = 'y']">
                    <xsl:value-of select="subfield[@code = 'y']"/>
                </xsl:if>
                <xsl:if test="subfield[@code = 'm']">
                    <xsl:value-of select="subfield[@code = 'm']"/>
                </xsl:if>
            </identifier>
        </xsl:if>
    </xsl:template>-->
    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template name="subtitle">
        <xsl:if test="subfield[@code = 'b']">
            <subTitle>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="subfield[@code = 'b']"/>
                        <!--<xsl:call-template name="subfieldSelect">
							<xsl:with-param name="codes">b</xsl:with-param>
						</xsl:call-template>-->
                    </xsl:with-param>
                </xsl:call-template>
            </subTitle>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="scriptCode"/>
    </xd:doc>
    <xsl:template name="script">
        <xsl:param name="scriptCode"/>
        <xsl:attribute name="script">
            <xsl:choose>
                <!-- ISO 15924	and CJK is a local code	20101123-->
                <xsl:when test="$scriptCode = '(3'">Arab</xsl:when>
                <xsl:when test="$scriptCode = '(4'">Arab</xsl:when>
                <xsl:when test="$scriptCode = '(B'">Latn</xsl:when>
                <xsl:when test="$scriptCode = '!E'">Latn</xsl:when>
                <xsl:when test="$scriptCode = '$1'">CJK</xsl:when>
                <xsl:when test="$scriptCode = '(N'">Cyrl</xsl:when>
                <xsl:when test="$scriptCode = '(Q'">Cyrl</xsl:when>
                <xsl:when test="$scriptCode = '(2'">Hebr</xsl:when>
                <xsl:when test="$scriptCode = '(S'">Grek</xsl:when>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>
    <xd:doc id="parsePart" scope="component">
        <xd:desc>parsePart</xd:desc>
    </xd:doc>
    <xsl:template name="parsePart">

        <!-- assumes 773$q= 1:2:3<4
		     with up to 3 levels and one optional start page
		-->
        <xsl:variable name="level1">
            <xsl:choose>
                <xsl:when test="contains(text(), ':')">
                    <!-- 1:2 -->
                    <xsl:value-of select="substring-before(text(), ':')"/>
                </xsl:when>
                <xsl:when test="not(contains(text(), ':'))">
                    <!-- 1 or 1<3 -->
                    <xsl:if test="contains(text(), '&lt;')">
                        <!-- 1<3 -->
                        <xsl:value-of select="substring-before(text(), '&lt;')"/>
                    </xsl:if>
                    <xsl:if test="not(contains(text(), '&lt;'))">
                        <!-- 1 -->
                        <xsl:value-of select="text()"/>
                    </xsl:if>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sici2">
            <xsl:choose>
                <xsl:when test="starts-with(substring-after(text(), $level1), ':')">
                    <xsl:value-of select="substring(substring-after(text(), $level1), 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after(text(), $level1)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="level2">
            <xsl:choose>
                <xsl:when test="contains($sici2, ':')">
                    <!--  2:3<4  -->
                    <xsl:value-of select="substring-before($sici2, ':')"/>
                </xsl:when>
                <xsl:when test="contains($sici2, '&lt;')">
                    <!-- 1: 2<4 -->
                    <xsl:value-of select="substring-before($sici2, '&lt;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$sici2"/>
                    <!-- 1:2 -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="sici3">
            <xsl:choose>
                <xsl:when test="starts-with(substring-after($sici2, $level2), ':')">
                    <xsl:value-of select="substring(substring-after($sici2, $level2), 2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="substring-after($sici2, $level2)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="level3">
            <xsl:choose>
                <xsl:when test="contains($sici3, '&lt;')">
                    <!-- 2<4 -->
                    <xsl:value-of select="substring-before($sici3, '&lt;')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$sici3"/>
                    <!-- 3 -->
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="page">
            <xsl:if test="contains(text(), '&lt;')">
                <xsl:value-of select="substring-after(text(), '&lt;')"/>
            </xsl:if>
        </xsl:variable>
        <xsl:if test="$level1">
            <detail level="1">
                <number>
                    <xsl:value-of select="$level1"/>
                </number>
            </detail>
        </xsl:if>
        <xsl:if test="$level2">
            <detail level="2">
                <number>
                    <xsl:value-of select="$level2"/>
                </number>
            </detail>
        </xsl:if>
        <xsl:if test="$level3">
            <detail level="3">
                <number>
                    <xsl:value-of select="$level3"/>
                </number>
            </detail>
        </xsl:if>
        <xsl:if test="$page">
            <extent unit="page">
                <start>
                    <xsl:value-of select="$page"/>
                </start>
            </extent>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="langString"/>
        <xd:param name="controlField008-35-37"/>
    </xd:doc>
    <xsl:template name="getLanguage">
        <xsl:param name="langString"/>
        <xsl:param name="controlField008-35-37"/>
        <xsl:variable name="length" select="string-length($langString)"/>
        <xsl:choose>
            <xsl:when test="$length = 0"/>
            <xsl:when test="$controlField008-35-37 = substring($langString, 1, 3)">
                <xsl:call-template name="getLanguage">
                    <xsl:with-param name="langString" select="substring($langString, 4, $length)"/>
                    <xsl:with-param name="controlField008-35-37" select="$controlField008-35-37"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <language>
                    <languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="substring($langString, 1, 3)"/>
                    </languageTerm>
                </language>
                <xsl:call-template name="getLanguage">
                    <xsl:with-param name="langString" select="substring($langString, 4, $length)"/>
                    <xsl:with-param name="controlField008-35-37" select="$controlField008-35-37"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="currentLanguage"/>
        <xd:param name="usedLanguages"/>
        <xd:param name="remainingLanguages"/>
    </xd:doc>
    <xsl:template name="isoLanguage">
        <xsl:param name="currentLanguage"/>
        <xsl:param name="usedLanguages"/>
        <xsl:param name="remainingLanguages"/>
        <xsl:choose>
            <xsl:when test="string-length($currentLanguage) = 0"/>
            <xsl:when test="not(contains($usedLanguages, $currentLanguage))">
                <language>
                    <xsl:if test="@code != 'a'">
                        <xsl:attribute name="objectPart">
                            <xsl:choose>
                                <xsl:when test="@code = 'b'">summary or subtitle</xsl:when>
                                <xsl:when test="@code = 'd'">sung or spoken text</xsl:when>
                                <xsl:when test="@code = 'e'">libretto</xsl:when>
                                <xsl:when test="@code = 'f'">table of contents</xsl:when>
                                <xsl:when test="@code = 'g'">accompanying material</xsl:when>
                                <xsl:when test="@code = 'h'">translation</xsl:when>
                            </xsl:choose>
                        </xsl:attribute>
                    </xsl:if>
                    <languageTerm authority="iso639-2b" type="code">
                        <xsl:value-of select="$currentLanguage"/>
                    </languageTerm>
                </language>
                <xsl:call-template name="isoLanguage">
                    <xsl:with-param name="currentLanguage">
                        <xsl:value-of select="substring($remainingLanguages, 1, 3)"/>
                    </xsl:with-param>
                    <xsl:with-param name="usedLanguages">
                        <xsl:value-of select="concat($usedLanguages, $currentLanguage)"/>
                    </xsl:with-param>
                    <xsl:with-param name="remainingLanguages">
                        <xsl:value-of
                            select="substring($remainingLanguages, 4, string-length($remainingLanguages))"
                        />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="isoLanguage">
                    <xsl:with-param name="currentLanguage">
                        <xsl:value-of select="substring($remainingLanguages, 1, 3)"/>
                    </xsl:with-param>
                    <xsl:with-param name="usedLanguages">
                        <xsl:value-of select="concat($usedLanguages, $currentLanguage)"/>
                    </xsl:with-param>
                    <xsl:with-param name="remainingLanguages">
                        <xsl:value-of
                            select="substring($remainingLanguages, 4, string-length($remainingLanguages))"
                        />
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="chopString"/>
    </xd:doc>
    <xsl:template name="chopBrackets">
        <xsl:param name="chopString"/>
        <xsl:variable name="string">
            <xsl:call-template name="chopPunctuation">
                <xsl:with-param name="chopString" select="$chopString"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:if test="substring($string, 1, 1) = '['">
            <xsl:value-of select="substring($string, 2, string-length($string) - 2)"/>
        </xsl:if>
        <xsl:if test="substring($string, 1, 1) != '['">
            <xsl:value-of select="$string"/>
        </xsl:if>
    </xsl:template>
    <xd:doc>
        <xd:desc/>
        <xd:param name="nodeNum"/>
        <xd:param name="usedLanguages"/>
        <xd:param name="controlField008-35-37"/>
    </xd:doc>
    <xsl:template name="rfcLanguages">
        <xsl:param name="nodeNum"/>
        <xsl:param name="usedLanguages"/>
        <xsl:param name="controlField008-35-37"/>
        <xsl:variable name="currentLanguage" select="."/>
        <xsl:choose>
            <xsl:when test="not($currentLanguage)"/>
            <xsl:when
                test="$currentLanguage != $controlField008-35-37 and $currentLanguage != 'rfc3066'">
                <xsl:if test="not(contains($usedLanguages, $currentLanguage))">
                    <language>
                        <xsl:if test="@code != 'a'">
                            <xsl:attribute name="objectPart">
                                <xsl:choose>
                                    <xsl:when test="@code = 'b'">summary or subtitle</xsl:when>
                                    <xsl:when test="@code = 'd'">sung or spoken text</xsl:when>
                                    <xsl:when test="@code = 'e'">libretto</xsl:when>
                                    <xsl:when test="@code = 'f'">table of contents</xsl:when>
                                    <xsl:when test="@code = 'g'">accompanying material</xsl:when>
                                    <xsl:when test="@code = 'h'">translation</xsl:when>
                                </xsl:choose>
                            </xsl:attribute>
                        </xsl:if>
                        <languageTerm authority="rfc3066" type="code">
                            <xsl:value-of select="$currentLanguage"/>
                        </languageTerm>
                    </language>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise> </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xd:doc>
        <xd:desc> tmee added 20100106 for 045$b BC and CE date range info </xd:desc>
        <xd:param name="str"/>
    </xd:doc>
    <xsl:template name="dates045b">
        <xsl:param name="str"/>
        <xsl:variable name="first-char" select="substring($str, 1, 1)"/>
        <xsl:choose>
            <xsl:when test="$first-char = 'c'">
                <xsl:value-of select="concat('-', substring($str, 2))"/>
            </xsl:when>
            <xsl:when test="$first-char = 'd'">
                <xsl:value-of select="substring($str, 2)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$str"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    <xd:doc id="scriptCode" scope="component">
        <xd:desc>scriptCode</xd:desc>
    </xd:doc>
    <xsl:template name="scriptCode">

        <xsl:variable name="sf06" select="normalize-space(child::subfield[@code = '6'])"/>
        <xsl:variable name="sf06a" select="substring($sf06, 1, 3)"/>
        <xsl:variable name="sf06b" select="substring($sf06, 5, 2)"/>
        <xsl:variable name="sf06c" select="substring($sf06, 7)"/>
        <xsl:variable name="scriptCode" select="substring($sf06, 8, 2)"/>
        <xsl:if test="//datafield/subfield[@code = '6']">
            <xsl:attribute name="script">
                <xsl:choose>
                    <xsl:when test="$scriptCode = ''">Latn</xsl:when>
                    <xsl:when test="$scriptCode = '(3'">Arab</xsl:when>
                    <xsl:when test="$scriptCode = '(4'">Arab</xsl:when>
                    <xsl:when test="$scriptCode = '(B'">Latn</xsl:when>
                    <xsl:when test="$scriptCode = '!E'">Latn</xsl:when>
                    <xsl:when test="$scriptCode = '$1'">CJK</xsl:when>
                    <xsl:when test="$scriptCode = '(N'">Cyrl</xsl:when>
                    <xsl:when test="$scriptCode = '(Q'">Cyrl</xsl:when>
                    <xsl:when test="$scriptCode = '(2'">Hebr</xsl:when>
                    <xsl:when test="$scriptCode = '(S'">Grek</xsl:when>
                </xsl:choose>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
    <xd:doc id="xxx880" scope="component">
        <xd:desc> tmee 20100927 for 880s &amp; corresponding fields 20101123 scriptCode </xd:desc>
    </xd:doc>
    <xsl:template name="xxx880">
        <xsl:if test="child::subfield[@code = '6']">
            <xsl:variable name="sf06" select="normalize-space(child::subfield[@code = '6'])"/>
            <xsl:variable name="sf06a" select="substring($sf06, 1, 3)"/>
            <xsl:variable name="sf06b" select="substring($sf06, 5, 2)"/>
            <xsl:variable name="sf06c" select="substring($sf06, 7)"/>
            <xsl:variable name="scriptCode" select="substring($sf06, 8, 2)"/>
            <xsl:if test="//datafield/subfield[@code = '6']">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$sf06b"/>
                </xsl:attribute>
                <xsl:attribute name="script">
                    <xsl:choose>
                        <xsl:when test="$scriptCode = ''">Latn</xsl:when>
                        <xsl:when test="$scriptCode = '(3'">Arab</xsl:when>
                        <xsl:when test="$scriptCode = '(4'">Arab</xsl:when>
                        <xsl:when test="$scriptCode = '(B'">Latn</xsl:when>
                        <xsl:when test="$scriptCode = '!E'">Latn</xsl:when>
                        <xsl:when test="$scriptCode = '$1'">CJK</xsl:when>
                        <xsl:when test="$scriptCode = '(N'">Cyrl</xsl:when>
                        <xsl:when test="$scriptCode = '(Q'">Cyrl</xsl:when>
                        <xsl:when test="$scriptCode = '(2'">Hebr</xsl:when>
                        <xsl:when test="$scriptCode = '(S'">Grek</xsl:when>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xd:doc id="yyy880" scope="component">
        <xd:desc>yyy880</xd:desc>
    </xd:doc>
    <xsl:template name="yyy880">

        <xsl:if test="preceding-sibling::subfield[@code = '6']">
            <xsl:variable name="sf06"
                select="normalize-space(preceding-sibling::subfield[@code = '6'])"/>
            <xsl:variable name="sf06a" select="substring($sf06, 1, 3)"/>
            <xsl:variable name="sf06b" select="substring($sf06, 5, 2)"/>
            <xsl:variable name="sf06c" select="substring($sf06, 7)"/>
            <xsl:if test="//datafield/subfield[@code = '6']">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$sf06b"/>
                </xsl:attribute>
            </xsl:if>
        </xsl:if>
    </xsl:template>
    <xd:doc id="z2xx880" scope="component">
        <xd:desc>z2xx880</xd:desc>
    </xd:doc>
    <xsl:template name="z2xx880">

        <!-- Evaluating the 260 field -->
        <xsl:variable name="x260">
            <xsl:choose>
                <xsl:when test="@tag = '260' and subfield[@code = '6']">
                    <xsl:variable name="sf06260"
                        select="normalize-space(child::subfield[@code = '6'])"/>
                    <xsl:variable name="sf06260a" select="substring($sf06260, 1, 3)"/>
                    <xsl:variable name="sf06260b" select="substring($sf06260, 5, 2)"/>
                    <xsl:variable name="sf06260c" select="substring($sf06260, 7)"/>
                    <xsl:value-of select="$sf06260b"/>
                </xsl:when>
                <xsl:when test="@tag = '250' and ../datafield[@tag = '260']/subfield[@code = '6']">
                    <xsl:variable name="sf06260"
                        select="normalize-space(../datafield[@tag = '260']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06260a" select="substring($sf06260, 1, 3)"/>
                    <xsl:variable name="sf06260b" select="substring($sf06260, 5, 2)"/>
                    <xsl:variable name="sf06260c" select="substring($sf06260, 7)"/>
                    <xsl:value-of select="$sf06260b"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="x250">
            <xsl:choose>
                <xsl:when test="@tag = '250' and subfield[@code = '6']">
                    <xsl:variable name="sf06250"
                        select="normalize-space(../datafield[@tag = '250']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06250a" select="substring($sf06250, 1, 3)"/>
                    <xsl:variable name="sf06250b" select="substring($sf06250, 5, 2)"/>
                    <xsl:variable name="sf06250c" select="substring($sf06250, 7)"/>
                    <xsl:value-of select="$sf06250b"/>
                </xsl:when>
                <xsl:when test="@tag = '260' and ../datafield[@tag = '250']/subfield[@code = '6']">
                    <xsl:variable name="sf06250"
                        select="normalize-space(../datafield[@tag = '250']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06250a" select="substring($sf06250, 1, 3)"/>
                    <xsl:variable name="sf06250b" select="substring($sf06250, 5, 2)"/>
                    <xsl:variable name="sf06250c" select="substring($sf06250, 7)"/>
                    <xsl:value-of select="$sf06250b"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$x250 != '' and $x260 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="concat($x250, $x260)"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x250 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x250"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x260 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x260"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="//datafield/subfield[@code = '6']"> </xsl:if>
    </xsl:template>
    <xd:doc id="z3xx880" scope="component">
        <xd:desc>z3xx880</xd:desc>
    </xd:doc>
    <xsl:template name="z3xx880">

        <!-- Evaluating the 300 field -->
        <xsl:variable name="x300">
            <xsl:choose>
                <xsl:when test="@tag = '300' and subfield[@code = '6']">
                    <xsl:variable name="sf06300"
                        select="normalize-space(child::subfield[@code = '6'])"/>
                    <xsl:variable name="sf06300a" select="substring($sf06300, 1, 3)"/>
                    <xsl:variable name="sf06300b" select="substring($sf06300, 5, 2)"/>
                    <xsl:variable name="sf06300c" select="substring($sf06300, 7)"/>
                    <xsl:value-of select="$sf06300b"/>
                </xsl:when>
                <xsl:when test="@tag = '351' and ../datafield[@tag = '300']/subfield[@code = '6']">
                    <xsl:variable name="sf06300"
                        select="normalize-space(../datafield[@tag = '300']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06300a" select="substring($sf06300, 1, 3)"/>
                    <xsl:variable name="sf06300b" select="substring($sf06300, 5, 2)"/>
                    <xsl:variable name="sf06300c" select="substring($sf06300, 7)"/>
                    <xsl:value-of select="$sf06300b"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="x351">
            <xsl:choose>
                <xsl:when test="@tag = '351' and subfield[@code = '6']">
                    <xsl:variable name="sf06351"
                        select="normalize-space(../datafield[@tag = '351']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06351a" select="substring($sf06351, 1, 3)"/>
                    <xsl:variable name="sf06351b" select="substring($sf06351, 5, 2)"/>
                    <xsl:variable name="sf06351c" select="substring($sf06351, 7)"/>
                    <xsl:value-of select="$sf06351b"/>
                </xsl:when>
                <xsl:when test="@tag = '300' and ../datafield[@tag = '351']/subfield[@code = '6']">
                    <xsl:variable name="sf06351"
                        select="normalize-space(../datafield[@tag = '351']/subfield[@code = '6'])"/>
                    <xsl:variable name="sf06351a" select="substring($sf06351, 1, 3)"/>
                    <xsl:variable name="sf06351b" select="substring($sf06351, 5, 2)"/>
                    <xsl:variable name="sf06351c" select="substring($sf06351, 7)"/>
                    <xsl:value-of select="$sf06351b"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="x337">
            <xsl:if test="@tag = '337' and subfield[@code = '6']">
                <xsl:variable name="sf06337" select="normalize-space(child::subfield[@code = '6'])"/>
                <xsl:variable name="sf06337a" select="substring($sf06337, 1, 3)"/>
                <xsl:variable name="sf06337b" select="substring($sf06337, 5, 2)"/>
                <xsl:variable name="sf06337c" select="substring($sf06337, 7)"/>
                <xsl:value-of select="$sf06337b"/>
            </xsl:if>
        </xsl:variable>
        <xsl:variable name="x338">
            <xsl:if test="@tag = '338' and subfield[@code = '6']">
                <xsl:variable name="sf06338" select="normalize-space(child::subfield[@code = '6'])"/>
                <xsl:variable name="sf06338a" select="substring($sf06338, 1, 3)"/>
                <xsl:variable name="sf06338b" select="substring($sf06338, 5, 2)"/>
                <xsl:variable name="sf06338c" select="substring($sf06338, 7)"/>
                <xsl:value-of select="$sf06338b"/>
            </xsl:if>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$x351 != '' and $x300 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="concat($x351, $x300, $x337, $x338)"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x351 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x351"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x300 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x300"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x337 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x351"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$x338 != ''">
                <xsl:attribute name="altRepGroup">
                    <xsl:value-of select="$x300"/>
                </xsl:attribute>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="//datafield/subfield[@code = '6']"> </xsl:if>
    </xsl:template>
    <xd:doc id="true880" scope="component">
        <xd:desc>true880</xd:desc>
    </xd:doc>
    <xsl:template name="true880">

        <xsl:variable name="sf06" select="normalize-space(subfield[@code = '6'])"/>
        <xsl:variable name="sf06a" select="substring($sf06, 1, 3)"/>
        <xsl:variable name="sf06b" select="substring($sf06, 5, 2)"/>
        <xsl:variable name="sf06c" select="substring($sf06, 7)"/>
        <xsl:if test="//datafield/subfield[@code = '6']">
            <xsl:attribute name="altRepGroup">
                <xsl:value-of select="$sf06b"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="datafield" mode="trans880">
        <xsl:variable name="dataField880" select="//datafield"/>
        <xsl:variable name="sf06" select="normalize-space(subfield[@code = '6'])"/>
        <xsl:variable name="sf06a" select="substring($sf06, 1, 3)"/>
        <xsl:variable name="sf06b" select="substring($sf06, 4)"/>
        <xsl:choose>

            <!--tranforms 880 equiv-->

            <xsl:when test="$sf06a = '047'">
                <xsl:call-template name="createGenreFrom047"/>
            </xsl:when>
            <xsl:when test="$sf06a = '336'">
                <xsl:call-template name="createGenreFrom336"/>
            </xsl:when>
            <xsl:when test="$sf06a = '655'">
                <xsl:call-template name="createGenreFrom655"/>
            </xsl:when>

            <xsl:when test="$sf06a = '050'">
                <xsl:call-template name="createClassificationFrom050"/>
            </xsl:when>
            <xsl:when test="$sf06a = '060'">
                <xsl:call-template name="createClassificationFrom060"/>
            </xsl:when>
            <xsl:when test="$sf06a = '080'">
                <xsl:call-template name="createClassificationFrom080"/>
            </xsl:when>
            <xsl:when test="$sf06a = '082'">
                <xsl:call-template name="createClassificationFrom082"/>
            </xsl:when>
            <xsl:when test="$sf06a = '084'">
                <xsl:call-template name="createClassificationFrom080"/>
            </xsl:when>
            <xsl:when test="$sf06a = '086'">
                <xsl:call-template name="createClassificationFrom082"/>
            </xsl:when>
            <xsl:when test="$sf06a = '100'">
                <xsl:call-template name="createNameFrom100"/>
            </xsl:when>
            <xsl:when test="$sf06a = '110'">
                <xsl:call-template name="createNameFrom110"/>
            </xsl:when>
            <xsl:when test="$sf06a = '111'">
                <xsl:call-template name="createNameFrom110"/>
            </xsl:when>
            <xsl:when test="$sf06a = '700'">
                <xsl:call-template name="createNameFrom700"/>
            </xsl:when>
            <xsl:when test="$sf06a = '710'">
                <xsl:call-template name="createNameFrom710"/>
            </xsl:when>
            <xsl:when test="$sf06a = '711'">
                <xsl:call-template name="createNameFrom710"/>
            </xsl:when>
            <xsl:when test="$sf06a = '210'">
                <xsl:call-template name="createTitleInfoFrom210"/>
            </xsl:when>
            <xsl:when test="$sf06a = '245'">
                <xsl:call-template name="createTitleInfoFrom245"/>
                <xsl:call-template name="createNoteFrom245c"/>
            </xsl:when>
            <xsl:when test="$sf06a = '246'">
                <xsl:call-template name="createTitleInfoFrom246"/>
            </xsl:when>
            <xsl:when test="$sf06a = '240'">
                <xsl:call-template name="createTitleInfoFrom240"/>
            </xsl:when>
            <xsl:when test="$sf06a = '740'">
                <xsl:call-template name="createTitleInfoFrom740"/>
            </xsl:when>

            <xsl:when test="$sf06a = '130'">
                <xsl:call-template name="createTitleInfoFrom130"/>
            </xsl:when>
            <xsl:when test="$sf06a = '730'">
                <xsl:call-template name="createTitleInfoFrom730"/>
            </xsl:when>

            <xsl:when test="$sf06a = '505'">
                <xsl:call-template name="createTOCFrom505"/>
            </xsl:when>
            <xsl:when test="$sf06a = '520'">
                <xsl:call-template name="createAbstractFrom520"/>
            </xsl:when>
            <xsl:when test="$sf06a = '521'">
                <xsl:call-template name="createTargetAudienceFrom521"/>
            </xsl:when>
            <xsl:when test="$sf06a = '506'">
                <xsl:call-template name="createAccessConditionFrom506"/>
            </xsl:when>
            <xsl:when test="$sf06a = '540'">
                <xsl:call-template name="createAccessConditionFrom540"/>
            </xsl:when>

            <!-- note 245 362 etc	-->

            <xsl:when test="$sf06a = '245'">
                <xsl:call-template name="createNoteFrom245c"/>
            </xsl:when>
            <xsl:when test="$sf06a = '362'">
                <xsl:call-template name="createNoteFrom362"/>
            </xsl:when>
            <xsl:when test="$sf06a = '502'">
                <xsl:call-template name="createNoteFrom502"/>
            </xsl:when>
            <xsl:when test="$sf06a = '504'">
                <xsl:call-template name="createNoteFrom504"/>
            </xsl:when>
            <xsl:when test="$sf06a = '508'">
                <xsl:call-template name="createNoteFrom508"/>
            </xsl:when>
            <xsl:when test="$sf06a = '511'">
                <xsl:call-template name="createNoteFrom511"/>
            </xsl:when>
            <xsl:when test="$sf06a = '515'">
                <xsl:call-template name="createNoteFrom515"/>
            </xsl:when>
            <xsl:when test="$sf06a = '518'">
                <xsl:call-template name="createNoteFrom518"/>
            </xsl:when>
            <xsl:when test="$sf06a = '524'">
                <xsl:call-template name="createNoteFrom524"/>
            </xsl:when>
            <xsl:when test="$sf06a = '530'">
                <xsl:call-template name="createNoteFrom530"/>
            </xsl:when>
            <xsl:when test="$sf06a = '533'">
                <xsl:call-template name="createNoteFrom533"/>
            </xsl:when>
            <!--
			<xsl:when test="$sf06a='534'">
				<xsl:call-template name="createNoteFrom534"/>
			</xsl:when>
-->
            <xsl:when test="$sf06a = '535'">
                <xsl:call-template name="createNoteFrom535"/>
            </xsl:when>
            <xsl:when test="$sf06a = '536'">
                <xsl:call-template name="createNoteFrom536"/>
            </xsl:when>
            <xsl:when test="$sf06a = '538'">
                <xsl:call-template name="createNoteFrom538"/>
            </xsl:when>
            <xsl:when test="$sf06a = '541'">
                <xsl:call-template name="createNoteFrom541"/>
            </xsl:when>
            <xsl:when test="$sf06a = '545'">
                <xsl:call-template name="createNoteFrom545"/>
            </xsl:when>
            <xsl:when test="$sf06a = '546'">
                <xsl:call-template name="createNoteFrom546"/>
            </xsl:when>
            <xsl:when test="$sf06a = '561'">
                <xsl:call-template name="createNoteFrom561"/>
            </xsl:when>
            <xsl:when test="$sf06a = '562'">
                <xsl:call-template name="createNoteFrom562"/>
            </xsl:when>
            <xsl:when test="$sf06a = '581'">
                <xsl:call-template name="createNoteFrom581"/>
            </xsl:when>
            <xsl:when test="$sf06a = '583'">
                <xsl:call-template name="createNoteFrom583"/>
            </xsl:when>
            <xsl:when test="$sf06a = '585'">
                <xsl:call-template name="createNoteFrom585"/>
            </xsl:when>

            <!--	note 5XX	-->

            <xsl:when test="$sf06a = '501'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '507'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '513'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '514'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '516'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '522'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '525'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '526'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '544'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '552'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '555'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '556'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '565'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '567'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '580'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '584'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>
            <xsl:when test="$sf06a = '586'">
                <xsl:call-template name="createNoteFrom5XX"/>
            </xsl:when>

            <!--  subject 034 043 045 255 656 662 752 	-->

            <xsl:when test="$sf06a = '034'">
                <xsl:call-template name="createSubGeoFrom034"/>
            </xsl:when>
            <xsl:when test="$sf06a = '043'">
                <xsl:call-template name="createSubGeoFrom043"/>
            </xsl:when>
            <xsl:when test="$sf06a = '045'">
                <xsl:call-template name="createSubTemFrom045"/>
            </xsl:when>
            <xsl:when test="$sf06a = '255'">
                <xsl:call-template name="createSubGeoFrom255"/>
            </xsl:when>

            <xsl:when test="$sf06a = '600'">
                <xsl:call-template name="createSubNameFrom600"/>
            </xsl:when>
            <xsl:when test="$sf06a = '610'">
                <xsl:call-template name="createSubNameFrom610"/>
            </xsl:when>
            <xsl:when test="$sf06a = '611'">
                <xsl:call-template name="createSubNameFrom611"/>
            </xsl:when>

            <xsl:when test="$sf06a = '630'">
                <xsl:call-template name="createSubTitleFrom630"/>
            </xsl:when>

            <xsl:when test="$sf06a = '648'">
                <xsl:call-template name="createSubChronFrom648"/>
            </xsl:when>
            <xsl:when test="$sf06a = '650'">
                <xsl:call-template name="createSubTopFrom650"/>
            </xsl:when>
            <xsl:when test="$sf06a = '651'">
                <xsl:call-template name="createSubGeoFrom651"/>
            </xsl:when>


            <xsl:when test="$sf06a = '653'">
                <xsl:call-template name="createSubFrom653"/>
            </xsl:when>
            <xsl:when test="$sf06a = '656'">
                <xsl:call-template name="createSubFrom656"/>
            </xsl:when>
            <xsl:when test="$sf06a = '662'">
                <xsl:call-template name="createSubGeoFrom662752"/>
            </xsl:when>
            <xsl:when test="$sf06a = '752'">
                <xsl:call-template name="createSubGeoFrom662752"/>
            </xsl:when>

            <!--  location  852 856 -->

            <xsl:when test="$sf06a = '852'">
                <xsl:call-template name="createLocationFrom852"/>
            </xsl:when>
            <xsl:when test="$sf06a = '856'">
                <xsl:call-template name="createLocationFrom856"/>
            </xsl:when>

            <xsl:when test="$sf06a = '490'">
                <xsl:call-template name="createRelatedItemFrom490"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!-- titleInfo 130 730 245 246 240 740 210 -->
    <xd:doc id="createTitleInfoFrom130" scope="component">
        <xd:desc> 130 </xd:desc>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom130">
        <xsl:for-each select="datafield[@tag = '130'][@ind2 != '2']">
            <titleInfo type="uniform">
                <title>
                    <xsl:variable name="this">
                        <xsl:variable name="str">
                            <xsl:for-each select="subfield">
                                <xsl:if test="(contains('s', @code))">
                                    <xsl:value-of select="text()"/>
                                    <xsl:text>&#160;</xsl:text>
                                </xsl:if>
                                <xsl:if
                                    test="(contains('adfklmors', @code) and (not(../subfield[@code = 'n' or @code = 'p']) or (following-sibling::subfield[@code = 'n' or @code = 'p'])))">
                                    <xsl:value-of select="text()"/>
                                    <xsl:text>&#160;</xsl:text>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <!-- 2.13 -->
                    <xsl:value-of select="normalize-space($this)"/>

                </title>
                <xsl:call-template name="part"/>
            </titleInfo>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="createTitleInfoFrom730" scope="component">
        <xd:desc>createTitleInfoFrom730</xd:desc>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom730">

        <titleInfo type="uniform">
            <title>
                <xsl:variable name="this">
                    <xsl:variable name="str">
                        <xsl:for-each select="subfield">
                            <xsl:if test="(contains('s', @code))">
                                <xsl:value-of select="text()"/>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:if>
                            <xsl:if
                                test="(contains('adfklmors', @code) and (not(../subfield[@code = 'n' or @code = 'p']) or (following-sibling::subfield[@code = 'n' or @code = 'p'])))">
                                <xsl:value-of select="text()"/>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <!-- 2.13 -->
                <xsl:value-of select="normalize-space($this)"/>
                <xsl:call-template name="part"/>
            </title>
        </titleInfo>
    </xsl:template>
    <xd:doc id="createTitleInfoFrom210" scope="component">
        <xd:desc>createTitleInfoFrom210</xd:desc>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom210">

        <titleInfo type="abbreviated">
            <xsl:if test="datafield[@tag = '210'][@ind2 = '2']">
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="xxx880"/>
            <title>
                <xsl:variable name="this">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">a</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <!-- 2.13 -->
                <xsl:value-of select="normalize-space($this)"/>
            </title>
            <xsl:call-template name="subtitle"/>
        </titleInfo>
    </xsl:template>
    <xd:doc id="createTitleInfoFrom245" scope="component">
        <xd:desc> 1.79 </xd:desc>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom245">
        <titleInfo>
            <xsl:call-template name="xxx880"/>
            <xsl:variable name="title">
                <xsl:choose>
                    <xsl:when test="subfield[@code = 'b']">
                        <xsl:call-template name="specialSubfieldSelect">
                            <xsl:with-param name="axis">b</xsl:with-param>
                            <xsl:with-param name="beforeCodes">Afghans</xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">abfgks</xsl:with-param>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:variable name="titleChop">
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="$title"/>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="@ind2 &gt; 0">
                    <xsl:if test="@tag != '880'">
                        <nonSort>
                            <xsl:value-of select="substring($titleChop, 1, @ind2)"/>
                        </nonSort>
                    </xsl:if>
                    <title>
                        <xsl:variable name="this">
                            <xsl:value-of select="substring($titleChop, @ind2 + 1)"/>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                </xsl:when>
                <xsl:otherwise>
                    <title>
                        <xsl:variable name="this">
                            <xsl:value-of select="$titleChop"/>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="subfield[@code = 'b']">
                <subTitle>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="specialSubfieldSelect">
                                <xsl:with-param name="axis">b</xsl:with-param>
                                <xsl:with-param name="anyCodes">b</xsl:with-param>
                                <xsl:with-param name="afterCodes">afgks</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </subTitle>
            </xsl:if>
            <xsl:call-template name="part"/>
        </titleInfo>
    </xsl:template>

    <xd:doc id="createTitleInfoFrom246" scope="component">
        <xd:desc>createTitleInfoFrom246</xd:desc>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom246">
        <titleInfo type="alternative">
            <xsl:call-template name="xxx880"/>
            <xsl:for-each select="subfield[@code = 'i']">
                <xsl:attribute name="displayLabel">
                    <xsl:value-of select="text()"/>
                </xsl:attribute>
            </xsl:for-each>
            <title>
                <xsl:variable name="this">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="subfieldSelect">
                                <!-- 1/04 removed $h, $b -->
                                <xsl:with-param name="codes">af</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>

                </xsl:variable>
                <!-- 2.13 -->
                <xsl:value-of select="normalize-space($this)"/>
            </title>
            <xsl:call-template name="subtitle"/>
            <xsl:call-template name="part"/>
        </titleInfo>
    </xsl:template>

    <xd:doc id="createTitleInfoFrom240" scope="component">
        <xd:desc> 240 nameTitleGroup</xd:desc>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom240">
        <titleInfo type="uniform">
            <xsl:if
                test="//datafield[@tag = '100'] | //datafield[@tag = '110'] | //datafield[@tag = '111']">
                <xsl:attribute name="nameTitleGroup">
                    <xsl:text>1</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="xxx880"/>
            <title>
                <xsl:variable name="this">
                    <xsl:variable name="str">
                        <xsl:for-each select="subfield">
                            <xsl:if test="(contains('s', @code))">
                                <xsl:value-of select="text()"/>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:if>
                            <xsl:if
                                test="(contains('adfklmors', @code) and (not(../subfield[@code = 'n' or @code = 'p']) or (following-sibling::subfield[@code = 'n' or @code = 'p'])))">
                                <xsl:value-of select="text()"/>
                                <xsl:text>&#160;</xsl:text>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
                        </xsl:with-param>
                    </xsl:call-template>

                </xsl:variable>
                <!-- 2.13 -->
                <xsl:value-of select="normalize-space($this)"/>
            </title>
            <xsl:call-template name="part"/>
        </titleInfo>
    </xsl:template>

    <xd:doc id="createTitleInfoFrom740" scope="component">
        <xd:desc>createTitleInfoFrom740</xd:desc>
    </xd:doc>
    <xsl:template name="createTitleInfoFrom740">
        <titleInfo type="alternative">
            <xsl:call-template name="xxx880"/>
            <title>
                <xsl:variable name="this">
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">ah</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:variable>
                <!-- 2.13 -->
                <xsl:value-of select="normalize-space($this)"/>

                <xsl:call-template name="part"/>
            </title>
        </titleInfo>
    </xsl:template>

    <!-- name 100 110 111 1.93 -->

    <xd:doc id="createNameFrom100" scope="component">
        <xd:desc> name 100 110 111 1.93 </xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom100">
        <xsl:if test="@ind1 = '0' or @ind1 = '1'">
            <name type="personal">
                <xsl:attribute name="usage">
                    <xsl:text>primary</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="xxx880"/>
                <xsl:if test="//datafield[@tag = '240']">
                    <xsl:attribute name="nameTitleGroup">
                        <xsl:text>1</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <!--Revision 2.06 cm3 edit, commented out named template to pull <namePart> from displayForm-->
                <!--<xsl:call-template name="nameABCDQ"/>-->
                <xsl:call-template name="displayForm"/>
                <xsl:call-template name="affiliation"/>
                <xsl:call-template name="role"/>
            </name>
        </xsl:if>
        <xsl:if test="@ind1 = '3'">
            <name type="family">
                <xsl:attribute name="usage">
                    <xsl:text>primary</xsl:text>
                </xsl:attribute>
                <xsl:call-template name="xxx880"/>
                <xsl:if test="//datafield[@tag = '240']">
                    <xsl:attribute name="nameTitleGroup">
                        <xsl:text>1</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <!--Revision 2.06 cm3 edit, commented out named template to pull <namePart> from displayForm-->
                <!--<xsl:call-template name="nameABCDQ"/>-->
                <xsl:call-template name="displayForm"/>
                <xsl:call-template name="affiliation"/>
                <xsl:call-template name="role"/>
            </name>
        </xsl:if>
    </xsl:template>

    <xd:doc id="createNameFrom110" scope="component">
        <xd:desc>createNameFrom110</xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom110">
        <name type="corporate">
            <xsl:call-template name="xxx880"/>
            <xsl:if test="//datafield[@tag = '240']">
                <xsl:attribute name="nameTitleGroup">
                    <xsl:text>1</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="nameABCDN"/>
            <xsl:call-template name="role"/>
        </name>
    </xsl:template>

    <xd:doc id="createNameFrom111" scope="component">
        <xd:desc>createNameFrom111</xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom111">

        <name type="conference">
            <xsl:call-template name="xxx880"/>
            <xsl:if test="//datafield[@tag = '240']">
                <xsl:attribute name="nameTitleGroup">
                    <xsl:text>1</xsl:text>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="nameACDEQ"/>
            <xsl:call-template name="role"/>
        </name>
    </xsl:template>



    <!-- name 700 710 711 720 -->

    <xd:doc id="createNameFrom700" scope="component">
        <xd:desc> name 700 710 711 720 </xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom700">
        <xsl:if test="@ind1 = '1'">
            <name type="personal">
                <!--cm3 edit, Revision 2.06 added usage="primary" to <name> while checking if name in 100$a is present-->
                <xsl:if
                    test="position() = 1 and (count(./preceding-sibling::subfield[@code = 'a']) = 0) and (count(//datafield[@tag = 100]/subfield[@code = 'a']) = 0)">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="xxx880"/>
                <xsl:call-template name="nameABCDQ"/>
                <xsl:call-template name="displayForm"/>
                <xsl:call-template name="affiliation"/>
                <xsl:call-template name="role"/>
            </name>
        </xsl:if>
        <xsl:if test="@ind1 = '3'">
            <name type="family">
                <!--cm3 edit, Revision 2.06 added usage="primary" to <name> while checking if name in 100$a is present-->
                <xsl:if
                    test="position() = 1 and (count(./preceding-sibling::subfield[@code = 'a']) = 0) and (count(//datafield[@tag = 100]/subfield[@code = 'a']) = 0)">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                </xsl:if>
                <xsl:call-template name="xxx880"/>
                <xsl:call-template name="nameABCDQ"/>
                <xsl:call-template name="displayForm"/>
                <xsl:call-template name="affiliation"/>
                <xsl:call-template name="role"/>
            </name>
        </xsl:if>
    </xsl:template>

    <xd:doc id="createNameFrom710" scope="component">
        <xd:desc>createNameFrom710</xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom710">

        <name type="corporate">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="nameABCDN"/>
            <xsl:call-template name="role"/>
        </name>
    </xsl:template>

    <xd:doc id="createNameFrom711" scope="component">
        <xd:desc>createNameFrom711</xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom711">

        <name type="conference">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="nameACDEQ"/>
            <xsl:call-template name="role"/>
        </name>
    </xsl:template>

    <xd:doc id="createNameFrom720" scope="component">
        <xd:desc>createNameFrom720</xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom720">
        <!-- 1.91 FLVC correction: the original if test will fail because of xpath: the current node (from the for-each above) is already the 720 datafield -->
        <!-- <xsl:if test="datafield[@tag='720'][not(subfield[@code='t'])]"> -->
        <xsl:if test="not(subfield[@code = 't'])">
            <name>
                <xsl:if test="@ind1 = '1'">
                    <xsl:attribute name="type">
                        <xsl:text>personal</xsl:text>
                    </xsl:attribute>
                </xsl:if>
                <namePart>
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </namePart>
                <xsl:call-template name="role"/>
            </name>
        </xsl:if>
    </xsl:template>



    <!-- replced by above 1.91
	<xsl:template name="createNameFrom720">
		<xsl:if test="datafield[@tag='720'][not(subfield[@code='t'])]">
			<name>
				<xsl:if test="@ind1='1'">
					<xsl:attribute name="type">
						<xsl:text>personal</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<namePart>
					<xsl:value-of select="subfield[@code='a']"/>
				</namePart>
				<xsl:call-template name="role"/>
			</name>
		</xsl:if>
	</xsl:template>
	-->

    <xd:doc id="createGenreFrom047" scope="component">
        <xd:desc> genre 047 336 655 </xd:desc>
    </xd:doc>
    <xsl:template name="createGenreFrom047">
        <genre authority="marcgt">
            <xsl:attribute name="authority">
                <xsl:value-of select="subfield[@code = '2']"/>
            </xsl:attribute>
            <!-- Template checks for altRepGroup - 880 $6 -->
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcdef</xsl:with-param>
                <xsl:with-param name="delimeter">-</xsl:with-param>
            </xsl:call-template>
        </genre>
    </xsl:template>

    <xd:doc id="createGenreFrom336" scope="component">
        <xd:desc>createGenreFrom336</xd:desc>
    </xd:doc>
    <xsl:template name="createGenreFrom336">
        <genre>
            <xsl:attribute name="authority">
                <xsl:value-of select="subfield[@code = '2']"/>
            </xsl:attribute>
            <!-- Template checks for altRepGroup - 880 $6 -->
            <xsl:call-template name="xxx880"/>
            <!-- Revision 2.05 removed subfield "b" from appeearing in hyphenated format-->
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">a</xsl:with-param>
            </xsl:call-template>
        </genre>
    </xsl:template>

    <xd:doc id="createGenreFrom655" scope="component">
        <xd:desc>createGenreFrom655</xd:desc>
    </xd:doc>
    <xsl:template name="createGenreFrom655">
        <genre authority="marcgt">
            <xsl:attribute name="authority">
                <xsl:value-of select="subfield[@code = '2']"/>
            </xsl:attribute>
            <!-- Template checks for altRepGroup - 880 $6 -->
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abvxyz</xsl:with-param>
                <xsl:with-param name="delimeter">-</xsl:with-param>
            </xsl:call-template>
        </genre>
    </xsl:template>

    <xd:doc id="createTOCFrom505" scope="component">
        <xd:desc> tOC 505 </xd:desc>
    </xd:doc>
    <xsl:template name="createTOCFrom505">
        <tableOfContents>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">agrt</xsl:with-param>
            </xsl:call-template>
        </tableOfContents>
    </xsl:template>



    <xd:doc>
        <xd:desc> abstract 520 JG removed attributes </xd:desc>
    </xd:doc>
    <xsl:template name="createAbstractFrom520">
        <xsl:variable name="this">
            <abstract>
                <xsl:call-template name="xxx880"/>
                <xsl:call-template name="uri"/>
                <xsl:call-template name="subfieldSelect">
                    <xsl:with-param name="codes">ab</xsl:with-param>
                </xsl:call-template>
            </abstract>
        </xsl:variable>
        <!-- 2.13 -->
        <xsl:value-of select="normalize-space($this)"/>
    </xsl:template>
    <xd:doc id="createTargetAudienceFrom521" scope="component">
        <xd:desc> targetAudience 521 </xd:desc>
    </xd:doc>
    <xsl:template name="createTargetAudienceFrom521">
        <targetAudience>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </targetAudience>
    </xsl:template>
    <xd:doc id="createNoteFrom245c" scope="component">
        <xd:desc> note 245c thru 585 </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom245c">

        <note type="statement of responsibility">
            <xsl:attribute name="altRepGroup">
                <xsl:text>00</xsl:text>
            </xsl:attribute>
            <xsl:call-template name="scriptCode"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">c</xsl:with-param>
            </xsl:call-template>
        </note>

    </xsl:template>
    <xd:doc id="createNoteFrom362" scope="component">
        <xd:desc>createNoteFrom362</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom362">

        <note type="date/sequential designation">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom500" scope="component">
        <xd:desc>createNoteFrom500</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom500">

        <note>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:value-of select="f:proper-case(subfield[@code = 'a'])"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom502" scope="component">
        <xd:desc>createNoteFrom502</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom502">

        <note type="thesis">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom504" scope="component">
        <xd:desc>createNoteFrom504</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom504">

        <note type="bibliography">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom508" scope="component">
        <xd:desc>createNoteFrom508</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom508">

        <note type="creation/production credits">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each
                    select="subfield[@code != 'u' and @code != '3' and @code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom511" scope="component">
        <xd:desc>createNoteFrom511</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom511">

        <note type="performers">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom515" scope="component">
        <xd:desc>createNoteFrom515</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom515">

        <note type="numbering">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom518" scope="component">
        <xd:desc>createNoteFrom518</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom518">

        <note type="venue">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '3' and @code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom524" scope="component">
        <xd:desc>createNoteFrom524</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom524">

        <note type="preferred citation">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom530" scope="component">
        <xd:desc>createNoteFrom530</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom530">

        <note type="additional physical form">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each
                    select="subfield[@code != 'u' and @code != '3' and @code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom533" scope="component">
        <xd:desc>createNoteFrom533</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom533">

        <note type="reproduction">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>



    <xd:doc>
        <xd:desc> tmee &lt;xsl:template name="createNoteFrom534"&gt; &lt;note type="original
            version"&gt; &lt;xsl:call-template name="xxx880"/&gt; &lt;xsl:call-template
            name="uri"/&gt; &lt;xsl:variable name="str"&gt; &lt;xsl:for-each
            select="subfield[@code!='6' and @code!='8']"&gt; &lt;xsl:value-of select="."/&gt;
            &lt;xsl:text&gt; &lt;/xsl:text&gt; &lt;/xsl:for-each&gt; &lt;/xsl:variable&gt;
            &lt;xsl:value-of select="substring($str,1,string-length($str)-1)"/&gt; &lt;/note&gt;
            &lt;/xsl:template&gt; </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom535">
        <note type="original location">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom536" scope="component">
        <xd:desc>createNoteFrom536</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom536">

        <note type="funding">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom538" scope="component">
        <xd:desc>createNoteFrom538</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom538">

        <note type="system details">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom541" scope="component">
        <xd:desc>createNoteFrom541</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom541">

        <note type="acquisition">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom545" scope="component">
        <xd:desc>createNoteFrom545</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom545">

        <note type="biographical/historical">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom546" scope="component">
        <xd:desc>createNoteFrom546</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom546">

        <note type="language">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom561" scope="component">
        <xd:desc>createNoteFrom561</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom561">

        <note type="ownership">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom562" scope="component">
        <xd:desc>createNoteFrom562</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom562">

        <note type="version identification">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom581" scope="component">
        <xd:desc>createNoteFrom581</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom581">

        <note type="publications">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom583" scope="component">
        <xd:desc>createNoteFrom583</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom583">

        <note type="action">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom585" scope="component">
        <xd:desc>createNoteFrom585</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom585">

        <note type="exhibitions">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="."/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>
    <xd:doc id="createNoteFrom5XX" scope="component">
        <xd:desc>createNoteFrom5XX</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom5XX">
        <note>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="uri"/>
            <xsl:variable name="str">
                <xsl:for-each select="subfield[@code != '6' and @code != '8']">
                    <xsl:value-of select="f:proper-case(.)"/>
                    <xsl:text>&#160;</xsl:text>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="substring($str, 1, string-length($str) - 1)"/>
        </note>
    </xsl:template>

    <!--NAL note templates (900s) -->

    <!--NAL note from 910-->

    <xd:doc>
        <xd:desc> JG changed note element to submissionSource element </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom910"
        match="datafield[@tag = 910]/subfield[@code = 'a' or @code = 'b']">
        <xsl:if test="datafield[@tag = 910]">
            <submissionSource>
                <xsl:value-of select="datafield[@tag = 910]/subfield[@code = 'a']"/>
                <xsl:if test="datafield[@tag = 910]/subfield[@code = 'b']">
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="datafield[@tag = 910]/subfield[@code = 'b']"/>
                </xsl:if>
            </submissionSource>
        </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc>NAL note from 930 </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom930"
        match="datafield[@tag = 930]/subfield[@code = 'a' or @code = 'b' or @code = 'c']">
        <xsl:if test="datafield[@tag = 930]">
            <note type="saleTape">
                <xsl:value-of select="datafield[@tag = 930]/subfield[@code = 'a']"/>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="datafield[@tag = 930]/subfield[@code = 'b']"/>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="datafield[@tag = 930]/subfield[@code = 'c']"/>
            </note>
        </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc>NAL note from 945 </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom945"
        match="datafield[@tag = 945]/subfield[@code = 'a' or @code = 'd' or @code = 'e']">
        <!-- 2.14 added conditionals to prevent extra whitespace -->
        <xsl:if test="datafield[@tag = 945]">
            <note type="indexer">
                <xsl:value-of select="datafield[@tag = 945]/subfield[@code = 'a']"/>
                <xsl:if test="count(datafield[@tag = 945]/subfield[@code = 'd']) != 0">
                    <xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="datafield[@tag = 945]/subfield[@code = 'd']"/>
                </xsl:if>

                <xsl:if test="count(datafield[@tag = 945]/subfield[@code = 'd']) != 0">
                    <xsl:text>&#160;</xsl:text>
                    <xsl:value-of select="datafield[@tag = 945]/subfield[@code = 'e']"/>
                </xsl:if>
            </note>
        </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc>NAL note from 946 </xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom946" match="datafield[@tag = 946]/subfield[@code = 'a']">
        <xsl:if test="datafield[@tag = 946]">
            <note type="publicationSource">
                <xsl:value-of select="datafield[@tag = 946]/subfield[@code = 'a']"/>
            </note>
        </xsl:if>
    </xsl:template>



    <xd:doc>
        <xd:desc>NAL note from 974 maps "agid" to local identifier</xd:desc>
    </xd:doc>
    <xsl:template name="createNoteFrom974"
        match="datafield[@tag = 974]/subfield[@code = 'a' or @code = 'b']">
        <!-- Revision 2.13 added if test to prevent extra whitespace -->
        <xsl:if test="datafield[@tag = 974]">
            <identifier type="local">
                <!-- $a agid: -->
                <xsl:value-of select="normalize-space(datafield[@tag = 974]/subfield[@code = 'a'])"/>
                <!-- if test for $b avoids excess whitespace within the field -->
                <xsl:if test="count(datafield[@tag = 974]/subfield[@code = 'b']) != 0">
                    <xsl:text>&#160;</xsl:text>
                    <xsl:value-of
                        select="normalize-space(datafield[@tag = 974]/subfield[@code = 'b'])"/>
                </xsl:if>
            </identifier>
        </xsl:if>
    </xsl:template>

    <xd:doc id="createSubGeoFrom034" scope="component">
        <xd:desc> subject Geo 034 043 045 255 656 662 752 </xd:desc>
    </xd:doc>
    <xsl:template name="createSubGeoFrom034">
        <xsl:if
            test="datafield[@tag = 034][subfield[@code = 'd' or @code = 'e' or @code = 'f' or @code = 'g']]">
            <subject>
                <xsl:call-template name="xxx880"/>
                <cartographics>
                    <coordinates>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">defg</xsl:with-param>
                        </xsl:call-template>
                    </coordinates>
                </cartographics>
            </subject>
        </xsl:if>
    </xsl:template>

    <xd:doc id="createSubGeoFrom043" scope="component">
        <xd:desc>subject Geo 043 </xd:desc>
    </xd:doc>
    <xsl:template name="createSubGeoFrom043">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:for-each select="subfield[@code = 'a' or @code = 'b' or @code = 'c']">
                <geographicCode>
                    <xsl:attribute name="authority">
                        <xsl:if test="@code = 'a'">
                            <xsl:text>marcgac</xsl:text>
                        </xsl:if>
                        <xsl:if test="@code = 'b'">
                            <xsl:value-of select="following-sibling::subfield[@code = '2']"/>
                        </xsl:if>
                        <xsl:if test="@code = 'c'">
                            <xsl:text>iso3166</xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                    <xsl:value-of select="self::subfield"/>
                </geographicCode>
            </xsl:for-each>
        </subject>
    </xsl:template>

    <xd:doc id="createSubGeoFrom255" scope="component">
        <xd:desc>subject Geo 255 </xd:desc>
    </xd:doc>
    <xsl:template name="createSubGeoFrom255">
        <subject>
            <xsl:call-template name="xxx880"/>
            <cartographics>
                <xsl:for-each select="subfield[@code = 'a' or @code = 'b' or @code = 'c']">
                    <xsl:if test="@code = 'a'">
                        <scale>
                            <xsl:value-of select="."/>
                        </scale>
                    </xsl:if>
                    <xsl:if test="@code = 'b'">
                        <projection>
                            <xsl:value-of select="."/>
                        </projection>
                    </xsl:if>
                    <xsl:if test="@code = 'c'">
                        <coordinates>
                            <xsl:value-of select="."/>
                        </coordinates>
                    </xsl:if>
                </xsl:for-each>
            </cartographics>
        </subject>
    </xsl:template>

    <xd:doc id="createSubNameFrom600" scope="component">
        <xd:desc>subject GeoName 600</xd:desc>
    </xd:doc>
    <xsl:template name="createSubNameFrom600">

        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <name type="personal">
                <xsl:call-template name="termsOfAddress"/>
                <namePart>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString">
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">aq</xsl:with-param>
                            </xsl:call-template>
                        </xsl:with-param>
                    </xsl:call-template>
                </namePart>
                <xsl:call-template name="nameDate"/>
                <xsl:call-template name="affiliation"/>
                <xsl:call-template name="role"/>
            </name>
            <xsl:if test="subfield[@code = 't']">
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="subfieldSelect">
                                        <xsl:with-param name="codes">t</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
            </xsl:if>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc id="createSubNameFrom610" scope="component">
        <xd:desc>createSubNameFrom610</xd:desc>
    </xd:doc>
    <xsl:template name="createSubNameFrom610">

        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <name type="corporate">
                <xsl:for-each select="subfield[@code = 'a']">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'b']">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </xsl:for-each>
                <xsl:if test="subfield[@code = 'c' or @code = 'd' or @code = 'n' or @code = 'p']">
                    <namePart>
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">cdnp</xsl:with-param>
                        </xsl:call-template>
                    </namePart>
                </xsl:if>
                <xsl:call-template name="role"/>
            </name>
            <xsl:if test="subfield[@code = 't']">
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="subfieldSelect">
                                        <xsl:with-param name="codes">t</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
            </xsl:if>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc id="createSubNameFrom611" scope="component">
        <xd:desc>createSubNameFrom611</xd:desc>
    </xd:doc>
    <xsl:template name="createSubNameFrom611">

        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <name type="conference">
                <namePart>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abcdeqnp</xsl:with-param>
                    </xsl:call-template>
                </namePart>
                <xsl:for-each select="subfield[@code = '4']">
                    <role>
                        <roleTerm authority="marcrelator" type="code">
                            <xsl:value-of select="."/>
                        </roleTerm>
                    </role>
                </xsl:for-each>
            </name>
            <xsl:if test="subfield[@code = 't']">
                <titleInfo>
                    <title>
                        <xsl:variable name="this">
                            <xsl:call-template name="chopPunctuation">
                                <xsl:with-param name="chopString">
                                    <xsl:call-template name="subfieldSelect">
                                        <xsl:with-param name="codes">tpn</xsl:with-param>
                                    </xsl:call-template>
                                </xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <!-- 2.13 -->
                        <xsl:value-of select="normalize-space($this)"/>
                    </title>
                    <xsl:call-template name="part"/>
                </titleInfo>
            </xsl:if>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc id="createSubTitleFrom630" scope="component">
        <xd:desc>createSubTitleFrom630</xd:desc>
    </xd:doc>
    <xsl:template name="createSubTitleFrom630">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <titleInfo>
                <title>
                    <xsl:variable name="this">
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="subfieldSelect">
                                    <xsl:with-param name="codes">adfhklor</xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <!-- 2.13 -->
                    <xsl:value-of select="normalize-space($this)"/>
                </title>
                <xsl:call-template name="part"/>
            </titleInfo>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc id="createSubChronFrom648" scope="component">
        <xd:desc>createSubChronFrom648</xd:desc>
    </xd:doc>
    <xsl:template name="createSubChronFrom648">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:if test="subfield[@code = '2']">
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="uri"/>
            <xsl:call-template name="subjectAuthority"/>
            <temporal>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">abcd</xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </temporal>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc id="createSubTopFrom650" scope="component">
        <xd:desc>createSubTopFrom650</xd:desc>
    </xd:doc>
    <xsl:template name="createSubTopFrom650">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <topic>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">
                                <xsl:value-of select="'abcd'"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:with-param>
                </xsl:call-template>
            </topic>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc id="createSubGeoFrom651" scope="component">
        <xd:desc>createSubGeoFrom651</xd:desc>
    </xd:doc>
    <xsl:template name="createSubGeoFrom651">

        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subjectAuthority"/>
            <xsl:for-each select="subfield[@code = 'a']">
                <geographic>
                    <xsl:call-template name="chopPunctuation">
                        <xsl:with-param name="chopString" select="."/>
                    </xsl:call-template>
                </geographic>
            </xsl:for-each>
            <xsl:call-template name="subjectAnyOrder"/>
        </subject>
    </xsl:template>

    <xd:doc id="createSubFrom653" scope="component">
        <xd:desc>createSubFrom653</xd:desc>
    </xd:doc>
    <xsl:template name="createSubFrom653">


        <xsl:if test="@ind2 = ' '">
            <subject>
                <topic>
                    <xsl:value-of select="."/>
                </topic>
            </subject>
        </xsl:if>
        <xsl:if test="@ind2 = '0'">
            <subject>
                <topic>
                    <xsl:value-of select="."/>
                </topic>
            </subject>
        </xsl:if>
        <!-- tmee 1.93 20140130 -->
        <xsl:if test="@ind = ' ' or @ind1 = '0' or @ind1 = '1'">
            <subject>
                <name type="personal">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </name>
            </subject>
        </xsl:if>
        <xsl:if test="@ind1 = '3'">
            <subject>
                <name type="family">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </name>
            </subject>
        </xsl:if>
        <xsl:if test="@ind2 = '2'">
            <subject>
                <name type="corporate">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </name>
            </subject>
        </xsl:if>
        <xsl:if test="@ind2 = '3'">
            <subject>
                <name type="conference">
                    <namePart>
                        <xsl:value-of select="."/>
                    </namePart>
                </name>
            </subject>
        </xsl:if>
        <xsl:if test="@ind2 = '4'">
            <subject>
                <temporal>
                    <xsl:value-of select="."/>
                </temporal>
            </subject>
        </xsl:if>
        <xsl:if test="@ind2 = '5'">
            <subject>
                <geographic>
                    <xsl:value-of select="."/>
                </geographic>
            </subject>
        </xsl:if>

        <xsl:if test="@ind2 = '6'">
            <subject>
                <genre>
                    <xsl:value-of select="."/>
                </genre>
            </subject>
        </xsl:if>
    </xsl:template>

    <xd:doc id="createSubFrom656" scope="component">
        <xd:desc>createSubFrom656</xd:desc>
    </xd:doc>
    <xsl:template name="createSubFrom656">
        <subject>
            <xsl:call-template name="xxx880"/>
            <xsl:if test="subfield[@code = '2']">
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
            </xsl:if>
            <occupation>
                <xsl:call-template name="chopPunctuation">
                    <xsl:with-param name="chopString">
                        <xsl:value-of select="subfield[@code = 'a']"/>
                    </xsl:with-param>
                </xsl:call-template>
            </occupation>
        </subject>
    </xsl:template>

    <xd:doc id="createSubGeoFrom662752" scope="component">
        <xd:desc>createSubGeoFrom662752</xd:desc>
    </xd:doc>
    <xsl:template name="createSubGeoFrom662752">
        <subject>
            <xsl:call-template name="xxx880"/>
            <hierarchicalGeographic>
                <xsl:for-each select="subfield[@code = 'a']">
                    <country>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </country>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'b']">
                    <state>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </state>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'c']">
                    <county>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </county>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'd']">
                    <city>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </city>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'e']">
                    <citySection>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </citySection>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'g']">
                    <area>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </area>
                </xsl:for-each>
                <xsl:for-each select="subfield[@code = 'h']">
                    <extraterrestrialArea>
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString" select="."/>
                        </xsl:call-template>
                    </extraterrestrialArea>
                </xsl:for-each>
            </hierarchicalGeographic>
        </subject>
    </xsl:template>

    <xd:doc id="createSubTemFrom045" scope="component">
        <xd:desc>createSubTemFrom045</xd:desc>
    </xd:doc>
    <xsl:template name="createSubTemFrom045">

        <xsl:if test="//datafield[@tag = 045 and @ind1 = '2'][subfield[@code = 'b' or @code = 'c']]">
            <subject>
                <xsl:call-template name="xxx880"/>
                <temporal encoding="iso8601" point="start">
                    <xsl:call-template name="dates045b">
                        <xsl:with-param name="str" select="subfield[@code = 'b' or @code = 'c'][1]"
                        />
                    </xsl:call-template>
                </temporal>
                <temporal encoding="iso8601" point="end">
                    <xsl:call-template name="dates045b">
                        <xsl:with-param name="str" select="subfield[@code = 'b' or @code = 'c'][2]"
                        />
                    </xsl:call-template>
                </temporal>
            </subject>
        </xsl:if>
    </xsl:template>
    <xd:doc id="createClassificationFrom050" scope="component">
        <xd:desc>createClassificationFrom050</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom050">

        <xsl:for-each select="subfield[@code = 'b']">
            <classification authority="lcc">
                <xsl:call-template name="xxx880"/>
                <xsl:if test="../subfield[@code = '3']">
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of select="../subfield[@code = '3']"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="preceding-sibling::subfield[@code = 'a'][1]"/>
                <xsl:text>&#160;</xsl:text>
                <xsl:value-of select="text()"/>
            </classification>
        </xsl:for-each>
        <xsl:for-each select="subfield[@code = 'a'][not(following-sibling::subfield[@code = 'b'])]">
            <classification authority="lcc">
                <xsl:call-template name="xxx880"/>
                <xsl:if test="../subfield[@code = '3']">
                    <xsl:attribute name="displayLabel">
                        <xsl:value-of select="../subfield[@code = '3']"/>
                    </xsl:attribute>
                </xsl:if>
                <xsl:value-of select="text()"/>
            </classification>
        </xsl:for-each>
    </xsl:template>
    <xd:doc id="createClassificationFrom060" scope="component">
        <xd:desc>createClassificationFrom060</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom060">

        <classification authority="nlm">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </classification>
    </xsl:template>
    <xd:doc id="createClassificationFrom080" scope="component">
        <xd:desc>createClassificationFrom080</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom080">

        <classification authority="udc">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abx</xsl:with-param>
            </xsl:call-template>
        </classification>
    </xsl:template>
    <xd:doc id="createClassificationFrom082" scope="component">
        <xd:desc>createClassificationFrom082</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom082">

        <classification authority="ddc">
            <xsl:call-template name="xxx880"/>
            <xsl:if test="subfield[@code = '2']">
                <xsl:attribute name="edition">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
            </xsl:if>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </classification>
    </xsl:template>
    <xd:doc id="createClassificationFrom084" scope="component">
        <xd:desc>createClassificationFrom084</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom084">

        <classification>
            <xsl:attribute name="authority">
                <xsl:value-of select="subfield[@code = '2']"/>
            </xsl:attribute>
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">ab</xsl:with-param>
            </xsl:call-template>
        </classification>
    </xsl:template>
    <xd:doc id="createClassificationFrom086" scope="component">
        <xd:desc>createClassificationFrom086</xd:desc>
    </xd:doc>
    <xsl:template name="createClassificationFrom086">

        <xsl:for-each select="datafield[@tag = 086][@ind1 = '0']">
            <classification authority="sudocs">
                <xsl:call-template name="xxx880"/>
                <xsl:value-of select="subfield[@code = 'a']"/>
            </classification>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 086][@ind1 = '1']">
            <classification authority="candoc">
                <xsl:call-template name="xxx880"/>
                <xsl:value-of select="subfield[@code = 'a']"/>
            </classification>
        </xsl:for-each>
        <xsl:for-each select="datafield[@tag = 086][@ind1 != '1' and @ind1 != '0']">
            <classification>
                <xsl:call-template name="xxx880"/>
                <xsl:attribute name="authority">
                    <xsl:value-of select="subfield[@code = '2']"/>
                </xsl:attribute>
                <xsl:value-of select="subfield[@code = 'a']"/>
            </classification>
        </xsl:for-each>
    </xsl:template>

    <!-- identifier 020 024 022 028 010 037 UNDO Nov 23 2010 RG SM-->
    <xd:doc id="createRelatedItemFrom490" scope="component">
        <xd:desc> createRelatedItemFrom490 &lt;xsl:for-each
            select="datafield[@tag=490][@ind1='0']"&gt; </xd:desc>
    </xd:doc>
    <xsl:template name="createRelatedItemFrom490">
        <relatedItem type="series">
            <xsl:call-template name="xxx880"/>
            <titleInfo>
                <title>
                    <xsl:variable name="this">
                        <xsl:call-template name="chopPunctuation">
                            <xsl:with-param name="chopString">
                                <xsl:call-template name="subfieldSelect">
                                    <xsl:with-param name="codes">av</xsl:with-param>
                                </xsl:call-template>
                            </xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <!-- 2.13 -->
                    <xsl:value-of select="normalize-space($this)"/>
                </title>
                <xsl:call-template name="part"/>
            </titleInfo>
        </relatedItem>
    </xsl:template>
    <xd:doc id="createLocationFrom852" scope="component">
        <xd:desc> location 852 856 </xd:desc>
    </xd:doc>
    <xsl:template name="createLocationFrom852">
        <location>
            <xsl:if test="subfield[@code = 'a' or @code = 'b' or @code = 'e']">
                <physicalLocation>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">abe</xsl:with-param>
                    </xsl:call-template>
                </physicalLocation>
            </xsl:if>
            <xsl:if test="subfield[@code = 'u']">
                <physicalLocation>
                    <xsl:call-template name="uri"/>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">u</xsl:with-param>
                    </xsl:call-template>
                </physicalLocation>
            </xsl:if>
            <!-- 1.78 -->
            <xsl:if
                test="subfield[@code = 'h' or @code = 'i' or @code = 'j' or @code = 'k' or @code = 'l' or @code = 'm' or @code = 't']">
                <shelfLocator>
                    <xsl:call-template name="subfieldSelect">
                        <xsl:with-param name="codes">hijklmt</xsl:with-param>
                    </xsl:call-template>
                </shelfLocator>
            </xsl:if>
        </location>
    </xsl:template>

    <xd:doc id="createLocationFrom856" scope="component">
        <xd:desc>createLocationFrom856</xd:desc>
    </xd:doc>
    <xsl:template name="createLocationFrom856">
        <xsl:if test="//datafield[@tag = 856][@ind2 != '2'][subfield[@code = 'u']]">
            <location>
                <url displayLabel="electronic resource">
                    <!-- 1.41 tmee AQ1.9 added choice protocol for @usage="primary display" -->
                    <xsl:variable name="primary">
                        <xsl:choose>
                            <xsl:when
                                test="@ind2 = '0' and count(preceding-sibling::datafield[@tag = 856][@ind2 = '0']) = 0"
                                >true</xsl:when>

                            <xsl:when test="
                                    @ind2 = '1' and
                                    count(ancestor::record//datafield[@tag = 856][@ind2 = '0']) = 0 and
                                    count(preceding-sibling::datafield[@tag = 856][@ind2 = '1']) = 0"
                                >true</xsl:when>

                            <xsl:when test="
                                    @ind2 != '1' and @ind2 != '0' and
                                    @ind2 != '2' and count(ancestor::record//datafield[@tag = 856 and
                                    @ind2 = '0']) = 0 and count(ancestor::record//datafield[@tag = 856 and
                                    @ind2 = '1']) = 0 and
                                    count(preceding-sibling::datafield[@tag = 856][@ind2]) = 0"
                                >true</xsl:when>
                            <xsl:otherwise>false</xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <xsl:if test="$primary = 'true'">
                        <xsl:attribute name="usage">primary</xsl:attribute>
                    </xsl:if>

                    <xsl:if test="subfield[@code = 'y' or @code = '3']">
                        <xsl:attribute name="displayLabel">
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">y3</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:if test="subfield[@code = 'z']">
                        <xsl:attribute name="note">
                            <xsl:call-template name="subfieldSelect">
                                <xsl:with-param name="codes">z</xsl:with-param>
                            </xsl:call-template>
                        </xsl:attribute>
                    </xsl:if>
                    <xsl:value-of select="subfield[@code = 'u']"/>
                </url>
            </location>
        </xsl:if>
    </xsl:template>

    <extension>
        <xsl:for-each select="datafield[@tag = '910']">
            <xsl:call-template name="createNameFrom910"/>
        </xsl:for-each>
        <xsl:if test="datafield[@tag = 859]">
            <location>
                <xsl:call-template name="createLocationFrom859"/>
            </location>
        </xsl:if>
    </extension>

    <xd:doc id="createLocationFrom859" scope="component">
        <xd:desc>createLocationFrom859</xd:desc>
    </xd:doc>
    <xsl:template name="createLocationFrom859">

        <xsl:for-each select="datafield[@tag = 859]">
            <url note="ARS submission">
                <xsl:if test="count(preceding-sibling::datafield[@tag = 859]) = 0">
                    <xsl:attribute name="usage">primary</xsl:attribute>
                </xsl:if>
                <xsl:if test="subfield[@code = 'y' or @code = '3']">
                    <xsl:attribute name="displayLabel">
                        <xsl:call-template name="subfieldSelect">
                            <xsl:with-param name="codes">y3</xsl:with-param>
                        </xsl:call-template>
                    </xsl:attribute>
                </xsl:if>
                <xsl:choose>
                    <xsl:when test="subfield[@code = 'u']">
                        <xsl:value-of select="subfield[@code = 'u']"/>
                    </xsl:when>
                    <xsl:when test="subfield[@code = 'a']">
                        <xsl:value-of select="subfield[@code = 'a']"/>
                    </xsl:when>
                </xsl:choose>
            </url>
        </xsl:for-each>
    </xsl:template>

    <xd:doc id="createAccessConditionFrom506" scope="component">
        <xd:desc> accessCondition 506 540 1.87 20130829</xd:desc>
    </xd:doc>
    <xsl:template name="createAccessConditionFrom506">
        <accessCondition type="restriction on access">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcd35</xsl:with-param>
            </xsl:call-template>
        </accessCondition>
    </xsl:template>

    <xd:doc id="createAccessConditionFrom540" scope="component">
        <xd:desc>createAccessConditionFrom540</xd:desc>
    </xd:doc>
    <xsl:template name="createAccessConditionFrom540">

        <accessCondition type="use and reproduction">
            <xsl:call-template name="xxx880"/>
            <xsl:call-template name="subfieldSelect">
                <xsl:with-param name="codes">abcde35</xsl:with-param>
            </xsl:call-template>
        </accessCondition>
    </xsl:template>

    <!-- recordInfo 040 005 001 003 -->


    <xd:doc>
        <xd:desc> 880 global copy template </xd:desc>
    </xd:doc>
    <xsl:template match="* | @*" mode="global_copy">
        <xsl:copy>
            <xsl:apply-templates select="* | @* | text()" mode="global_copy"/>
        </xsl:copy>
    </xsl:template>
    <xd:doc id="createNameFrom910" scope="component">
        <xd:desc> name affiliation 910 </xd:desc>
    </xd:doc>
    <xsl:template name="createNameFrom910">
        <affiliation>
            <xsl:if test="subfield[@code = 'a']">
                <affiliationPart type="department">
                    <xsl:value-of select="subfield[@code = 'a']"/>
                </affiliationPart>
            </xsl:if>
            <xsl:if test="subfield[@code = 'b']">
                <affiliationPart type="agency">
                    <xsl:value-of select="subfield[@code = 'b']"/>
                </affiliationPart>
            </xsl:if>
        </affiliation>
    </xsl:template>


</xsl:stylesheet>
