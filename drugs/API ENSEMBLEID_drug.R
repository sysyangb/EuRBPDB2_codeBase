#writer:scp date:20230706 version:V1
# BiocManager::install("httr")
# # Install relevant library for HTTP requests
library(httr)
library(jsonlite)
# Set gene_id variable for AR (androgen receptor)
gene_id <- "ENSG00000141510"

# Build query string to get general information about AR and genetic constraint and tractability assessments 

query_string = "
  query target($ensemblId: String!
   $cursor: String
  $freeTextQuery: String
  $size: Int = 100){
    target(ensemblId: $ensemblId){
      id
      knownDrugs(cursor: $cursor, freeTextQuery: $freeTextQuery, size: $size) {
      count
      cursor
      rows {
        phase
        status
        urls {
          name
          url
        }
        disease {
          id
          name
        }
        drug {
          id
          name
          mechanismsOfAction {
            rows {
              actionType
              targets {
                id
              }
            }
          }
        }
        drugType
        mechanismOfAction
      }
    }
  }
}
"




# Set base URL of GraphQL API endpoint
base_url <- "https://api.platform.opentargets.org/api/v4/graphql"

# Set variables object of arguments to be passed to endpoint
variables <- list("ensemblId" = gene_id)

# Construct POST request body object with query string and variables
post_body <- list(query = query_string, variables = variables)

# Perform POST request
r <- POST(url=base_url, body=post_body, encode='json')

# Print data to RStudio console
# Print data to RStudio console
ENSG00000141510 <- data.frame()
# ENSG00000141510 <- as.data.frame(matrix(nrow=0,ncol=11))

for (i in 1:print(content(r)$data$target$knownDrugs$count)) {
  ENSG00000141510[i,1]<-  print(content(r)$data$target$knownDrugs$rows[[i]]$drug$name)
  drug_id<- print(content(r)$data$target$knownDrugs$rows[[i]]$drug$id)
  ENSG00000141510[i,2]<-  paste ("https://platform.opentargets.org/drug/",drug_id,sep = "", collapse = NULL)
  ENSG00000141510[i,3]<-  print(content(r)$data$target$knownDrugs$rows[[i]]$drugType)
  ENSG00000141510[i,4]<-  print(content(r)$data$target$knownDrugs$rows[[i]]$mechanismOfAction)
  ENSG00000141510[i,5]<-  print(content(r)$data$target$knownDrugs$rows[[i]]$drug$mechanismsOfAction$rows[[1]]$actionType)
  ENSG00000141510[i,6]<-  print(content(r)$data$target$knownDrugs$rows[[i]]$disease$name)
  disease_id <- print(content(r)$data$target$knownDrugs$rows[[i]]$disease$id)
  ENSG00000141510[i,7]<-  paste ("https://platform.opentargets.org/disease/",disease_id,sep = "", collapse = NULL)
  phase<- as.roman(print(content(r)$data$target$knownDrugs$rows[[i]]$phase))
  ENSG00000141510[i,8]<-  paste ("Phase",phase,sep = " ", collapse = NULL)
  ENSG00000141510[i,9]<-  print(content(r)$data$target$knownDrugs$rows[[i]]$status)
  ENSG00000141510[i,10]<-  "ClinicalTrials.gov"
  ENSG00000141510[i,11]<-  print(content(r)$data$target$knownDrugs$rows[[i]]$urls[[1]]$url)
}

# ENSG00000141510[1,1]<-  print(content(r)$data$target$knownDrugs$rows[[1]]$drug$name)
colnames(ENSG00000141510)<- c("Drug","Drug_link","Type","Mechanism Of Action","Action Type","Diease","Diease_link","Phase","Status","Source","Source_link")

#result
write.table(ENSG00000141510,"C:/ENSG00000141510.txt",row.names = F)

write_json(toJSON(ENSG00000141510, pretty=TRUE),"C:/ENSG00000141510.json")
