<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xsl:param name="recordNum" select="64"/>
    <xsl:template match="collection">
        <xsl:for-each-group select=".//record" group-adjacent="leader">
            <xsl:variable name="file" select="concat(current-grouping-key(), position())"/>
            <xsl:for-each-group select="current-group()" group-adjacent="(position() - 1) idiv $recordNum">
                <xsl:result-document href="{replace(base-uri(),'(.*/)(.*)(\.xml)','$1')}CS-{concat(replace(base-uri(),'(.*/)(.*)(\.xml)','$2'),($file))}_{format-number(position(),'000')}.xml">
                    <collection>
                        <xsl:copy-of select="current-group()"/>
                    </collection>
                </xsl:result-document>
            </xsl:for-each-group>
        </xsl:for-each-group>
    </xsl:template>
</xsl:stylesheet>
