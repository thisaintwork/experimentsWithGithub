<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>

    <xsl:template match="/" >
        
        
        <xsl:text>Type|</xsl:text>
        <xsl:text>Status|</xsl:text>
        <xsl:text>IssueNumber|</xsl:text>
        <xsl:text>Title|</xsl:text>
        <xsl:text>LabelsCount|</xsl:text>
        <xsl:text>LabelString|</xsl:text>
        <xsl:text>AssignedSize|</xsl:text>
        
        <xsl:text>&#10;</xsl:text>
        
        <xsl:apply-templates />
    </xsl:template >

    <xsl:template match="*/projectV2/items/nodes" >
        
        <xsl:value-of select="type" />
        <xsl:text>|</xsl:text>
        <xsl:value-of select="fieldValueByName/name" />
        <!--
            Extract the Issue Number
            - If no Size label is found the value empty
            
            Note:
            - This is not ideal.
            - I'd rather work it so that I can return a string like "Not defined"
        -->
        <xsl:text>|</xsl:text>
        <xsl:value-of select="content/number" />
        <xsl:text>|</xsl:text>
        <xsl:value-of select='replace(replace(content/title,"\n|\r","")," +"," ")' />
        <xsl:text>|</xsl:text>

        <xsl:choose>
            <xsl:when test='string-length(./content/labels/totalCount) > 0'>
                <xsl:value-of select="./content/labels/totalCount" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        


        <xsl:text>|</xsl:text>


        <!--
            Create a labels string
            for each label
            - Add it to a long comma delimited string 
              that includes all of the labels.
              e.g. "NIH OTA: 1.2.1","Size: 80","Deliverable: 5 Core PIDs"
        -->
        <xsl:for-each select="content/labels/nodes">
                    <xsl:text>"</xsl:text>
                    <xsl:value-of select="./name" />
                    <xsl:text>"</xsl:text>
                    <xsl:if test='position() != last()' >
                        <xsl:text>,</xsl:text>
                    </xsl:if>
        </xsl:for-each>        
        <xsl:text>|</xsl:text>


        <!--
            Extract the estimated size
            - If no Size label is found the value empty
            
            Note:
            - This is not ideal.
            - I'd rather work it so that I can return a string like "Size not defined"
            
            
        -->
        <xsl:for-each select="./content/labels/nodes">
             <xsl:choose>
                <xsl:when test='contains(./name,"Size: ")' >
                    <xsl:value-of select='replace(replace(./name,"Size: ","")," ","")' />
                </xsl:when>
                 <xsl:when test='contains(./array,"Size: ")' >
                    <xsl:value-of select='replace(replace(./array,"Size: ","")," ","")' />
                </xsl:when>
             </xsl:choose>
        </xsl:for-each>        
        <xsl:text>|</xsl:text>

 
        <xsl:text>&#10;</xsl:text>
   </xsl:template>  

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