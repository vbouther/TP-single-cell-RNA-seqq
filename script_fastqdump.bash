#! /bin/bash

# Create a working directory:
data="/home/rstudio/disk/data"
#apparait /mnt/data_local
mkdir -p $data
cd $data

# Create a directory where the data will be downloaded
mkdir -p sra_data
cd sra_data

# Make a list of SRR accessions: we are only interested in the 16d brain
SRR="SRR8795649 SRR8795651"

# For each SRR accession, download the data :
for x in $SRR
do
fastq-dump $x --split-files
 
done 


