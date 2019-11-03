#! /bin/bash

# create dir


# fasta sequences whole mouse transcriptome
wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/gencode.vM23.pc_transcripts.fa.gz
gunzip ...

# add spike ins ?
wget https://assets.thermofisher.com/TFS-Assets/LSG/manuals/ERCC92.zip
unzip ERCC92.zip
cat 

# get annotation using Gencode
wget ..
gunzip -c gencode.vM23.primary_assembly.annotation.gtf.gz > gencode.vM23.primary_assembly.annotation.gtf
awk '{if($3=="transcript"){print substr($12,2,length($12)-3)}}' gencode.vM23.primary_assembly.annotation.gtf > tx2gene.txt
awk '{...}' ERCC92.gtf > ercc.txt
... > tx2geneercc.txt

# salmon index 
salmon index ...

