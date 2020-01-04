#! /bin/bash



SRR="SRR8795649 SRR8795651"
# Create a folder for the fastqc
mkdir /home/rstudio/disk/data/fastqc

cd /home/rstudio/disk/data/sra_data # go in the working directory

# For each SRR, apply fastq which analysis the quality of the data
for x in $SRR
do
fastqc $x"_1.fastq" -o /home/rstudio/disk/data/fastqc
fastqc $x"_2.fastq" -o /home/rstudio/disk/data/fastqc
#fastqc $x"_3.fastq" -o /home/rstudio/disk/data/fastqc
done

# Then collective analysis of all fastqc results using the multiqc function:
#cd home/rstudio/disk/data/fastqc
#multiqc ./*_2*.zip &
#Remark: we are only interested in the "2" here as it contains the sequence itself. 
