<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>

    
    <xsl:template name="longest_labels_list" as="element(labels) ?" >
        <xsl:param name="list" as="element(labels)*"/> 
        <xsl:choose >
            <xsl:when test="$list">
                <xsl:variable name="first"  select="count($list[1]/nodes)" as="xs:integer" />
                <xsl:variable name="longest_of_rest" as="element(labels) ?" >
                    <xsl:call-template name="longest_labels_list" >
                        <xsl:with-param name="list" select="$list[position()!=1]"/>
                    </xsl:call-template>
                </xsl:variable>
                
                <xsl:choose>
                    <xsl:when test="$first gt count($longest_of_rest/nodes)" >
                        <xsl:sequence select="$list[1]" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:sequence select="$longest_of_rest" />
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:when>
        </xsl:choose>        
    </xsl:template>


    <xsl:template match="/" >
        <xsl:text>||</xsl:text>    
        <xsl:call-template name="longest_labels_list" >
            <xsl:with-param name="list" select="//labels" />
            
        </xsl:call-template>
        <xsl:text>||</xsl:text>    
    </xsl:template >
    


</xsl:stylesheet>