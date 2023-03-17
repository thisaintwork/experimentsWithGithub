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
    Input: all of the labels from all of the issues & PRs
   Output: an xml snippet with a unique list of labels.
  Precond:
 Postcond:
  Summary: This produces a list of labels from the XML. This is magic
           stolen from stack overflow
    -->
    <xsl:variable name="uniqLabelList">
        <uniqLabelList>
            <xsl:for-each select="//projectV2/items/nodes/content/labels/nodes/name[not(.=preceding::*)]">
                <uniquelabel>
                    <!--<xsl:text>'</xsl:text>-->
                    <xsl:value-of select="."/>
                    <!--<xsl:text>'</xsl:text>-->
                </uniquelabel>
            </xsl:for-each>            
        </uniqLabelList>
    </xsl:variable>
    

    <!--
      Summary: print out a header row then invoke the rest of the templates 
    -->
    <xsl:template match="/" >

        <xsl:text>Status</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>AssignedSize</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>Type</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>IssueNumber</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>Title</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>Repository</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>Comments</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>LabelString</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>closingIssuesReferences</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>OG Queue</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>Closed</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>ClosedAt</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>RUNLABEL</xsl:text>
        <xsl:text>|</xsl:text>
        <xsl:text>LabelsCount</xsl:text>
        <xsl:text>|</xsl:text>
        


        <!--
        Append the list of unique labels to the header row  
        -->       
        <xsl:for-each select="$uniqLabelList/uniqLabelList/uniquelabel">
            <xsl:value-of select="." />
            <xsl:text>|</xsl:text>
            
        </xsl:for-each>       
        
        <xsl:text>&#10;</xsl:text>
        
        <xsl:apply-templates />
    </xsl:template >
    
    <xsl:template match="*/projectV2/items/nodes" >
        
        <!--Status-->
        <xsl:text>'</xsl:text>
        <xsl:value-of select="fieldValueByName/name" />
        <xsl:text>'</xsl:text>
        <xsl:text>|</xsl:text>

        <!-- Assigned Size
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
            </xsl:choose>
        </xsl:for-each>        
        <xsl:text>|</xsl:text>

        <!--Type-->
        <xsl:text>'</xsl:text>
        <xsl:value-of select="type" />
        <xsl:text>'</xsl:text>
        <xsl:text>|</xsl:text>

        <!--Issue Number-->
        <xsl:value-of select="content/number" />
        <xsl:text>|</xsl:text>
        
        <!--Title-->
        <xsl:text>'</xsl:text>
        <xsl:value-of select='replace(replace(content/title,"\n|\r","")," +"," ")' />
        <xsl:text>'</xsl:text>
        <xsl:text>|</xsl:text>
        
        <!--Repository-->
        <xsl:if test="content/repository/*" >
            <xsl:for-each select="content/repository">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="./name" />
                <xsl:text>'</xsl:text>
                <xsl:if test='position() != last()' >
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:text>|</xsl:text>
        
        <!--Space for a comment-->
        <xsl:text>|</xsl:text>

        <!--LabelString
            Create a labels string
            for each label
            - Add it to a long comma delimited string 
              that includes all of the labels.
              e.g. "NIH OTA: 1.2.1","Size: 80","Deliverable: 5 Core PIDs"
        -->
        <xsl:if test="content/labels/nodes/*" >
            <xsl:for-each select="content/labels/nodes">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="./name" />
                <xsl:text>'</xsl:text>
                <xsl:if test='position() != last()' >
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:text>|</xsl:text>
        
        
        
        <!--
            Closing Issue References
            Create a closing issues references string
            It will be blank for issues.
            - Add it to a long comma delimited string 
        -->
        <xsl:if test="content/closingIssuesReferences/nodes/*" >
            <xsl:for-each select="content/closingIssuesReferences/nodes">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="./number" />
                <xsl:text>'</xsl:text>
                <xsl:if test='position() != last()' >
                    <xsl:text>,</xsl:text>
                </xsl:if>
            </xsl:for-each>
        </xsl:if>
        <xsl:text>|</xsl:text>
        
        <!--Status as OG Queue-->
        <xsl:text>'</xsl:text>
        <xsl:value-of select="fieldValueByName/name" />
        <xsl:text>'</xsl:text>
        <xsl:text>|</xsl:text>   
        
        <!--Open or Closed?-->
        <xsl:value-of select="content/closed" />
        <xsl:text>|</xsl:text>  
        
        <!--Closed at-->
        <xsl:text>'</xsl:text>
        <xsl:value-of select="content/closedAt" />
        <xsl:text>'</xsl:text>
        <xsl:text>|</xsl:text>  
        

        <!--Run Label-->
        <xsl:value-of select="$RUNLABEL" />
        <xsl:text>|</xsl:text>
        
        
        <!--LabelsCount-->
        <xsl:choose>
            <xsl:when test='string-length(./content/labels/totalCount) > 0'>
                <xsl:value-of select="./content/labels/totalCount" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>0</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text>|</xsl:text>
        
       
        
        <!-- Unique List of all labels
      Summary: This produces a list of labels from the XML. This is magic
               stolen from stack overflow
               There is one node per name under content/labels
               Insert a 1 where a label matches one in the header of the flat file
               Insert a 0 where a label does not
               This is really inefficient

        Input: all of the labels from all of the issues & PRs
       Output: an xml snippet with a unique list of labels.
      Precond:
     Postcond:
        -->
        <xsl:variable name="thisItemLabelNameListElements" select="content/labels/*" />

        
        <xsl:for-each select="$uniqLabelList/uniqLabelList/uniquelabel">
            <xsl:variable name="thisUniqLabelListElement" select="." />
            <xsl:for-each select="$thisItemLabelNameListElements">

<!--
                <xsl:text>&#10;</xsl:text>
                <xsl:value-of select="$thisUniqLabelListElement" />
                <xsl:text>,</xsl:text>
                <xsl:value-of select="./name" />
-->             
                <xsl:choose>   
                    <xsl:when test='string(./name) = string($thisUniqLabelListElement)'>
                        <xsl:text>1</xsl:text>
                    </xsl:when>
                </xsl:choose>
            </xsl:for-each>
            <xsl:text>|</xsl:text>
        </xsl:for-each>
            
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