<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="mods xs xsi" version="2.0">
    <xsl:output name="combined" method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
    <xd:doc>
        <xd:desc>
            <xd:p>This XSLT combines modsCollection XML documents</xd:p>
            <xd:p><xd:b>Instructions:</xd:b>
                <xd:ul>
                    <xd:li>1. Run the fileListGenerator.bat</xd:li>
                    <xd:li>2. Open FileList.txt and collection.xml</xd:li>
                    <xd:li>3. Create a new collections.xml file the XML files contained in filesList.txt</xd:li>
                    <xd:li>4. Run combine-mods.xsl against the new collections.xml</xd:li>
                    <xd:li>5. After the transformation completes, check the filename, and spot check the XML output.</xd:li>
                </xd:ul></xd:p>
        </xd:desc>
        <xd:param name="workingDir">
            <xd:p>Define the path in Oxygen's parameter settings</xd:p>
        </xd:param>
    </xd:doc>
    <xsl:template match="/">
        <xsl:param name="workingDir"/>
        <xsl:variable name="filename" select="string(concat($workingDir,'IND_Annual23_mods_1_10_',[position()-1],'.xml'))"/>
        <xsl:result-document method="xml" version="1.0" encoding="UTF-8" indent="yes" format="combined" href="{$filename}"> 
            <modsCollection>
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema</xsl:namespace>
            <xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsl</xsl:attribute>
                <xsl:copy-of select="document(//collection/doc/@href)//mods:modsCollection/mods:mods"/>
            </modsCollection>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>