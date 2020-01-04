#! /bin/bash

# create directory for genome data

#mkdir /home/rstudio/disk/data/genome
#cd /home/rstudio/disk/data/genome

# 1 
#fasta sequences whole mouse transcriptome
#wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/gencode.vM23.pc_transcripts.fa.gz #ici on récupère le transcriptome annoté
# 2 
#ouverture du zip
#gunzip -c gencode.vM23.pc_transcripts.fa.gz > gencode.vM23.pc_transcripts.fa 

# 3 
#On veut modifier les fichiers génomes et supprimer la fin du nom pour que ca colle avec notre tmp (voir suite, c'est un fichier texte index qui est necessaire pour l'appel d'Alevin)
#awk 'BEGIN{FS="|"}{print $1}' gencode.vM23.pc_transcripts.fa > gencode.vM23.pc_transcripts.fa_2.txt

#  4 
#on crée un fichier texte où on aura ce qui est necessaire pour appeler salmon alevin: un fichier avec les séquences du génome (transcrit et le nom du gène qui #correspond. On pool tous les transcrits d'un même gène.)
#awk 'BEGIN{FS="|"}{if($1~">"){print substr($1,2,length($1)),"\t",$6}}' gencode.vM23.pc_transcripts.fa > tmp.txt

#optional additional steps:
# In the case where there are spike in the study: (Not the case for us)
#wget https://assets.thermofisher.com/TFS-Assets/LSG/manuals/ERCC92.zip
#unzip ERCC92.zip
#cat 

# get annotation using Gencode: Here we do not need this step as the sequences are already annotated. 
#wget ftp://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/gencode.vM23.primary_assembly.annotation.gtf.gz
#gunzip -c gencode.vM23.primary_assembly.annotation.gtf.gz > gencode.vM23.primary_assembly.annotation.gtf
#awk '{if($3=="transcript"){print substr($12,2,length($12)-3)}}' gencode.vM23.primary_assembly.annotation.gtf > tx2gene.txt
#awk '{...}' ERCC92.gtf > ercc.txt
#... > tx2geneercc.txt


# 5 
#salmon index https://salmon.readthedocs.io/en/latest/salmon.html#using-salmon
#création d'un dictionnaire en mots de 31 nucléotides à partir des transcrits de la base de donnée
#salmon index -t gencode.vM23.pc_transcripts.fa_2.txt -i transcripts_index -k 31

# 6
#tmp est le fichier correspondance transcripts/ genes name
#ensuite avec alevin on fait le mapping https://salmon.readthedocs.io/en/latest/alevin.html#using-alevin: Alevin permet de tester les k-mers de notre index avec les transcrits de notre expérience puis la correspondance est établie avec le nom des gènes, ce qui permet d'obtenir la table des comptes.

csra="/home/rstudio/disk/data/sra_data"
cgenome="/home/rstudio/disk/data/genome"

salmon alevin -l ISR \
-1 $csra"/SRR8795651_1.fastq" \
-2 $csra"/SRR8795651_2.fastq" \
--chromium  \
-i $cgenome"/transcripts_index" -p 6 -o $cgenome"/alevin_output_APPPS1" --tgMap $cgenome"/tmp.txt"

salmon alevin -l ISR \
-1  $csra"/SRR8795649_1.fastq" \
-2  $csra"/SRR8795649_2.fastq" \
--chromium  \
-i $cgenome"/transcripts_index" -p 6 -o $cgenome"/alevin_output_WT" --tgMap $cgenome"/tmp.txt"

#Dans cet alevin on avait traité les deux conditions comme des réplicats techniques alors qu'on doit séparer pour traiter les données:
#salmon alevin -l ISR \
-1 $csra"/SRR8795651_1.fastq" $csra"/SRR8795649_1.fastq" \
-2 $csra"/SRR8795651_2.fastq" $csra"/SRR8795649_2.fastq" \
--chromium  \
-i $cgenome"/transcripts_index" -p 6 -o $cgenome"/alevin_output" --tgMap $cgenome"/tmp.txt"
