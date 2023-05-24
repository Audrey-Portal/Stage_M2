####Dry RUN command :
#nohup snakemake -j 200 -s snakemake_mmseqs_taxo_clusters_interest -n --cluster "sbatch -J {params.name} -p {params.partition} -t {params.time} --mem {params.mem} --cpus-per-task {params.threads} -o {params.out} -e {params.err} --constraint='haswell|broadwell|skylake' --exclude=pbil-deb27 " &> nohup_snakemake_mmseqs_taxo_clusters_interest.out &
####Unlock command :
#nohup snakemake -j 200 -s snakemake_mmseqs_taxo_clusters_interest --unlock --cluster "sbatch -J {params.name} -p {params.partition} -t {params.time} --mem {params.mem} --cpus-per-task {params.threads} -o {params.out} -e {params.err} --constraint='haswell|broadwell|skylake' --exclude=pbil-deb27 "  &> nohup_snakemake_mmseqs_taxo_clusters_interest.out &
####Real command :
#nohup snakemake -j 200 -s snakemake_mmseqs_taxo_clusters_interest --cluster "sbatch -J {params.name} -p {params.partition} -t {params.time} --mem {params.mem} --cpus-per-task {params.threads} -o {params.out} -e {params.err} --constraint='haswell|broadwell|skylake' --exclude=pbil-deb27 " &> nohup_snakemake_mmseqs_taxo_clusters_interest.out &

import re
import os

#paths
bin_dir="/beegfs/project/horizon/bin/miniconda3/bin/"   #bin du projet horizon où se trouvent les programmes
scripts_dir="/beegfs/data/aportal/horizon/scripts/Mmseqs_taxo/"   #où se trouvent les scripts appelés
logs_dir="/beegfs/data/aportal/horizon/logs/Mmseqs_taxo/clusters_of_interest/"   #là où vont les logs de chaque script
databases_dir="/beegfs/project/horizon/db/"
seq_dir="/beegfs/data/aportal/horizon/Clustering/clusters_of_interest/"   #où se trouvent les séquences codantes des clusters d'intérêt
taxo_seq_dir="/beegfs/data/aportal/horizon/Mmseqs_taxo/clusters_of_interest/"   #où se trouvent les assignations taxonomiques sur les séquences codantes


#species_list
triplets_file = open('/beegfs/data/aportal/horizon/lists/triplets_list.txt', 'r')
# read the content and split when newline 
list_triplets = triplets_file.read().split('\n') 
list_triplets = list_triplets[:-1] 


rule all:
        input:
                

rule assign_taxo_cds :
        params:
                name="assign_taxo_clusters_interest_{triplet}",
                out=logs_dir+"assign_taxo_clusters_interest_{triplet}.out",
                err=logs_dir+"assign_taxo_clusters_interest_{triplet}.error",
                partition="bigmem",
                threads="8",
                time="30:00:00",
                mem="150G"
        input:
                table_clusters_interest=clusters_interest_dir+"clusters_interest_table.txt"
        output:
                flag=logs_dir+"taxo/{triplet}_taxo_of_interest_done"
        shell:
                """
                cluster_of_interest=$(awk -v triplet={wildcards.triplet} 'triplet~$1 {print $2}' {input.table_clusters_interest})
                for i in $clusters_of_interest
                do
                        {bin_dir}mkdir -p {seq_dir}{wildcards.triplet}/seq_{wildcards.triplet}/seq_$i\_DB/
                        {bin_dir}mmseqs createdb {seq_dir}{wildcards.triplet}/seq_{wildcards.triplet}/seq_$i\.fa {seq_dir}{wildcards.triplet}/seq_{wildcards.triplet}/seq_$i\_DB/seq_$i\_DB
                        {bin_dir}mkdir -p {taxo_seq_dir}{wildcards.triplet}/taxo_$i\/
                        {bin_dir}mmseqs taxonomy --tax-lineage 1 {seq_dir}{wildcards.triplet}/seq_{wildcards.triplet}/seq_$i\_DB/seq_$i\_DB  /beegfs/data/bguinet/these/NR_db {taxo_seq_dir}{wildcards.triplet}/taxo_$i\/taxo_$i {taxo_seq_dir}{wildcards.triplet}/tmp_$i --min-length 30
                        {bin_dir}mmseqs createtsv {seq_dir}{wildcards.triplet}/seq_{wildcards.triplet}/seq_$i\_DB/seq_$i\_DB {taxo_seq_dir}{wildcards.triplet}/taxo_$i\/taxo_$i {taxo_seq_dir}{wildcards.triplet}/taxo_$i\/taxo_$i\.tsv
                done
                touch {output.flag}
                """



###MANUAL sur seq_meteorus_janzen04_5009.g10261.t1_nasonia_training.fa

mkdir -p /beegfs/data/aportal/horizon/Clustering/clusters_of_interest/triplet_190/seqsafe/seq_meteorus_janzen04_5009.g10261.t1_nasonia_training_DB/
mmseqs createdb /beegfs/data/aportal/horizon/Clustering/clusters_of_interest/triplet_190/seqsafe/seq_meteorus_janzen04_5009.g10261.t1_nasonia_training.fa /beegfs/data/aportal/horizon/Clustering/clusters_of_interest/triplet_190/seqsafe/seq_meteorus_janzen04_5009.g10261.t1_nasonia_training_DB/seq_meteorus_janzen04_5009.g10261.t1_nasonia_training_DB

#!/bin/bash
#SBATCH -J assign_taxo_cds_mj04
#SBATCH --partition=normal
#SBATCH -t 30:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=80G
#SBATCH --constraint=haswell|broadwell|skylake
#SBATCH --exclude=pbil-deb27
#SBATCH -o /beegfs/data/aportal/horizon/logs/assign_taxo.out
#SBATCH -e /beegfs/data/aportal/horizon/logs/assign_taxo.error

mkdir -p /beegfs/data/aportal/horizon/Mmseqs_taxo/clusters_of_interest/taxo_seq_meteorus_janzen04_5009.g10261.t1_nasonia_training/
mmseqs taxonomy --tax-lineage 1 /beegfs/data/aportal/horizon/Clustering/clusters_of_interest/triplet_190/seqsafe/seq_meteorus_janzen04_5009.g10261.t1_nasonia_training_DB/seq_meteorus_janzen04_5009.g10261.t1_nasonia_training_DB /beegfs/project/horizon/db/UniRef90/UniRef90 /beegfs/data/aportal/horizon/Mmseqs_taxo/clusters_of_interest/taxo_seq_meteorus_janzen04_5009.g10261.t1_nasonia_training/taxo_seq_meteorus_janzen04_5009.g10261.t1_nasonia_training /beegfs/data/aportal/horizon/Mmseqs_taxo/clusters_of_interest/tmp_meteorus_janzen04_5009.g10261.t1_nasonia_training --min-length 30

#!/bin/bash
#SBATCH -J assign_taxo_cds_mj04
#SBATCH --partition=normal
#SBATCH -t 30:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=100G
#SBATCH --constraint=haswell|broadwell|skylake
#SBATCH --exclude=pbil-deb27
#SBATCH -o /beegfs/data/aportal/horizon/logs/assign_taxo.out
#SBATCH -e /beegfs/data/aportal/horizon/logs/assign_taxo.error
mmseqs taxonomy --tax-lineage 1 /beegfs/data/aportal/horizon/Clustering/clusters_of_interest/triplet_190/seqsafe/seq_meteorus_janzen04_5009.g10261.t1_nasonia_training_DB/seq_meteorus_janzen04_5009.g10261.t1_nasonia_training_DB  /beegfs/data/bguinet/these/NR_db /beegfs/data/aportal/horizon/Mmseqs_taxo/clusters_of_interest/taxo_seq_meteorus_janzen04_5009.g10261.t1_nasonia_training/taxo_seq_meteorus_janzen04_5009.g10261.t1_nasonia_training /beegfs/data/aportal/horizon/Mmseqs_taxo/clusters_of_interest/tmp_meteorus_janzen04_5009.g10261.t1_nasonia_training --min-length 30


#!/bin/bash
#SBATCH -J assign_taxo_cds_mj04
#SBATCH --partition=normal
#SBATCH -t 30:00:00
#SBATCH --cpus-per-task=8
#SBATCH --mem=50G
#SBATCH --constraint=haswell|broadwell|skylake
#SBATCH --exclude=pbil-deb27
#SBATCH -o /beegfs/data/aportal/horizon/logs/assign_taxo_2.out
#SBATCH -e /beegfs/data/aportal/horizon/logs/assign_taxo_2.error

mmseqs taxonomyreport /beegfs/project/horizon/db/UniRef90/UniRef90 /beegfs/data/aportal/horizon/Mmseqs_taxo/clusters_of_interest/taxo_seq_meteorus_janzen04_5009.g10261.t1_nasonia_training /beegfs/data/aportal/horizon/Mmseqs_taxo/clusters_of_interest/taxo_seq_meteorus_janzen04_5009.g10261.t1_nasonia_training_report

mmseqs createtsv /beegfs/data/aportal/horizon/Clustering/clusters_of_interest/triplet_190/seqsafe/seq_meteorus_janzen04_5009.g10261.t1_nasonia_training_DB/seq_meteorus_janzen04_5009.g10261.t1_nasonia_training_DB /beegfs/data/aportal/horizon/Mmseqs_taxo/clusters_of_interest/taxo_seq_meteorus_janzen04_5009.g10261.t1_nasonia_training/taxo_seq_meteorus_janzen04_5009.g10261.t1_nasonia_training /beegfs/data/aportal/horizon/Mmseqs_taxo/clusters_of_interest/taxo_seq_meteorus_janzen04_5009.g10261.t1_nasonia_training.tsv


 /beegfs/data/bguinet/these/NR_db