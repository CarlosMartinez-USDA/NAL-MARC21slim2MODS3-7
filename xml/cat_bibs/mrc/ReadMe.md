# filename: CAT-BIBLIOGRAPHIC_16224868320007426.mrc

## Analysis
 - This file contained 64 marc records
 - It was transformed into MARCXML using MARCEdit 7.5
 - The MARCXML file was called cat-bibs.xml and placed in the [from_catalog_prefixed](https://github.com/CarlosMtz3/NAL-MARC21slim2MODS3-7/tree/master/xml/cat_bibs/mrc/from_catalog_prefixed) folder
 - The prefixes from [cat-bibs.xml](https://github.com/CarlosMtz3/NAL-MARC21slim2MODS3-7/blob/master/xml/cat_bibs/mrc/from_catalog_prefixed/cat_bibs.xml) were removed to allow for testing of unprefixed elements
  - The file is titled [unprefixed-cat-bibs.xml](https://github.com/CarlosMtz3/NAL-MARC21slim2MODS3-7/blob/master/xml/cat_bibs/mrc/from_catalog_unprefixed/unprefixed_cat_bibs.xml) and is placed in the [from_catalog_unprefixed](https://github.com/CarlosMtz3/NAL-MARC21slim2MODS3-7/tree/master/xml/cat_bibs/mrc/from_catalog_unprefixed) folder. 
 - The prefixes were then readded to the XSLT to test cat-bibs.xml.
 
 ## Evaluation
 - Included here are the results of both. 
  - Upon comparing the results there are a few fields that are present within the unprefixed results files that are not in the prefixed result files. 
 - Conclusion: The [NAL-MARC21slim2MODS3-7-prefix.xsl](https://github.com/CarlosMtz3/NAL-MARC21slim2MODS3-7/blob/master/NAL-MARC21slim2MODS3-7-prefix.xsl) needs to be some review until the transformations are more identical. 
