<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    
    <xsl:strip-space elements="*"/>
    <xsl:param name="RUNLABEL" as="xs:string" required="yes"/>

<!--
    Input:
   Output:
  Precond:
 Postcond:
  Summary:    This produces a list of labels from the XML 
    -->
    
    <xsl:template match="/" >
        
        
        <xsl:text>RunLabel=</xsl:text>
        <xsl:value-of select="$RUNLABEL" />
        <xsl:text>&#10;</xsl:text>
        
        
        
        <xsl:apply-templates />
    </xsl:template >



    <xsl:template match="*/projectV2/items/nodes/content/labels/nodes/name" >           
        <ul> 
            <xsl:for-each select=".[not(.=preceding::*)]">
            
                <li>
                    <xsl:value-of select="."/>
                    <xsl:text>&#10;</xsl:text>
                </li>   
            </xsl:for-each>            
        </ul>
    </xsl:template>



<!--    <xsl:template match="*/projectV2/items/nodes" >
        
        
        <!-\-
        -\->
            <xsl:for-each select="content/labels/nodes">
                <xsl:if test='./name' >
                    <xsl:text>'</xsl:text>
                    <xsl:value-of select="./name" />
                    <xsl:text>'</xsl:text>
                    <xsl:text>&#10;</xsl:text>
                </xsl:if>
                
            </xsl:for-each>
        
        
    </xsl:template>  
  -->  
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