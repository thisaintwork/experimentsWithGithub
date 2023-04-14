<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="xml" indent="no" encoding="UTF-8" />
    
    
    

    <!-- The asterisk ( * ) Selects all element 
        nodes in the current context. 
        Be aware that the asterisk wildcard selects 
        element nodes only; 
        attributes, text nodes, comments, or 
        processing instructions aren't included. 
        You can also use a namespace prefix with an 
        asterisk.
    -->
    
    <!--
    What does @* node () mean in XSLT?
    It is a shorthand for attribute::* | child::node() .  
    In XSLT, XPath is relative to the context node and 
    the default selection axis is the child axis, so the
    expression. selects all attributes and immediate
    children of the context node 
    (when used as a select="..." expression, for example
    in <xsl:apply-templates> )
    -->
    
    <xsl:template match="node()|@*">
        <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="pullRequests">
        <issues>
            <xsl:apply-templates/>
        </issues>
    </xsl:template>


</xsl:stylesheet>

