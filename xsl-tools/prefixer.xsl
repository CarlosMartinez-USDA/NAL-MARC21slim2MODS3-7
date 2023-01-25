<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:f="http://functions" xmlns:marc="http://www.loc.gov/MARC21/slim"
    xmlns:saxon="http://saxon.sf.net/" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.loc.gov/MARC21/slim https://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd"
    exclude-result-prefixes="f marc xs">
    <xsl:output encoding="UTF-8" indent="yes" method="xml" version="1.0" name="unprefixed"/> <!--saxon:next-in-chain="../NAL-MARC21slim2MODS3-7-prefix.xsl"/>-->
   
    <xsl:include href="../NAL-MARC21slimUtils.xsl"/>
   
    <xsl:template match="/">
        <xsl:variable name="in-xml" select="descendant-or-self::node()" as="node()"/>
        <marc:collection>
                <xsl:for-each select="//collection/record">
                    <xsl:result-document method="xml" encoding="UTF-8" version="1.0" format="unprefixed" href="{replace(saxon:system-id(), '(.*/)(.*)(\.xml|\.json)','$1')}N-{replace(saxon:system-id(), '(.*/)(.*)(\.xml|\.json)','$2')}_{position()}.xml">
                        <xsl:copy-of select="f:add-namespace-prefix($in-xml,'http://www.loc.gov/MARC21/slim', 'marc')"/>																	
                    </xsl:result-document>
                </xsl:for-each>
        </marc:collection>
    </xsl:template>
    
    <xsl:template match="node() | @*">
        <xsl:copy-of select="node() | @*"/>
    </xsl:template>



</xsl:stylesheet>
