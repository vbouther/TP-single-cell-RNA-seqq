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

Then we modified the programm script_fastqdump.bash to be able to download the data. We want the two SRR corresponding to the data from day 16. fastqdump can access NCBI. Split-file is used cut the reads, composed of 3 reads: the sequence we are interested in, the barcode and the barcode for sequencing purposes.
Then you have to execute it: 
chmod u+x script_fastqdump.bash # to have the right
./nom du programme # to execute 