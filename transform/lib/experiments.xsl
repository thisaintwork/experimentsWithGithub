<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    
    <xsl:strip-space elements="*"/>
    <xsl:param name="DATETIME" as="xs:string" required="yes"/>
    
    <xsl:template match="/" >
        
        
        <xsl:text>Date</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>Type</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>Status</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>IssueNumber</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>Title</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>LabelsCount</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>LabelString</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>AssignedSize</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>Repository</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>closingIssuesReferences</xsl:text>
        
        
        <xsl:text>&#10;</xsl:text>
        
        <xsl:apply-templates />
    </xsl:template >
    
    <xsl:template match="*/projectV2/items/nodes" >
        
        <!--
            Create a labels string
            for each label
            - Add it to a long comma delimited string 
              that includes all of the labels.
              e.g. "NIH OTA: 1.2.1","Size: 80","Deliverable: 5 Core PIDs"
        -->
            <xsl:for-each select="content/labels/nodes">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="./name" />
                <xsl:text>'</xsl:text>
                <xsl:if test='position() != last()' >
                    <xsl:text>,</xsl:text>
                </xsl:if>
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