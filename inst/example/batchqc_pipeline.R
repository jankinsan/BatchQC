
library(BatchQC)

### simulate data
nbatch <- 3
ncond <- 2
npercond <- 10
data.matrix <- rnaseq_sim(ngenes=50, nbatch=nbatch, ncond=ncond, npercond=
    npercond, basemean=10000, ggstep=50, bbstep=2000, ccstep=800, 
    basedisp=100, bdispstep=-10, swvar=1000, seed=1234)

### apply BatchQC
batch <- rep(1:nbatch, each=ncond*npercond)
condition <- rep(rep(1:ncond, each=npercond), nbatch)
batchQC(data.matrix, batch=batch, condition=condition, 
        report_file="batchqc_report.html", report_dir=".", 
        report_option_binary="111111111",
        view_report=FALSE, interactive=TRUE, batchqc_output=TRUE)

### apply combat
nsample <- nbatch*ncond*npercond
sample <- 1:nsample
pdata <- data.frame(sample, batch, condition)
modmatrix = model.matrix(~as.factor(condition), data=pdata)
combat_data.matrix = ComBat(dat=data.matrix, batch=batch, mod=modmatrix)

### Rerun the BatchQC pipeline on the batch adjusted data
batchQC(combat_data.matrix, batch=batch, condition=condition, 
        report_file="batchqc_combat_adj_report.html", report_dir=".", 
        report_option_binary="110011111", interactive=FALSE)

### Real signature dataset
### signature data—activating different growth pathway genes (treat[,2]) 
### in human mammary epithelial cells. 
data(example_batchqc_data)
batch <- batch_indicator$V1
condition <- batch_indicator$V2
batchQC(signature_data, batch=batch, condition=condition, 
        report_file="batchqc_signature_data_report.html", report_dir=".", 
        report_option_binary="111111111",
        view_report=FALSE, interactive=TRUE)
### apply combat
nsample <- dim(signature_data)[2]
sample <- 1:nsample
pdata <- data.frame(sample, batch, condition)
modmatrix = model.matrix(~as.factor(condition), data=pdata)
combat_data.matrix = ComBat(dat=signature_data, batch=batch, mod=modmatrix)

### Rerun the BatchQC pipeline on the batch adjusted data
batchQC(combat_data.matrix, batch=batch, condition=condition, 
        report_file="batchqc_combat_adj_signature_data_report.html", 
        report_dir=".", report_option_binary="110011111",
        interactive=FALSE)


### Real bladderbatch dataset
library(bladderbatch)
data(bladderdata)
#### get annotation and data for bladder cancer data ####
pheno <- pData(bladderEset)
edata <- exprs(bladderEset)
batch <- pheno$batch  ### note 5 batches, 3 covariate levels. 
    ### Batch 1 contains only cancer, 2 and 3 have cancer and controls, 
    ### 4 contains only biopsy, and 5 contains cancer and biopsy
condition <- pheno$cancer

#### Filtering only batch 1, 2 and 3 ####
# index <- which((pheno$batch==1) | (pheno$batch==2) | (pheno$batch==3))
# pheno <- pheno[index,]
# batch <- pheno$batch
# condition <- pheno$cancer
# edata <- edata[,index]

batchQC(edata, batch=batch, condition=condition, 
        report_file="batchqc_report.html", report_dir=".", 
        report_option_binary="111111111",
        view_report=FALSE, interactive=TRUE)


### Protein dataset example
data(protein_example_data)
batchQC(protein_data, protein_sample_info$Batch, protein_sample_info$category,
        report_file="batchqc_protein_data_report.html", report_dir=".", 
        report_option_binary="111111111",
        view_report=FALSE, interactive=TRUE)


### Second simulated dataset example with only batch variance difference
nbatch <- 3
ncond <- 2
npercond <- 10
data.matrix <- rnaseq_sim(ngenes=50, nbatch=nbatch, ncond=ncond, npercond=
    npercond, basemean=5000, ggstep=50, bbstep=0, ccstep=2000, 
    basedisp=10, bdispstep=-4, swvar=1000, seed=1234)

### apply BatchQC
batch <- rep(1:nbatch, each=ncond*npercond)
condition <- rep(rep(1:ncond, each=npercond), nbatch)
batchQC(data.matrix, batch=batch, condition=condition, 
        report_file="batchqc_report.html", report_dir=".", 
        report_option_binary="111111111",
        view_report=FALSE, interactive=TRUE, batchqc_output=TRUE)
