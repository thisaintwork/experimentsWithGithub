<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/" >
        <xsl:apply-templates />
    </xsl:template >

    <xsl:template match="/JSON/entries/displayString" >
        <xsl:value-of select='concat(replace(replace(.,"\n|\r","")," +"," "),"&#xA;")'/>
        <xsl:apply-templates />
    </xsl:template >

    <xsl:template match="text()|@*">
        <!--<xsl:value-of select="."/>-->
    </xsl:template>
    

    <xsl:template match="*">
        <xsl:message terminate="no">
            WARNING: Unmatched element: <xsl:value-of select="name()"/>
        </xsl:message>
        
        <xsl:apply-templates/>
    </xsl:template>
    
    
    
</xsl:stylesheet>