makeIntroduction <- function(object){
   
   resultsSectionList <- newList(
      newParagraph(asStrong("QC Summary")," - Overview of results."),
      newParagraph(asStrong("QC Results")," - Full QC results and figures."),
      newParagraph(asStrong("QC files and versions")," - Files and program versions used in QC")
   )
   
   
   introductionSection <- newSection("Overview")
   introductionParagraph1 <- newParagraph("This report was generated using ",asLink( asStrong("ChIPQC"),url="https://code.google.com/p/chipqcbioc/"))
   introductionParagraph2 <- newParagraph("The report provides both general and ChIP-seq specific quality metrics and diagnostic graphics to allow for the quantitative assessment of ChIP-seq quality.")
   introductionParagraph3 <- newParagraph("The report is split into three main sections:")
   introductionSection <- addTo(introductionSection,
                                introductionParagraph1,
                                introductionParagraph2,
                                introductionParagraph3,
                                resultsSectionList);
   return(introductionSection)
   
}


makeSummarySection <- function(object){
   summarySection <- newSection( "QC Summary" );
   
   metrics <- QCmetrics(object)
   if(class(object)=="ChIPQCexperiment"){
      metrics <- metrics[,!colnames(metrics) %in% c("ReadLenCC","RIBL","Map%","Filt%","ReadLen")]
      allMetadata <- QCmetadata(object)
      metadata <- allMetadata[,c("ID","Tissue","Factor","Condition","Replicate")]
      summaryTable <- newTable(
         merge(metadata,metrics,by.x=1,by.y=0,all=TRUE),
         "Summary of ChIP-seq filtering and quality metrics."
      )
   }else{
      metrics <- metrics[!names(metrics) %in% c("ReadLenCC","RIBL","Map%","Filt%","ReadLen")]
      summaryTable <- newTable(
         t(data.frame(metrics)),
         "Summary of ChIP-seq filtering and quality metrics."
      )
      
      
   }
   
   
   table_1Description1 <- newParagraph( asStrong("Table 1"),"contains a summary of filtering and quality metrics generated by\
                                        the ChIPQC package. Further information on these metrics, their associated figures and additional quality measures can be found\
                                        within the related QC Results subsections. ");
   table_1Description2 <- newParagraph("A short description of ", asStrong("Table 1")," metrics is provided below:" );
   table_1DescriptionList <- newList(
      newParagraph(asStrong("ID -")," Unique sample ID."),
      newParagraph(asStrong("Tissue/Factor/Condition")," - Metadata associated to sample."),
      newParagraph(asStrong("Replicate")," - Number of replicate within sample group"),
      newParagraph(asStrong("Reads")," - Number of sample reads within analysed chromosomes."),
      newParagraph(asStrong("Dup%")," - Percentage of MapQ filter passing reads marked as duplicates"),
      newParagraph(asStrong("FragLen")," - Estimated fragment length by cross-coverage method"),
      newParagraph(asStrong("SSD")," - SSD score (htSeqTools)"),
      newParagraph(asStrong("FragLenCC")," - Cross-Coverage score at the fragment length"),
      newParagraph(asStrong("RelativeCC")," - Cross-coverage score at the fragment length over Cross-coverage at the read length"),
      newParagraph(asStrong("RIP%")," - Percentage of reads wthin peaks"),
      newParagraph(asStrong("RIBL%")," - Percentage of reads wthin Blacklist regions")            
      
      
   )
   
   summaryTable <- addTo(summaryTable,table_1Description1,table_1Description2)
   
   summarySection <- addTo(summarySection,summaryTable,table_1DescriptionList);
   
   return(summarySection)
   
}


makeMFDSection <- function(object,riblPlot,gfePlot){
   
   mfdParagraph1 <- newParagraph("This section presents the mapping quality, duplication rate and distribution of reads\
                                 in known genomic features." );
   mfdParagraph2 <- newParagraph(asStrong("Table 2")," shows the absolute number of total, mapped, passing MapQ filter and duplicated reads.\
                                 The percent of mapped reads passing quality filter and marked as duplicates (Non-Redundant Fraction?) are also included. " );
   mfdParagraph3 <- newParagraph("Description of read filtering and flag metrics:")
   mfdParagraph4 <- newParagraph(asStrong("Total Dup%-"), "Percentage of all ", asStrong("mapped")," reads which are marked as ",asStrong("duplicates."))
   mfdParagraph5 <- newParagraph(asStrong("Pass MapQ Filter%-"), "Percentage of all ", asStrong("mapped")," reads which", asStrong("pass MapQ quality")," filter")
   mfdParagraph6 <- newParagraph(asStrong("Pass MapQ Filter and Dup%-"), "Percentage of all reads which pass ", asStrong("MapQ filter"),"  and are marked as",asStrong("duplicates."))
   mfdDescriptionList <- newList(mfdParagraph4,mfdParagraph5,mfdParagraph6)
   mfdParagraph7 <- newParagraph("Duplication rates (Dup %) are dependent on the ChIP library complexity and the number of reads sequenced\
                                 Higher duplication rates maybe due to low ChIP efficiency when read counts are lower or conversely \
                                 saturation of ChIP signal when sequencing large number of reads. Since this metric is dependent on both read depth
                                 and the properties of the ChIP itself, comparison between biological or technical replicates of similat total read counts can best identify problematic 
                                 libraries\ . 
                                 ")
   mfdParagraph8 <- newParagraph("Highly mappable (multimappable) positions within the genome can attract large levels of duplication\
                                 and so assessment of duplication before and after MapQ quality filtering can identify contribution of\
                                 these positions to the duplication rate. 
                                 ")          
   
   mfdParagraph9 <- newParagraph("Genomic regions of high, anomalous signal can confound fragment length estimation,\
                                 calculation of ChIP enrichment metrics (i.e. SSD) and comparison of signal between samples.")
   mfdParagraph10 <- newParagraph("The identifaction of genomic stretches of artefact signal has been previously described\
                                  for single samples using Input controls and more recently work as part of the Encode consortium has\ 
                                  identified conserved regions of high artefact signal for many model organisms.")
   mfdParagraph11 <- newParagraph("The proportion of total ChIP signal within known artefact regions can therefore be\
                                  useful to evaluate the level of such confounding, abbarant signal in a sample.
                                  ")          
   
   mfdParagraph9 <- newParagraph("Genomic regions of high, anomalous signal have been seen to contribute directly to the Encode RCS and NSC metrics\
                                 and can confound fragment length estimation,\
                                 calculation of ChIP enrichment metrics (i.e. SSD) and comparison of signal between samples.")
   mfdParagraph10 <- newParagraph("The identifaction of genomic stretches of artefact signal has been previously described\
                                  for single samples using Input controls and more recently work as part of the Encode consortium has\ 
                                  identified conserved regions of high artefact signal for many model organisms.")
   mfdParagraph11 <- newParagraph("The proportion of total ChIP signal within known artefact regions can therefore be\
                                  useful to evaluate the level of such confounding, abbarant signal in a sample.
                                  ",asStrong("(Figure 1)"))          
   mfdParagraph12 <- newParagraph("The distribution of reads across known genomic features such as genes and their subcomponents\
                                  may allow further evaluation of ChIP-seq success and quality. A transcription factor know to \
                                  preferentially bind at a genomic feature should show relative enrichment against other transcription factors\
                                  showing no such preference. In addition,a replicate showing a differing enrichment patterns across genomic features\
                                  compared to those within its sample group would highlight a potential outlier sample worthy of further investigation")
   
   mfdParagraph13 <- newParagraph(asStrong("Figure 2")," shows the log2 enrichment of specified genomic features within samples with regions\
                                  of greater enrichment showing bright yellow and lower enrichment seen in black")
   
   
   ftcBySample <- t(flagtagcounts(object))
   Dup <- (ftcBySample[,"Duplicates"]/ftcBySample[,"Mapped"])*100
   MapQpass <- (ftcBySample[,"MapQPass"]/ftcBySample[,"Mapped"])*100
   NRF_MapQpass <- (ftcBySample[,"MapQPassAndDup"]/ftcBySample[,"MapQPass"])*100
   ftcAndRates <- data.frame(ftcBySample[,"UnMapped"],ftcBySample[,"Mapped"],ftcBySample[,"MapQPassAndDup"],
                             Dup,
                             MapQpass,
                             NRF_MapQpass
   )
   colnames(ftcAndRates) <- c("Unmapped","Mapped","Pass MapQ Filter and Dup",
                              "Total Dup%",
                              "Pass MapQ Filter%",
                              "Pass MapQ Filter and Dup%")
   if(class(object)=="ChIPQCexperiment"){
      allMetadata <- QCmetadata(object)
      metadata <- allMetadata[,c("ID","Tissue","Factor","Condition","Replicate")]
      
      ftcAndRatesTable <- newTable(
         merge(metadata,ftcAndRates,by.x=1,by.y=0,all=TRUE),
         "Number and percantage of mapped,duplicated and MapQ filter passing reads"
      )
   }else{
      ftcAndRatesTable <- newTable(
         ftcAndRates,
         "Number and percantage of mapped,duplicated and MapQ filter passing reads"
      )     
      
   }
   
   mfdSubSection <- newSubSection("Mapping, Filtering and Duplication rate")
   mfdSubSection <- addTo(mfdSubSection,mfdParagraph1,ftcAndRatesTable,mfdParagraph2,
                          mfdParagraph3,mfdDescriptionList,mfdParagraph7,mfdParagraph8)
   if(!is.null(riblPlot)){
      mfdSubSection <- addTo(mfdSubSection,
                             riblPlot,mfdParagraph9,mfdParagraph10,mfdParagraph11)
   }
   if(!is.null(gfePlot)){
      mfdSubSection <- addTo(mfdSubSection,
                             gfePlot,mfdParagraph12,mfdParagraph13)
   }  
   
   return(mfdSubSection)
   
}


makeDistAndStrucSection <- function(object,covhistPlot,ccPlot){
   
   distAndStructureSubSection <- newSubSection("ChIP signal Distribution and Structure")
   
   distAndStructureParagraph1 <- newParagraph(" In this section, metrics relating to genome wide depths of coverage and,\
                                              the relationship between Watson and Crick reads are presented. The metrics are the SSD metric and cross-coverage metrics,\
                                              Relative_CC and fragmentLength_CC.")
   
   distAndStructureParagraph2 <- newParagraph(asStrong("SSD")," is the standard deviation of coverage normalised to\
                                              the total number of reads. Evaluation of the number of bases at differing read depths,", asStrong("(figure 3)") ,"alongside\
                                              the use of the SSD metric allow for an assessment of the distribution of ChIP-seq or input signal.") 
   
   distAndStructureParagraph3 <- newParagraph("Successfull Histone \
                                              and transcription factor ChIP-seq samples will show a higher proportion of genomic positions at greater depths and \
                                              equivalence of sample and input SSD scores highlights either an unsuccessful ChIP or high levels of anomalous input signal                 
                                              ")           
   distAndStructureParagraph4 <- newParagraph("An important measure of ChIP successive is \
                                              the degree to which Watson and Crick reads cluster around the centres\
                                              of transcription factor bindind sites or epigentic marks.                                                      ")           
   
   distAndStructureParagraph5 <- newParagraph(" Transcription factor binding sites identified\
                                              by ChIP-seq will show two distinct peaks of Watson and Crick strands separated by the fragment length. \ 
                                              Here the method of cross-coverage (ChIPseq package) analysis is used to investigate this\
                                              spatial clustering of Watson and Crick reads. ")
   distAndStructureParagraph5.1 <- newParagraph(" To investigate this spatial clustering, reads on the positive strand are shifted in 1bp steps\
                                                and the total proportion genome now covered by both strands combined is assessed. \
                                                ",asStrong("Figure 4")," shows the CCov_Score (described below) after successive shifts. The points of highest
                                                outside of the read-length exclusion region, 2* the read length, (marked in grey) is considered the fragment length
                                                
                                                
                                                ")
   distAndStructureParagraph5.2 <- newParagraph("Following the methodology first presented for cross-correlation 
                                                by Encode to calculate \
                                                the Relative Strand Cross Correlation (NSC) and Normalised Strand Cross Correlation, the Relative\
                                                Cross Coverage score and Fragment Length Cross Coverage score are calculated. 
                                                ")           
   
   
   distAndStructureParagraph6 <- newParagraph("The calculation of cross-coverage (CCov),Relative CCov and Fragment Length CCov scores are explained below:")
   distAndStructureParagraph7 <- newParagraph(asStrong("CCov_Score-")," 1-(Total covered genome size at strand shift)/(covered genome size with no shift)")
   distAndStructureParagraph8 <- newParagraph(asStrong("Fragment Length CCov-")," (CCov of fragment length strand shift)/(Minimum CCov)")
   distAndStructureParagraph9 <- newParagraph(asStrong("Relative CCov-")," (CCov of fragment length strand shift)/(CCov of read length strand shift)")
   
   distAndStructureSubSection <- addTo(distAndStructureSubSection,distAndStructureParagraph1,covhistPlot,
                                       distAndStructureParagraph2,distAndStructureParagraph3,ccPlot,
                                       distAndStructureParagraph4,distAndStructureParagraph5,distAndStructureParagraph5.1,distAndStructureParagraph5.2,
                                       distAndStructureParagraph6,
                                       newList(distAndStructureParagraph7,distAndStructureParagraph8,
                                               distAndStructureParagraph9))          
   
   return(distAndStructureSubSection)
}

makePeakProfileSection <- function(object,ripPlot,rapPlot,peakProfilePlot,peakCorHeatmap,peakPrinComp){
   peakProfileSubSection <- newSubSection("Peak Profile and ChIP Enrichment")
   peakProfileParagraph1 <- newParagraph("Following the identification of genome wide enrichment (peak calling),\
                                         the proportion of ChIP signal within enriched regions, as well\
                                         the average profile across these regions can be used to further evaluate ChIP quality")
   
   
   peakProfileParagraph2 <- newParagraph(asStrong("Figure6")," shows the total proportion of reads contained within enriched regions or peaks.\
                                         The higher efficiency ChIP-seq will show a higher percentage of reads in enriched regions/peaks and longer epigenetic \
                                         marks will often have a higher ranges of efficiencies than punctate marks or transcription factors.
                                         ")
   
   peakProfileParagraph3 <- newParagraph(asStrong("Figure5")," represents the mean read depth across and around peaks. \
                                         By identying the average pattern of enrichment across peaks, differences in both mean\
                                         peak height and shape may be found. This not only assits in a better characterisation of \ 
                                         ChIP enrichment but can aid in the identification of outliers.
                                         ")
   peakProfileParagraph4 <- newParagraph(asStrong("Figure7")," shows the distribution of reads in all peaks. Evaluation of the distibution can allow for greater characteriation of \
                                         the variability and range of signal in peaks within a sample and so better characterise the signal across peaks than the RIP score may allow.
                                         ")
   peakProfileParagraph5 <- newParagraph(asStrong("Figure8 and 9")," shows the correlation between samples as a heatmap and by principal component analysis.\
                                         Replicate samples of high quality can be expected to cluster together in the heatmap and be spatially grouped within the PCA plot.
                                         ")
   peakProfileSubSection <- addTo(peakProfileSubSection,peakProfileParagraph1,peakProfilePlot,peakProfileParagraph3,ripPlot,peakProfileParagraph2,rapPlot,peakProfileParagraph4)
   if(!is.null(peakCorHeatmap) & !is.null(peakPrinComp)){
      peakProfileSubSection <- addTo(peakProfileSubSection,peakCorHeatmap,peakPrinComp,peakProfileParagraph5)
      
   }
   
   return(peakProfileSubSection)
}

makeSessionInfoSection <- function(){
   ChIPQCpackageInfo <- sessionInfo("ChIPQC")
   
   rVersion <-  paste(ChIPQCpackageInfo$R.version$major,".",ChIPQCpackageInfo$R.version$minor,sep="")
   rDescription <-  paste(ChIPQCpackageInfo$R.version$version.string,sep="")
   
   ChIPQCversion <- paste(ChIPQCpackageInfo$otherPkgs$ChIPQC$Package,":",ChIPQCpackageInfo$otherPkgs$ChIPQC$Version,sep="")
   ChIPQCauthor <- paste(ChIPQCpackageInfo$otherPkgs$ChIPQC$Author,sep=",")
   ChIPQCmaintainer <- paste(ChIPQCpackageInfo$otherPkgs$ChIPQC$Maintainer,sep="")
   
   loadedPackageVersions <- vector("character")
   for(i in 1:length(ChIPQCpackageInfo$loadedOnly)){
      loadedPackageVersions[i] <- paste(ChIPQCpackageInfo$loadedOnly[[i]]$Package," Version:",ChIPQCpackageInfo$loadedOnly[[i]]$Version,sep="")
   }
   
   #rVersionHeader <- asStrong("R Version Information")
   #ChIPQCVersionHeader <- asStrong("ChIPQC Version Information")
   #LoadedPackageVersionHeader <- asStrong("Other dependent packages Information")
   
   rVersionHeader <- newParagraph(asStrong("R Version Information"))
   rVersionList <-  newList(
      newParagraph("Version: ",rVersion),
      newParagraph("Version_String :",rDescription)
   )
   
   ChIPQCVersionHeader <- newParagraph(asStrong("ChIPQC Version Information"))
   
   ChIPQCVersionList <- newList(
      newParagraph("Version: ",ChIPQCversion),
      newParagraph("Author: ",ChIPQCauthor),
      newParagraph("Maintainer: ",ChIPQCmaintainer)
   )
   
   #LoadedPackageVersionHeader <- newParagraph(LoadedPackageVersionHeader,loadedPackageVersions)
   versionSection <- newSection("Files and Versions")
   versionSection <- addTo(versionSection,rVersionHeader,rVersionList,ChIPQCVersionHeader,ChIPQCVersionList)#,LoadedPackageVersionHeader)
   return(versionSection)
}
setGeneric("ChIPQCreport", function(object="ChIPQCexperiment",facet=TRUE,
                                    reportName="ChIPQC",reportFolder="ChIPQCreport",
                                    facetBy=c("Tissue","Factor"),
                                    colourBy=c("Replicate"),
                                    lineBy=NULL,                              
                                    addMetaData=NULL)
   standardGeneric("ChIPQCreport"))

setMethod("ChIPQCreport", "ChIPQCexperiment", function(object,facet=TRUE,
                                                       reportName="ChIPQC",reportFolder="ChIPQCreport",
                                                       facetBy=c("Tissue","Factor"),
                                                       colourBy=c("Replicate"),
                                                       lineBy=NULL,
                                                       addMetaData=NULL
                                                       
){
   dir.create(reportFolder, showWarnings=FALSE)
   
   ggsave(plotCC(object,facetBy=facetBy,colourBy=colourBy,lineBy=lineBy,addMetaData=addMetaData),filename=file.path(reportFolder,"CCPlot.png"))
   ggsave(plotCoverageHist(object,facetBy=facetBy,colourBy=colourBy,lineBy=lineBy,addMetaData=addMetaData),filename=file.path(reportFolder,"CoverageHistogramPlot.png"))
   ccPlot <- newFigure(file.path("CCPlot.png"),"Plot of CrossCoverage score after successive strand shifts",
                       type = IMAGE.TYPE.RASTER, exportId = NULL,
                       protection = PROTECTION.PUBLIC)
   covhistPlot <- newFigure(file.path("CoverageHistogramPlot.png"),"Plot of the log2 base pairs of genome at differing read depths",
                            type = IMAGE.TYPE.RASTER, exportId = NULL,
                            protection = PROTECTION.PUBLIC)
   
   
   ggsave(plotRegi(object,facetBy=facetBy,addMetaData=addMetaData),filename=file.path(reportFolder,"GenomicFeatureEnrichment.png"),height=1*length(QCsample(object)),width=8)
   gfePlot <- newFigure(file.path("GenomicFeatureEnrichment.png"),"Heatmap of log2 enrichment of reads in genomic features",
                        type = IMAGE.TYPE.RASTER, exportId = NULL,
                        protection = PROTECTION.PUBLIC)
   
   ggsave(plotFribl(object,facetBy=facetBy,addMetaData=addMetaData),filename=file.path(reportFolder,"Ribl.png"))
   
   riblPlot <- newFigure(file.path("Ribl.png"),"Barplot of the absolute number of reads in blacklists",
                         type = IMAGE.TYPE.RASTER, exportId = NULL,
                         protection = PROTECTION.PUBLIC)
   
   
   ggsave(plotFrip(object,facetBy=facetBy,addMetaData=addMetaData),filename=file.path(reportFolder,"Rip.png"))
   ggsave(plotRap(object,facetBy=facetBy,addMetaData=addMetaData),filename=file.path(reportFolder,"Rap.png"))
   ggsave(plotPeakProfile(object,facetBy=facetBy,colourBy=colourBy,lineBy=lineBy,addMetaData=addMetaData),filename=file.path(reportFolder,"PeakProfile.png"))
   png(file.path(reportFolder,"PeakCorHeatmap.png"),width=600,height=600)
   plotCorHeatmap(object,attributes=c(facetBy,colourBy))
   dev.off()
   png(file.path(reportFolder,"PeakPCA.png"),width=600,height=600)
   plotPrincomp(object,attributes=facetBy,dotSize=2)
   dev.off()
   ripPlot <- newFigure(file.path("Rip.png"),"Barplot of the absolute number of reads in peaks",
                        type = IMAGE.TYPE.RASTER, exportId = NULL,
                        protection = PROTECTION.PUBLIC)
   rapPlot <- newFigure(file.path("Rap.png"),"Density plot of the number of reads in peaks",
                        type = IMAGE.TYPE.RASTER, exportId = NULL,
                        protection = PROTECTION.PUBLIC)
   peakProfilePlot <- newFigure(file.path("PeakProfile.png"),"Plot of the average signal profile across peaks",
                                type = IMAGE.TYPE.RASTER, exportId = NULL,
                                protection = PROTECTION.PUBLIC)
   peakCorHeatmap <- newFigure(file.path("PeakCorHeatmap.png"),"Plot of correlation between peaksets",
                               type = IMAGE.TYPE.RASTER, exportId = NULL,
                               protection = PROTECTION.PUBLIC)  
   peakPrinComp <- newFigure(file.path("PeakPCA.png"),"PCA of peaksets",
                             type = IMAGE.TYPE.RASTER, exportId = NULL,
                             protection = PROTECTION.PUBLIC)   
   
   
   
   
   qcreport <- newCustomReport( "ChIPQC Report" );
   
   introductionSection <- makeIntroduction(object)
   summarySection <- makeSummarySection(object)
   mfdSubSection <- makeMFDSection(object,riblPlot,gfePlot)
   distAndStructureSubSection <- makeDistAndStrucSection(object,covhistPlot,ccPlot)
   peakProfileSubSection <- makePeakProfileSection(object,ripPlot,rapPlot,peakProfilePlot,peakCorHeatmap,peakPrinComp)
   versionSection <- makeSessionInfoSection()
   
   
   
   resultsSection <- newSection( "QC Results" );
   resultsSection <- addTo(resultsSection,
                           mfdSubSection,
                           distAndStructureSubSection,
                           peakProfileSubSection
   );
   
   
   
   
   qcreport <- addTo(qcreport,introductionSection,summarySection,resultsSection,versionSection)
   writeReport(qcreport,file.path(reportFolder,reportName))
   
   html <- readLines(file.path(reportFolder,paste(reportName,"html",sep=".")))
   htmlID <- gsub("\">","",strsplit(html[grep("div class=\"report\" id=\"",html)],"id=\"")[[1]][2])
   html[grep(">ChIPQC Report<",html)+1] <- 
      gsub(">",paste0("id=\"overview_",htmlID,"\">"),html[grep(">ChIPQC Report<",html)+1])
   
   html[grep(">QC files and versions<",html)+6] <-
      gsub(">",paste0("id=\"summary_",htmlID,"\">"),html[grep(">QC files and versions<",html)+6])          
   
   write(html,file=file.path(reportFolder,paste(reportName,"html",sep=".")))
   browser <- browseURL(paste0("file://",normalizePath(file.path(reportFolder,paste(reportName,"html",sep=".")))))
   
})


setMethod("ChIPQCreport", "ChIPQCsample", function(object,
                                                   reportName="ChIPQC",reportFolder="ChIPQCreport"){
   dir.create(reportFolder, showWarnings=FALSE)
   
   ggsave(plotCC(object),filename=file.path(reportFolder,"CCPlot.png"))
   ggsave(plotCoverageHist(object),filename=file.path(reportFolder,"CoverageHistogramPlot.png"))
   ccPlot <- newFigure(file.path("CCPlot.png"),"Plot of CrossCoverage score after successive strand shifts",
                       type = IMAGE.TYPE.RASTER, exportId = NULL,
                       protection = PROTECTION.PUBLIC)
   covhistPlot <- newFigure(file.path("CoverageHistogramPlot.png"),"Plot of the log2 base pairs of genome at differing read depths",
                            type = IMAGE.TYPE.RASTER, exportId = NULL,
                            protection = PROTECTION.PUBLIC)
   
   if(!all(is.na(object@CountsInFeatures))){
      ggsave(plotRegi(object),filename=file.path(reportFolder,"GenomicFeatureEnrichment.png"),height=3,width=8)
      gfePlot <- newFigure(file.path("GenomicFeatureEnrichment.png"),"Heatmap of log2 enrichment of reads in genomic features",
                           type = IMAGE.TYPE.RASTER, exportId = NULL,
                           protection = PROTECTION.PUBLIC)
   }else{
      gfePlot <- NULL
   }
   if(!is.na(ribl(object))){
      
      ggsave(plotFribl(object),filename=file.path(reportFolder,"Ribl.png"))
      riblPlot <- newFigure(file.path("Ribl.png"),"Barplot of the absolute number of reads in blacklists",
                            type = IMAGE.TYPE.RASTER, exportId = NULL,
                            protection = PROTECTION.PUBLIC)
   }else{
      riblPlot <- NULL
   }
   
   
   if(length(peaks(object)) > 0){
      #ggsave(plotPeakProfile(object),filename=file.path(reportFolder,"PeakProfilePlot.png"))
      ggsave(plotFrip(object),filename=file.path(reportFolder,"Rip.png"))
      ggsave(plotRap(object),filename=file.path(reportFolder,"Rap.png"))
      ggsave(plotPeakProfile(object),filename=file.path(reportFolder,"PeakProfile.png"))
      
      ripPlot <- newFigure(file.path("Rip.png"),"Barplot of the absolute number of reads in peaks",
                           type = IMAGE.TYPE.RASTER, exportId = NULL,
                           protection = PROTECTION.PUBLIC)
      rapPlot <- newFigure(file.path("Rap.png"),"Density plot of the number of reads in peaks",
                           type = IMAGE.TYPE.RASTER, exportId = NULL,
                           protection = PROTECTION.PUBLIC)
      peakProfilePlot <- newFigure(file.path("PeakProfile.png"),"Plot of the average signal profile across peaks",
                                   type = IMAGE.TYPE.RASTER, exportId = NULL,
                                   protection = PROTECTION.PUBLIC)
      peakCorHeatmap <- NULL
      peakPrinComp <- NULL
   }else{
      ripPlot <- NULL
      rapPlot <- NULL
      peakProfilePlot <- NULL
      peakCorHeatmap <- NULL
      peakPrinComp <- NULL     
   }
   #s1 <- addTo(s1,html1,html2,t1,p2);
   
   qcreport <- newCustomReport( "ChIPQC Report" );
   
   introductionSection <- makeIntroduction(object)
   summarySection <- makeSummarySection(object)
   mfdSubSection <- makeMFDSection(object,riblPlot,gfePlot)
   distAndStructureSubSection <- makeDistAndStrucSection(object,covhistPlot,ccPlot)
   peakProfileSubSection <- makePeakProfileSection(object,ripPlot,rapPlot,peakProfilePlot,peakCorHeatmap,peakPrinComp)
   versionSection <- makeSessionInfoSection()
   
   
   
   resultsSection <- newSection( "QC Results" );
   resultsSection <- addTo(resultsSection,
                           mfdSubSection,
                           distAndStructureSubSection
   );
   if(length(peaks(object)) > 0){  
      resultsSection <- addTo(resultsSection,peakProfileSubSection)
   }
   
   
   
   qcreport <- addTo(qcreport,introductionSection,summarySection,resultsSection,versionSection)
   writeReport(qcreport,file.path(reportFolder,reportName))
   
   html <- readLines(file.path(reportFolder,paste(reportName,"html",sep=".")))
   htmlID <- gsub("\">","",strsplit(html[grep("div class=\"report\" id=\"",html)],"id=\"")[[1]][2])
   html[grep(">ChIPQC Report<",html)+1] <- 
      gsub(">",paste0("id=\"overview_",htmlID,"\">"),html[grep(">ChIPQC Report<",html)+1])
   
   html[grep(">QC files and versions<",html)+6] <-
      gsub(">",paste0("id=\"summary_",htmlID,"\">"),html[grep(">QC files and versions<",html)+6])          
   
   write(html,file=file.path(reportFolder,paste(reportName,"html",sep=".")))
   browser <- browseURL(paste0("file://",normalizePath(file.path(reportFolder,paste(reportName,"html",sep=".")))))
   
})
