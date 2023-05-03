<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns="http://www.loc.gov/mods/v3"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mods="http://www.loc.gov/mods/v3"
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="mods xs xsi" version="2.0">
    <xsl:output name="combine" method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
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
    </xd:doc>
    <xsl:template match="/">       
        <xsl:variable name="workingDir" select="substring-before(base-uri(), tokenize(base-uri(), '/')[last()])"/>
        <xsl:variable name="agricola" select="string('agricola_IND_Mar23_11-')"/>
        <xsl:result-document  exclude-result-prefixes="mods xd xlink xs xsi" 
            method="xml" version="1.0" encoding="UTF-8" indent="yes" 
            format="combine" href="{$workingDir}/recompile/{$agricola}_{position()}.xml"> 
            <modsCollection xmlns="http://www.loc.gov/mods/v3"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                xsi:schemaLocation="http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-7.xsd">
                <xsl:copy-of copy-namespaces="no" select="document(collection/doc/@href)//mods:mods"/>
            </modsCollection>
        </xsl:result-document>
    </xsl:template>
</xsl:stylesheet>