# NGS_Practicals_scRNA

coucouc je suis le readme

5/11/19
We are using machines with high potential on IFB servers. We started it (1 VM16 Cœur64 Go920 Go). 
We cloned a git to be able to save the modifications of our work. To do so: 
sudo chown rstudio.rstudio disk #to be able to change settings
git clone https://github.com/vbouther/TP-single-cell-RNA-seqq.git #clone the git
go in the new folder
git add * (adds everything in the git)
git commit -m « message »  (saves the modifications)
git push

Then we modified the programm script_fastqdump.bash to be able to download the data. We want the two SRR corresponding to the data from day 16. fastqdump can access NCBI. Split-file is used cut the reads, composed of 3 reads: the sequence we are interested in, the barcode and the barcode for sequencing purposes.
Then you have to execute it: 
chmod u+x script_fastqdump.bash # to have the right
./nom du programme # to execute 


6/11/19
On a commencé par analyser la qualité de notre jeu de données grace à la fonction script_fastqdumppartial_fastqc.bash qui appelle fastqc qui génère une analyse de la qualité de nos données qu'on peut ouvrir en HTLM.
Ces données sont mises sur le même fichier html avec 
multiqc ./*_2*.zip & (on ne le fait qu'avec les numéro 2 qui contiennent toute la séquence, on compare nos deux échantillons) 
Les résultats: https://134.158.247.28/files/disk/data/fastqc/multiqc_report.html
On aurait pu le faire aussi pour les fichiers 1 qui contiennent l'amorce. 
On a une bonne qualité de notre jeu de données. On observe beuacoup de duplications mais ce n'est pas étonnant, c'est du au protocole de préparation des données qui comprend une étape d'amplification par PCR.

Ensuite on passe au mapping. 
On utilise la fonction script_prepmap.bash
1. on récupère le génome annoté sur internet avec la fonction wget
#wget url.fa.gz

2. on ouvre le zip avec gunzip
#gunzip -c nomInitial.fa.fz > nomInitial.fa

3. on modifie ce fichier pour récupérer uniquement la première colone du nom du gène+ la séquence. Remarque : on met tous les transcrits ensemble. On ne s'interesse pas à l'épissage alternatif (on ne peut pas comme on a que le 3' des transcrits en single cell RNA seq). 
#awk 'BEGIN{FS="|"}{print $1}' nomInitial > nouveauNom

4. on crée le fichier texte qu'on a besoin pour appeler salmon alevin qui fait le mapping. On l'appelle tmp. C'est un tableau deux colonnes qui fait la correspondance entre les noms des transcrits (exemple transcrit 1 2 3 4 d'un même gène) et le nom du gène (exemple sox2). L'intérêt est que ca évite les conflits : si un transcrit (de nous) est trouvé comme appartenant à 2 transcrits du même gène, pas de problème. 
#awk 'BEGIN{FS="|"}{if($1~">"){print substr($1,2,length($1)),"\t",$6}}' nomInitial > tmp.txt

5. On crée le salmon index. doc: https://salmon.readthedocs.io/en/latest/salmon.html#using-salmon
L'idée est qu'à partir du fichier récupéré on crée un dictionnaire de mots de 31 caractères
#salmon index -t gencode.vM23.pc_transcripts.fa_2.txt -i transcripts_index -k 31
Ce dictionnaire va être testé dans nos transcrits par alevin puis la correspondance sera établie avec les noms des gènes correspondants aux mots du dictionnaire grâce à notre transcrit gene name map (tmp file). 

6. On fait donc le mapping avec alevin https://salmon.readthedocs.io/en/latest/alevin.html#using-alevin
Bonne technique à retenir : on donne un nom aux chemins de dossier et on les appelle avec $nom
#salmon alevin -l ISR \
#-1 $csra"/SRR8795651_1.fastq" $csra"/SRR8795649_1.fastq" \
#-2 $csra"/SRR8795651_2.fastq" $csra"/SRR8795649_2.fastq" \
#--chromium  \
#-i $cgenome"/transcripts_index" -p 6 -o $cgenome"/alevin_output" --tgMap $cgenome"/tmp.txt"

-l ISR : c'est le librarie type. Pour 10X on utilise ISR
-1 et -2 : ouverture des fichiers fastq. 1 correspond aux codes barres et UMI, 2 aux raw-séquences. A noter, on peut juxtaposer nos deux échantillons séparés par un espace. 
--chromium: le protocole
-i: l'index qu'on a créé = le dictionnaire de mots de 31 nucléotides.
-p 6: le nombre de coeurs qu'on utilise de notre machine
--tgMap: le tableau deux colonnes qu'on lui a donné avec la correspondance nom de transcrit / gène. 

Les résultats sont placés dans alevin_output ici. Les documents .log sont des rapports de travail. 