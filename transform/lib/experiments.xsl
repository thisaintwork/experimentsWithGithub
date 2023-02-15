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

    <xsl:template match="*/projectV2/items/nodes" >
        
        <xsl:value-of select="type" />
        <xsl:text>|</xsl:text>
        <xsl:value-of select="fieldValueByName/name" />
        <xsl:text>|</xsl:text>
        <xsl:value-of select="content/number" />
        <xsl:text>|</xsl:text>
        <xsl:value-of select='replace(replace(content/title,"\n|\r","")," +"," ")' />
        <xsl:text>|</xsl:text>
        <xsl:value-of select="content/labels/totalCount" />
        <xsl:text>|</xsl:text>
        <!--<xsl:value-of select='content/labels/nodes/name' /><xsl:text>|</xsl:text>-->
        
        
        <!--<xsl:value-of select='replace(content/labels/nodes/name,".+Size: ([0-9]+)","***$1***")' /><xsl:text>|</xsl:text>-\->-->


        <!--
            for each label
            - Add it to a long comma delimited string
        -->
        
        <xsl:text>"</xsl:text>
        <xsl:for-each select="content/labels/nodes/name">
            <xsl:value-of select="." />
            <xsl:text>","</xsl:text>
        </xsl:for-each>
        <xsl:text>"</xsl:text>
        <xsl:text>|</xsl:text>


        <!--
            for each label
            - if string "Size:" is found, extract the number into the variab sizePoints
        -->
        <xsl:for-each select="content/labels/nodes/name">
            <xsl:if test='contains(.,"Size:")' >
                <xsl:value-of select='replace(.,"Size: ","")'/>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>|</xsl:text>


        <!--
            for each label
            - Add it to a long comma delimited string
        -->
        <xsl:text>"</xsl:text>
        <xsl:for-each select="content/labels/nodes/array">
            <xsl:value-of select="." />
            <xsl:text>","</xsl:text>
        </xsl:for-each>
        <xsl:text>"</xsl:text>
        <xsl:text>|</xsl:text>
        
        
        <!--
            for each label
            - if string "Size:" is found, extract the number into the variab sizePoints
        -->
        <xsl:for-each select="content/labels/nodes/array">
            <xsl:if test='contains(.,"Size:")' >
                <xsl:value-of select='replace(.,"Size: ","")'/>
            </xsl:if>
        </xsl:for-each>
        <xsl:text>|</xsl:text>
        <!--<xsl:value-of select='concat($labels,.)' />-->
        
        
<!--        <xsl:for-each select="content/labels/nodes">
            <!-\-<xsl:value-of select='replace(content/labels/nodes/name,".+Size: ([0-9]+)","$1")' /><xsl:text>|</xsl:text>-\->
            
            
        </xsl:for-each>-\->-->
        
        <!--<xsl:value-of select="content/labels" /><xsl:text>|</xsl:text>-->
        
        <xsl:text>&#xA;</xsl:text>
        
        <xsl:apply-templates />
    </xsl:template >
    
<!--
    <xsl:template match="content/labels/nodes/array" >
        <xsl:value-of select="name " /><xsl:text>|</xsl:text>
        <!-\-<xsl:value-of select='concat(replace(replace(content/title,"\n|\r","")," +"," "),"&#xA;")' />-\->
        
        <xsl:apply-templates />
    </xsl:template >-->
    
    
    <xsl:template match="text()|@*">
        <!--<xsl:value-of select="."/>-->
    </xsl:template>
    
 <!--
    <xsl:template match="*">
        <xsl:message terminate="no">
            WARNING: Unmatched element: <xsl:value-of select="name()"/>
        </xsl:message>
        
        <xsl:apply-templates/>
    </xsl:template>
    -->
    
    
</xsl:stylesheet>