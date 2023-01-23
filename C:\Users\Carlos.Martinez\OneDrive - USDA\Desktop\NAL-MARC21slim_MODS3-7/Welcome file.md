

# MARC 21 To MODS 3.4/3.7 XML Stylesheet Transformation 

## Contents
 - [Background](#background) 
 - [Metadata](#metadata)
 - 
## Background
The [U.S. National Agricultural Library](https://www.nal.usda.gov/) is charged with providing premier agricultural information resources and services to the global community. Many efforts take place to accomplish and sustain the task. One part involves describing the resources that have been selected and acquired, they maybe searched for and found by  within the collection so that they may be searched for and found the researchers within that global community. 

## Metadata
Characteristics used to describe an item often are referred to as the item's <i><u>metadata</u></i>.  More specifically, <i><u>descriptive metadata</u></i>, describes an item so that it may be searched for and discovered by readers; thereby connecting readers to resources. 

Descriptive metadata is also the key to providing important context to a reader once it's discovered about the resource to discovered. This type of metadata drives the ability to search, browse, sort, and filter information.

Descriptive metadata may include elements such as title, description, author, and keywords. It is the most common type of metadata, familiar to most digital content creators.  If a single resource is viewed as an item, that item may be described. Any item can be measured by its height, width, shape and more specifically the medium it is in.
In this case most items would be publications, which are first selected, then acquired to be added to the collection. The description that is created about an item is the metadata. At NAL this 
It may come in various formats, but the most widely used and accepted forms of data transfer is known as <em><b>e<u>X</u>tensible <u>M</u>arkup <u>L</u>anguage</b> </em>(XML)  information within the collection to  requires metadata transformation and remediation transformation.

For instance, publishers producing a resource that is selected for inclusion into NAL's collection use a form of shareable metadata within their own collection to track and maintain the items.  This may be provided to the library in the form of an XML file. is popular for dissemninate information about NAL's collections  . Primarily transforming data ingested from various sources in various formats using **XML Stylesheet Language Transformation (XSLT)**, to transform vendor metadata into what we refer to as "MODS metadata".  MODS or [Metadata Object Description Schema (MODS)](http://www.loc.gov/mods/v3).  is  standard used ubiquitously by libarians and archivists for  because it is a "bibliographic element set that may be used for a variety of purposes, and particularly for library applications." The standard is maintained by the [Network Development and MARC Standards Office](https://www.loc.gov/marc/ndmso.html) of the Library of Congress with input from users   The most used of these is the NAL-MARC21slim2MODS3-4.xsl adapted from the Library of Congress'  MARC21 to MODS  3.4 trasnformations  ([linked below](http://www.loc.gov/standards/mods/v3/MARC21slim2MODS3-4.xsl)). The Library of Congressbegain logging changes made to the XSLT transformation.; meaning this stylesheet has produced a bulk of NAL's MODS metadata for over a decade (i.e., early 2014). 
Futhermore, i feel like av;e xrr iofc ozo  
Meanwhile, the MODS Editorial Committee  has been busy meeting to discuss and resolve issues the community reports via Listserv. 7 change log within this stylesheet date back to 2003.  
It has been used to transform records from MARCXML to MODS for over two decades. 
The MODS M
NAL's MODS records have been lacking   The transformation supports MODS version upgrades until version 3.4. It was adapted and used by NAL since 2014. 

## Transformation
<b><i>MARCXML TO MODS XSLT</i></b> 
| XLST Version | Filename | Origin | MODS Version| 
|--|--|--|--|
|1.0|[NAL-MARC21slim2MODS3-4](https://github.com/CarlosMtz3/NAL-MARC21slim_MODS3-7/blob/e6dcd44813a96b73c07c321ba990954ba5867cf4/NAL-MARC21slim_MODS3-4.xsl)| [MARC21slim2MODS3-4](http://www.loc.gov/standards/mods/v3/MARC21slim2MODS3-4.xsl)|3.4|
|1.0|[NAL-MARC21slim2MODS3-7](https://github.com/CarlosMtz3/NAL-MARC21slim_MODS3-7/blob/e6dcd44813a96b73c07c321ba990954ba5867cf4/NAL-MARC21slim_MODS3-7.xsl)| [MARC21slim2MODS3-7](http://www.loc.gov/standards/mods/v3/MARC21slim2MODS3-7.xsl)|3.7|




### Additional File Info:
**File name:** NAL-MARC21slim_MODS3-4.xsl
**Last revised:** 2014-12-06
**Version:** XSLT 1.0
**\<xsl:include\>:** [NAL-MARC21slimUtils.xsl](https://www.loc.gov/standards/marcxml/xslt/MARC21slimUtils.xsl)
**Customization:**  Added the following local.

### Mapping of NAL's local MARC fields to MODS 3.4/3.7
|marc:datafield  | marc:subfield | MODS 3.4/3.7      |           
|-----------------------|----------------|----------------|
|001 - MMS ID   |    ‡a *692859*  |\<identifier type="***local***"\> ***692859*** \</identifier>|
|070 - NAL Classification Number|‡a *290* ‡b *B31*2| \<classification authority\=\"***nal***"> ***290 B312*** \</classification\>|
072 - Agricola subject category code |‡a *B100* | \<subject authority\=" ***agricola***"\> \<topic\> ***Geography*** \</topic\> \</subject\>
| 024 - Digital Object Identifier (**DOI**)|‡a ***10.1111/j.1654-1103.2002.tb02088.x*** | \<identifier type="doi"\> **10.3390\/f11080888** \</identifier\>
|910 - Submission source | ***???*** |  |
|914 - Journal ID | ‡a Journal:jnl370061 | \<identifier type="local"\> ***Journal:jnl370061*** \</identifier\>
|930 - Sale Tape  |‡a ***19871012*** ‡b ***19871014*** ‡c 00000000 | \<note type="saleTape">***19871012 19871014 00000000*** \</note> | 
945 - Indexer  |‡a IND YNL|  \<note type="indexer"> ***IND NNL*** \</note>
|946 - Publication Source | ‡a Non-US| \<note type="***publicationSource***"\> ***Non-US*** \</note\>
|974 - Local identifier (agid:#)      | ‡a agid:1444513| \<identifier type="local"> ***agid:1444513*** </identifier\>|
<a name="1" href="#link">[^1]</a>




#### Function _f:convertMarcCountry(\$arg)_

  - parameter
	 - $arg=_"three letter marccode"_
	 -  in this case _"onc"_
- compares the input against elements fo  
```

 
 A series of updates was necessary to allow this stylesheet to transform MARC21 records exported form Alma into MODS.

### Updated Elements and Attributes 
- \<placeTerm type="code" [authority="marccountry](#marccountry)\> 
	 - When the @authority attribute contains "marccountry"
		 - <xsl:if test> is done to test presence of three letters 
	 -	When a match is made, the following function is called.
		 - _f:convertMarcCountry( )_ looks for a match from an XML file containing all of the MARC Country Codes paired with their respective country  names.  
		 - If a match is found, the respective country name is inserted below the MARC Country code in a separate placeTerm element witha @type attribute. 
		 - _(see example below)_ 

 ### XML Input
```xml
<controlfield tag="008">950628e199409 onc|||||o|||||||||||eng||</controlfield>
```
### Transformed Output
```xml
<originInfo>
         <place>
              <placeTerm type="code" authority="marccountry">onc</placeTerm>
              <placeTerm type="text">Ontario</placeTerm>
         </place>
 </originInfo>

```

### 
```xml
 <originInfo>
      <place>
         <placeTerm type="code" authority="marccountry">xx</placeTerm>
         <placeTerm type="text">No place, unknown or undetermined</placeTerm>
      </place>
      <dateIssued encoding="w3cdtf" keyDate="yes">2021-02</dateIssued>
   </originInfo>
```



## Validation Errors  

### Invalid URL values
Initially, the resulting transformation was invalid due to Digital Object Identifier (DOI)'s not resolving to the article (i.e., rendering a [404 error page](https://onlinelibrary.wiley.com/404)).  

```xml 

<url displayLabel="Available from publisher's site" usage="primary">http://dx.doi.org/10.1658/1100-9233(2002)013[0145:PODIAM]2.0.CO;2</url>

<url displayLabel="Available from publisher's site" usage="primary">http://dx.doi.org/10.1658/1100-9233(2004)015[0549:POSDIA]2.0.CO;2</url>

<url displayLabel="Available from publisher's site" usage="primary">http://dx.doi.org/10.1658/1100-9233(2003)014[0079:NAITSP]2.0.CO;2</url>

<url displayLabel="Available from publisher's Web site" usage="primary">http://dx.doi.org/10.1603/0046-225X(2007)36[1124:SATDOB]2.0.CO;2</url>	  

<url displayLabel="Available from publisher's site" usage="primary">http://dx.doi.org/10.1658/1100-9233(2004)015[0407:SPAAIA]2.0.CO;2</url>
      	 
<url displayLabel="Available from publisher's site" usage="primary">http://dx.doi.org/10.1658/1100-9233(2006)17[783:WSSARO]2.0.CO;2</url>

<url displayLabel="Available from publisher's site" usage="primary">http://dx.doi.org/10.1658/1100-9233(2007)18[777:RGRTDO]2.0.CO;2</url>

<url displayLabel="Available from publisher's site" usage="primary">http://dx.doi.org/10.1658/1100-9233(2004)015[0257:TSDAFH]2.0.CO;2</url>

<url displayLabel="Available from publisher's site" usage="primary">http://dx.doi.org/10.1658/1100-9233(2006)17[473:LMPOTD]2.0.CO;2</url>
 ```
## DOI Correction Table
| Wrong	DOI	|	Corrected DOI	|	Title	|	Journal |
|------|--------|---------|--------|
|http://dx.doi.org/10.1603/0046-225X(2007)36[1124:SATDOB]2.0.CO;2	|	https://doi.org/10.1093/ee/36.5.1124	|	Spatial and Temporal Dynamics of Bark Beetles in Chinese White Pine in Qinling Mountains of Shaanxi Province, China	|	Environmental Entomology|
|http://dx.doi.org/10.1658/1100-9233(2002)013[0145:PODIAM]2.0.CO;2 	|	https://doi.org/10.1111/j.1654-1103.2002.tb02034.x	|	Patterns of β-diversity in a Mexican tropical dry forest. Journal of Vegetation Science	|	Journal of Vegetation Science|
|http://dx.doi.org/10.1658/1100-9233(2002)013[0607:WPDAEH]2.0.CO;2 	|	https://doi.org/10.1111/j.1654-1103.2002.tb02088.x	|	Woody population distribution and environmental heterogeneity in a Chaco forest	|	Journal of Vegetation Science|
|'http://dx.doi.org/10.1658/1100-9233(2003)014[0079:NAITSP]2.0.CO;2 	|	https://doi.org/10.1111/j.1654-1103.2003.tb02130.x	|	Neighbourhood analysis in the savanna palm Borassus aethiopum: interplay of intraspecific competition and soil patchiness	|	Journal of Vegetation Science|
|http://dx.doi.org/10.1658/1100-9233(2004)015[0257:TSDAFH]2.0.CO;2 	|	https://doi.org/10.1111/j.1654-1103.2004.tb02260.x	|	Tree species distributions across five habitats in a Bornean rain forest	|	Journal of Vegetation Science|
|http://dx.doi.org/10.1658/1100-9233(2004)015[0407:SPAAIA]2.0.CO;2 	|	https://doi.org/10.1111/j.1654-1103.2004.tb02278.x	|	Spatial patterns and associations in a Quercus-Betula forest in northern China	|	Journal of Vegetation Science|
|http://dx.doi.org/10.1658/1100-9233(2004)015[0549:POSDIA]2.0.CO;2 	|	https://doi.org/10.1111/j.1654-1103.2004.tb02294.x	|	Pathways of stand development in ageing Pinus sylvestris forests	|	Journal of Vegetation Science|
|'http://dx.doi.org/10.1658/1100-9233(2005)016[0037:SPAPIF]2.0.CO;2 	|	https://dx.doi.org/10.1007/s11119-009-9146-9	|	Spatial variation in yield and quality in a small apple orchard	|	Precision Agriculture volume|
|http://dx.doi.org/10.1658/1100-9233(2006)17[473:LMPOTD]2.0.CO;2 	|	https://doi.org/10.1111/j.1654-1103.2006.tb02468.x	|	Long-term mortality patterns of the deep-rooted Acacia erioloba: The middle class shall die!	|	Journal of Vegetation Science|
|'http://dx.doi.org/10.1658/1100-9233(2006)17[783:WSSARO]2.0.CO;2 	|	https://doi.org/10.1111/j.1654-1103.2006.tb02501.x	|	Within-stand spatial structure and relation of boreal canopy and understorey vegetation	|	Journal of Vegetation Science|
|'http://dx.doi.org/10.1658/1100-9233(2007)18[271:MABNTD]2.0.CO;2 	|	https://doi.org/10.1111/j.1654-1103.2007.tb02538.x	|	Moms are better nurses than dads: gender biased self-facilitation in a dioecious Juniperus tree	|	Journal of Vegetation Science|
|http://dx.doi.org/10.1658/1100-9233(2002)013[0035:SEODTI]2.0.CO;2	|	https://dx.doi.org/10.1111/j.1654-1103.2002.tb02021.x	|	Seedling establishment of deciduous trees in various topographic positions	|	Journal of Vegetation Science|
|http://dx.doi.org/10.1658/1100-9233(2007)18[777:RGRTDO]2.0.CO;2 	|	https://doi.org/10.1111/j.1654-1103.2007.tb02594.x	|	Radial growth responses to drought of Pinus sylvestris and Quercus pubescens in an inner-Alpine dry valley	|	Journal of Vegetation Science|
|http://dx.doi.org/10.1658/1100-9233(2006)017[0083:DASMOT]2.0.CO;2	|	https://doi.org/10.1111/j.1654-1103.2006.tb02426.x	|	Determinants and spatial modeling of tree β-diversity in a tropical forest landscape in Panama	|	Journal of Vegetation Science|
|**Total**	|		|		|	**14**|




   <a name="DateTime2023-01-14-T-12:44" />Timestamp</a>

<!--stackedit_data:
eyJoaXN0b3J5IjpbLTIwNzk5OTIzMjNdfQ==
-->