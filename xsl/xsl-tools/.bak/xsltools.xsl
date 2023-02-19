<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns="http://wws.loc.gov/MARC21/slim" xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:f="http://functions" xmlns:marc="http://www.loc.gov/MARC21/slim" 
    xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.loc.gov/MARC21/slim https://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"
    exclude-result-prefixes="f marc saxon">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0" name="unprefixed"/>

    <xd:doc>
        <xd:desc/>
    </xd:doc>
    <xsl:template match="text()">
        <xsl:value-of select="normalize-space(.)"/>
    </xsl:template>

    <!-- includes -->
    <xsl:include href="../NAL-MARC21slimUtils.xsl"/>
<xd:doc id="add-namespace-and-prefix" scope="component">
    <xd:desc>Adds the marc prefix and namespace to unprefixed elements`</xd:desc>
</xd:doc>
    <xsl:template name="add-namespace-and-prefix">
        <xsl:variable name="in-xml" select="//record" as="node()*"/>
        <xsl:result-document
            href="{replace(saxon:system-id(), '(.*/)(.*)(\.xml|\.json)', '$1')}P-{replace(saxon:system-id(), '(.*/)(.*)(\.xml|\.json)', '$2')}_{position()}.xml">
            <xsl:choose>
                <xsl:when test="//collection/record">                  
            <marc:collection>
                 <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                <xsl:attribute name="xsi:schemaLocation"
                    select="normalize-space('http://www.loc.gov/MARC21/slim https://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd')"/>
                <xsl:for-each select="//collection/record">
                    <xsl:copy-of
                        select="f:add-namespace-and-prefix($in-xml, 'http://www.loc.gov/MARC21/slim', 'marc')"
                    />
                </xsl:for-each>
            </marc:collection>
            </xsl:when>
               <xsl:otherwise>
                   <mods>
                       <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema-instance</xsl:namespace>
                       <xsl:attribute name="xsi:schemaLocation"
                           select="normalize-space('http://www.loc.gov/MARC21/slim https://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd')"/>
                       <xsl:for-each select="//record">
                           <xsl:copy-of
                               select="f:add-namespace-and-prefix($in-xml, 'http://www.loc.gov/MARC21/slim', 'marc')"
                           />
                       </xsl:for-each>
                   </mods>
               </xsl:otherwise>
            </xsl:choose>
        </xsl:result-document>
    </xsl:template>
    
    <xsl:template name="add-record-numbers">
        <xsl:result-document encoding="UTF-8" version="1.0" method="xml" media-type="text/xml"
            indent="yes" href="{replace(base-uri(),'(.*/)(.*)(\.xml)','$1')}R-{replace(base-uri(),'(.*/)(.*)(\.xml)','$2')}_{position()}.xml">
            <collection>
                <xsl:for-each select="collection/record">
                    <xsl:text>&#10;</xsl:text>
                    <!--Record count comment between each record-->
                    <xsl:comment>
                    <xsl:value-of select="concat('Record: ', position())"/>
                </xsl:comment>
                    <xsl:text>&#10;</xsl:text>
                    <xsl:copy>
                        <xsl:copy-of select="node() | @*"/>
                    </xsl:copy>
                </xsl:for-each>
            </collection>
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>
