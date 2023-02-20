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
            <xd:p><xd:b>XSLT combines a collection of modsCollection XML documents</xd:b></xd:p>
            <xd:p><xd:i>Instructions:</xd:i></xd:p>
                <xd:ul>
                    <xd:li>1. Run the fileListGenerator.bat</xd:li>
                    <xd:li>2. Open FileList.txt and collection.xml</xd:li>
                    <xd:li>3. Create a new collections.xml file the XML files contained in filesList.txt</xd:li>
                    <xd:li>4. Run combine-mods.xsl against the new collections.xml</xd:li>
                    <xd:li>5. After the transformation completes, check the filename, and spot check the XML output.</xd:li>
                </xd:ul>
        </xd:desc>
        <xd:param name="workingDir">
            <xd:p>Define the path in Oxygen's parameter settings</xd:p>
        </xd:param>
        <xd:variable name="prefix">
            <xd:p>prefix is selected from the filenames first three characters (i.e., IND or CAT)</xd:p>
        </xd:variable>
        <xd:variable name="filename">
            <xd:p>Fully qualirifed filepath construted from a parameter, variable, two string literals, and an integer function.</xd:p>
        </xd:variable>
    </xd:doc>
    <xsl:template match="/">
        <xsl:param name="workingDir"/>
        <xsl:variable name="prefix" select="substring(tokenize(base-uri(),'/')[last()],1,3)"/>
        <xsl:variable name="filePath" select="string(concat($workingDir,$prefix,'_Annual23_mods_1_10_',[position()-1],'.xml'))"/>
        <xsl:result-document method="xml" version="1.0" encoding="UTF-8" indent="yes" format="combined" href="{$filePath}"> 
            <modsCollection>
            <xsl:namespace name="xsi">http://www.w3.org/2001/XMLSchema</xsl:namespace>
            <xsl:attribute name="xsi:schemaLocation">http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsl</xsl:attribute>
                <xsl:copy-of select="document(//collection/doc/@href)//mods:modsCollection/mods:mods"/>
            </modsCollection>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>