# this will load all key libraries for the whole project

library(metacoder) # base package we will work with
library(phyloseq) # essential data container
library(vegan) # perofrms some basic operations
library(metagMisc) # turns ps objects into lists of ps objects
library(purrr) # has map() to extract values from lists
library(metagMisc)
library(dplyr)
library(tibble)
library(tidyverse)
library(Boruta)
library(phyloseq)
library(caret)
library(randomForest)
library(parallel) # use parallel computing to speed up RF calculations
library(doMC)

# load object
load("./data/ps_rarefied.Rdata")


# make a copy of you rarefied ps object
ps_rarefied_filt<-ps_rarefied

#remove unecessary taxonomic info (dada2id, "s__" and "ASV_id") by updating the tax table with a subset of the tax table
tax_table(ps_rarefied_filt)<-tax_table(ps_rarefied_filt)[,1:6]


# let's remove the "r__"ranks from the taxonomy, they can be useful but will pollute our plot
tax_table(ps_rarefied_filt)[, colnames(tax_table(ps_rarefied_filt))] <- gsub(pattern = "[a-z]__", # regular expression pattern to search for
                                                                             x = tax_table(ps_rarefied_filt)[, colnames(tax_table(ps_rarefied_filt))], # "df"
                                                                             replacement = "") # replacement for pattern


# define function to run boruta from a ps_object
single_physeq_to_borutaInput<-function (physeq_object, variable_to_be_classified){
  # boruta expects a transposed OTU table with variable_to_be_classified as a added variable
  # the output is a list of df ready to be used as input to boruta  
  #transpose phtseq otu table  
  otu_cells_wide_list <- #transpose the feature table...
    base::as.data.frame(t(otu_table(physeq_object)))%>%
    rownames_to_column(var = "sample")
  
  # extract sample data
  metadata_list <-
    as(sample_data(physeq_object),"data.frame")%>%
    rownames_to_column(var = "sample")
  
  #add the variable classification you want to predict with the random forest
  boruta_dataset<-
    base::merge(dplyr::select(metadata_list,sample, variable_to_be_classified),
                otu_cells_wide_list,
                by = "sample",
                all.y = TRUE)
  
  #make sure your variable to be classified is a factor, or boruta won't run
  
  boruta_dataset[,2]<-as.factor(boruta_dataset[,2]) # saves the second column, your variable_to_be_classified, as a factor
  
  output<-boruta_dataset
  
  gc()
  return(output)
}



# run boruta
  outoupt_singleps<-Boruta(Stress~.,   # classification you are trying to predict
         data = single_physeq_to_borutaInput(physeq_object = ps_rarefied_filt,
                                             variable_to_be_classified = "Stress")[,-1], # removes first column, "sample" as a predictor variable
         doTrace=2, 
         maxRuns = 500,  #increase the maximum number of runs to decrease the number of tenttively important OTUs.
         ntree = 5000) # increase the number of trees to increase precision. decrease ntree/maxruns to reduce computational time.

  
  
  
  # run boruta
  boruta_genus<-Boruta(Sp_Lineage_Walden~.,   # classification you are trying to predict
                           data = single_physeq_to_borutaInput(physeq_object = tax_glom(ps_rarefied_filt, taxrank = "Genus"),
                                                               variable_to_be_classified = "Sp_Lineage_Walden")[,-1], # removes first column, "sample" as a predictor variable
                           doTrace=2, 
                           maxRuns = 500,  #increase the maximum number of runs to decrease the number of tenttively important OTUs.
                           ntree = 5000) # increase the number of trees to increase precision. decrease ntree/maxruns to reduce computational time.
  
  
  # run boruta
  boruta_family<-Boruta(Sp_Lineage_Walden~.,   # classification you are trying to predict
                       data = single_physeq_to_borutaInput(physeq_object = tax_glom(ps_boruta, taxrank = "Family"),
                                                           variable_to_be_classified = "Sp_Lineage_Walden")[,-1], # removes first column, "sample" as a predictor variable
                       doTrace=2, 
                       maxRuns = 500,  #increase the maximum number of runs to decrease the number of tenttively important OTUs.
                       ntree = 5000) # increase the number of trees to increase precision. decrease ntree/maxruns to reduce computational time.
  
  # run boruta
  boruta_order<-Boruta(Sp_Lineage_Walden~.,   # classification you are trying to predict
                        data = single_physeq_to_borutaInput(physeq_object = tax_glom(ps_boruta, taxrank = "Order"),
                                                            variable_to_be_classified = "Sp_Lineage_Walden")[,-1], # removes first column, "sample" as a predictor variable
                        doTrace=2, 
                        maxRuns = 500,  #increase the maximum number of runs to decrease the number of tenttively important OTUs.
                        ntree = 5000) # increase the number of trees to increase precision. decrease ntree/maxruns to reduce computational time.
  

  # run boruta
  boruta_Class<-Boruta(Sp_Lineage_Walden~.,   # classification you are trying to predict
                        data = single_physeq_to_borutaInput(physeq_object = tax_glom(ps_boruta, taxrank = "Class"),
                                                            variable_to_be_classified = "Sp_Lineage_Walden")[,-1], # removes first column, "sample" as a predictor variable
                        doTrace=2, 
                        maxRuns = 500,  #increase the maximum number of runs to decrease the number of tenttively important OTUs.
                        ntree = 5000) # increase the number of trees to increase precision. decrease ntree/maxruns to reduce computational time.
  
  # run boruta
  boruta_phyla<-Boruta(Stress~.,   # classification you are trying to predict
                       data = single_physeq_to_borutaInput(physeq_object = tax_glom(ps_boruta, taxrank = "Phyla"),
                                                           variable_to_be_classified = "Stress")[,-1], # removes first column, "sample" as a predictor variable
                       doTrace=2, 
                       maxRuns = 500,  #increase the maximum number of runs to decrease the number of tenttively important OTUs.
                       ntree = 5000) # increase the number of trees to increase precision. decrease ntree/maxruns to reduce computational time.
  
  # run boruta
  boruta_kingdom<-Boruta(Stress~.,   # classification you are trying to predict
                       data = single_physeq_to_borutaInput(physeq_object = tax_glom(ps_boruta, taxrank = "Kingdom"),
                                                           variable_to_be_classified = "Stress")[,-1], # removes first column, "sample" as a predictor variable
                       doTrace=2, 
                       maxRuns = 500,  #increase the maximum number of runs to decrease the number of tenttively important OTUs.
                       ntree = 5000) # increase the number of trees to increase precision. decrease ntree/maxruns to reduce computational time.
  
  

get_boruta_ASVs<-function(boruta_object){

#let Boruta decide if tentative features are ultimatetly important or not ; 
fixed_boruta_objt<- TentativeRoughFix(boruta_object)

# get a list of ASVs defined as inportant by Boruta
boruta_ASV_list<- getSelectedAttributes(fixed_boruta_objt)

# get the list of ASVs defined as inportant by Boruta in formula format ; this can be used to calculate precision
boruta_formula<- getConfirmedFormula(fixed_boruta_objt)

# define ASVs tagged as important by boruta
important_ASVs<-filter(attStats(fixed_boruta_objt), decision=="Confirmed")%>%
  rownames()

#get boruta stats of ASVs confirmed to be important
rf_importance_byOTU<-filter(attStats(fixed_boruta_objt), decision=="Confirmed")%>%
  rownames_to_column(var = "otu_id")

return(rf_importance_byOTU)
}

get_boruta_ASVs(outoupt_singleps)[,1]

# importance of features in boruta
attStats(outoupt_singleps)

tax_table(tax_glom(ps_boruta, taxrank = "Genus"))[,6]



tax_table(test)[,6]%>%length()

test<-tax_glom(ps_boruta, taxrank = "Genus")
#PEDRO, WITH THIS YOU CAN FIND AND REPLACE THE OUTPUT OF BORUTA WITH THE TAXONOMIES NAMES



load( file="./data/imp_asv_list.Rdata")
imp_asv_list<-export
save(imp_asv_list,file="./data/imp_asv_list.Rdata")


imp_asv_list

ps_l




mapply (function (z,y)
    prune_taxa(taxa = z, x = y), #here, x as the name of an argument of prune_taxa, and refers to a phyloseq object
  z = imp_asv_list,
  y = ps_l,
  SIMPLIFY = FALSE)






#**********************************************#
############# fisher_all_taxa_groups ################
#**********************************************#

# this function takes 2 phyloseq objects as 2 arguments:
# ips_important_taxa =  a subset of imporntant taxa, such as ASVs tagged as important by differential abundance, random forest, and netowrk analysis
# ps_all_taxa = the full phyloseq objects from where you obtained the imporntat subset (and likely your input for differential abundance, random forest, and netowork analysis)

# Then it runs a fisher test, comparing the proportions of every taxonomic level accuting more than twice in both datasets
# it's just a test to compare proportions - is 6 out of 17 a similar proportion to 193 out of 2243?
# note: using phyloseq::subset_taxa with a for loop will cause issues as your taxa is intepreted as "i"! to avoid this, use phyloseq::prune_taxa instead

fisher_all_taxa_groups<-function(ps_important_taxa, ps_all_taxa){
  
  
  
  
  # first, get the taxonomic groups of the taxa defined as important
  
  #this will get us a list of (taxa_level) that appears in the important subset more than once
  imp_phylum_l<-as.character(tax_table(ps_important_taxa)[,"Phylum"]) # gets a char vector  of "families" shown as relevant
  imp_phylum_l<-imp_phylum_l[imp_phylum_l != "p__uncultured"] # removes any taxonomy set as "uncultured"
  imp_phylum_l<-names(which(table(imp_phylum_l)>2))%>% # get names of taxa that occur ate least 1 time NOTE: CHANGED FROM >2
    na.omit()%>% #remove NA from classifications
    unique()%>%  #dereplicates repetitive values (avoids "f__Chitinophagaceae" "f__Chitinophagaceae" "f__Oxalobacteraceae")
    as.list(c()) # save the dereplicated values as a list
  
  # now, perfom the same as above for every taxa level... it's hard-coded, but it works well enough. Pedro tried automating this and gave up after a few hours
  imp_class_l<-as.character(tax_table(ps_important_taxa)[,"Class"]) 
  imp_class_l<-imp_class_l[imp_class_l != "c__uncultured"] 
  imp_class_l<-names(which(table(imp_class_l)>2))%>% 
    na.omit()%>% 
    unique()%>%  
    as.list(c()) 
  
  imp_order_l<-as.character(tax_table(ps_important_taxa)[,"Order"])
  imp_order_l<-imp_order_l[imp_order_l != "o__uncultured"]
  imp_order_l<-names(which(table(imp_order_l)>2))%>%
    na.omit()%>% 
    unique()%>%
    as.list(c()) 
  
  imp_fam_l<-as.character(tax_table(ps_important_taxa)[,"Family"])
  imp_fam_l<-imp_fam_l[imp_fam_l != "f__uncultured"]
  imp_fam_l<-names(which(table(imp_fam_l)>2))%>%
    na.omit()%>% 
    unique()%>% 
    as.list(c()) 
  
  imp_genus_l<-as.character(tax_table(ps_important_taxa)[,"Genus"])
  imp_genus_l<-imp_genus_l[imp_genus_l != "g__uncultured"]
  imp_genus_l<-names(which(table(imp_genus_l)>2))%>%
    na.omit()%>% 
    unique()%>% 
    as.list(c()) 
  
  
  
  
  
  
  
  
  
  # second, get the number of taxa occuring in each taxonomic group, within the imporntat taxa subset
  
  #make one empty lists to store results
  target_in_important_n<-list()
  
  # obtain the number of reads of the target taxa in the important subset
  for(i in imp_phylum_l) { #for every Phylum "i" with representatives defined as important....
    target_in_important_n[i]<-phyloseq::ntaxa(prune_taxa(taxa = tax_table(ps_important_taxa)[,"Phylum"] %in% i, # get only the taxa that belong to that particular phylum "i", then define the number of taxa in there, then save it in the empty list we just made to store the results
                                                         x = ps_important_taxa))
  }
  
  # now, perfom the same as above for every taxa level... it's hard-coded, but it works well enough. Pedro tried automating this and gave up after a few hours
  for(i in imp_class_l) {
    target_in_important_n[i]<-phyloseq::ntaxa(prune_taxa(taxa = tax_table(ps_important_taxa)[,"Class"] %in% i,
                                                         x = ps_important_taxa))
  }
  
  for(i in imp_order_l) {
    target_in_important_n[i]<-phyloseq::ntaxa(prune_taxa(taxa = tax_table(ps_important_taxa)[,"Order"] %in% i,
                                                         x = ps_important_taxa))
  }
  
  
  for(i in imp_fam_l) {
    target_in_important_n[i]<-phyloseq::ntaxa(prune_taxa(taxa = tax_table(ps_important_taxa)[,"Family"] %in% i,
                                                         x = ps_important_taxa))
  }
  
  for(i in imp_genus_l) {
    target_in_important_n[i]<-phyloseq::ntaxa(prune_taxa(taxa = tax_table(ps_important_taxa)[,"Genus"] %in% i,
                                                         x = ps_important_taxa))
  }
  
  
  
  
  
  
  
  
  
  # third, get the number of taxa occuring in each taxonomic group, within the full dataset 
  
  #make one empty lists to store results
  target_in_all_n<-list()
  
  # obtain the number of reads of the target taxa in the important subset
  for(i in imp_phylum_l) { #for every Phylum "i" with representatives defined as important....
    target_in_all_n[i]<-phyloseq::ntaxa(prune_taxa(taxa = tax_table(ps_all_taxa)[,"Phylum"] %in% i, # get only the taxa that belong to that particular phylum "i", then define the number of taxa in there, then save it in the empty list we just made to store the results
                                                   x = ps_all_taxa))
  }
  
  # now, perfom the same as above for every taxa level... it's hard-coded, but it works well enough. Pedro tried automating this and gave up after a few hours
  for(i in imp_class_l) {
    target_in_all_n[i]<-phyloseq::ntaxa(prune_taxa(taxa = tax_table(ps_all_taxa)[,"Class"] %in% i,
                                                   x = ps_all_taxa))
  }
  
  for(i in imp_order_l) {
    target_in_all_n[i]<-phyloseq::ntaxa(prune_taxa(taxa = tax_table(ps_all_taxa)[,"Order"] %in% i,
                                                   x = ps_all_taxa))
  }
  
  
  for(i in imp_fam_l) {
    target_in_all_n[i]<-phyloseq::ntaxa(prune_taxa(taxa = tax_table(ps_all_taxa)[,"Family"] %in% i,
                                                   x = ps_all_taxa))
  }
  
  for(i in imp_genus_l) {
    target_in_all_n[i]<-phyloseq::ntaxa(prune_taxa(taxa = tax_table(ps_all_taxa)[,"Genus"] %in% i,
                                                   x = ps_all_taxa))
  }
  
  
  
  
  
  
  
  
  
  # now, get the total number of taxa in the imporntat subset and in the full dataset
  
  # all important taxa
  all_taxa_in_important_n<-phyloseq::ntaxa(ps_important_taxa)
  
  #all taxa 
  all_taxa_in_all_n<-phyloseq::ntaxa(ps_all_taxa)
  
  
  
  
  
  
  
  
  
  # now perform fisher tests over lists; check online tutorials for fisher.test() if need
  
  # this contigency table: (summed marginal totals is equal to the total number of taxa the the full object)
  fisher_result<-mapply(function (target_in_important_n,target_in_all_n)
    fisher.test(matrix(c(target_in_important_n, 
                         all_taxa_in_important_n - target_in_important_n, 
                         target_in_all_n - target_in_important_n, 
                         all_taxa_in_all_n - all_taxa_in_important_n - target_in_all_n),
                       ncol=2),alternative = "greater" ), 
    target_in_all_n = target_in_all_n,
    target_in_important_n = target_in_important_n,
    SIMPLIFY = FALSE)
  
  return(fisher_result)
  
}

