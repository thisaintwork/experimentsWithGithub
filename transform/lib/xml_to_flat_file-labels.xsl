<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    <xsl:output method="text"/>
    
    <xsl:strip-space elements="*"/>
    <xsl:param name="RUNLABEL" as="xs:string" required="yes"/>

<!--
    Input: RUNLABEL - usually a time/date stamp
           The xml output from the graphql input.
   Output:
  Precond: The graphql query file and this xsl file must be paired with compatible versions.
 Postcond: Output is prepared that can be used in a spreadsheet
  Summary: This output can be used to make the backlog prioritization easier
    -->



    <!--
    Input:
   Output: uniqe variables for the non-repeating information
  Precond: Assumes the query returns info for a single project
           Since there is pagination, these top level items will repeat, 
            the assumption here is that they will always be the same, whic
            for our purposes is safe.
            got the idea from:
            https://stackoverflow.com/questions/2291567/how-to-use-xslt-to-create-distinct-values
 Postcond:
  Summary:
          
    -->
    <xsl:variable name="orgID" select="//organization/id[not(.=preceding::*)]"/>
    <xsl:variable name="orgLogin" select="//organization/login[not(.=preceding::*)]"/>
    <xsl:variable name="repoID" select="//organization/repository/id[not(.=preceding::*)]"/>
    <xsl:variable name="repoName" select="//organization/repository/name[not(.=preceding::*)]"/>
    


    <!--
      Summary: print out a header row then invoke the rest of the templates 
    -->
    <xsl:template match="/" >

        <xsl:text>Organization</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>OrganizationID</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>Repo</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>RepoID</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>LabelName</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>LabelID</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>LabelColor</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>LabelDescription</xsl:text>
        <xsl:text>&#9;</xsl:text>
        <xsl:text>RUNLABEL</xsl:text>
        
        
        <xsl:text>&#10;</xsl:text>
        
        <xsl:apply-templates />
    </xsl:template >
    
    <xsl:template match="//labels/nodes" >

        <xsl:text>'</xsl:text>
        <xsl:value-of select="$orgLogin" />
        <xsl:text>'</xsl:text>
        <xsl:text>&#9;</xsl:text>

        <xsl:text>'</xsl:text>
        <xsl:value-of select="$orgID" />
        <xsl:text>'</xsl:text>
        <xsl:text>&#9;</xsl:text>

        <xsl:text>'</xsl:text>
        <xsl:value-of select="$repoName" />
        <xsl:text>'</xsl:text>
        <xsl:text>&#9;</xsl:text>

        <xsl:text>'</xsl:text>
        <xsl:value-of select="$repoID" />
        <xsl:text>'</xsl:text>
        <xsl:text>&#9;</xsl:text>

        <xsl:text>'</xsl:text>
        <xsl:value-of select="name" />
        <xsl:text>'</xsl:text>
        <xsl:text>&#9;</xsl:text>
        
        <xsl:text>'</xsl:text>
        <xsl:value-of select="id" />
        <xsl:text>'</xsl:text>
        <xsl:text>&#9;</xsl:text>
        
        
        <xsl:text>'</xsl:text>
        <xsl:value-of select="color" />
        <xsl:text>'</xsl:text>
        <xsl:text>&#9;</xsl:text>

        <xsl:text>'</xsl:text>
        <xsl:value-of select="description" />
        <xsl:text>'</xsl:text>
        <xsl:text>&#9;</xsl:text>
        
        

        <!--Run Label-->
        <xsl:value-of select="$RUNLABEL" />
        <xsl:text>&#9;</xsl:text>
        
        <!--End line-->   
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