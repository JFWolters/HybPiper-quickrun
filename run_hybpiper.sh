#!/bin/bash
#Configure for a single run


#input data should be formatted as tab delimited
#data_ID /full/path/to/forward/reads /full/path/to/reverse/reads
inFileName=/full/path/to/input/file.tab

targets=/full/path/to/query/fasta

####BELOW HERE DOES NOT NEED TO BE MODIFIED

#get names of target genes
rm target_names.txt
grep ">" $targets > temp
while read header ; do
    echo $header | cut -f 2 -d "-" >> target_names.txt
done < temp
rm temp

conda=/opt/bifxapps/miniconda3/condabin/conda

IFS=""

source $base_dir/vars.config

echo $sample_name > namelist.txt


$conda init bash
source ~/.bashrc
unset PYTHONPATH
unset PERL5LIB
conda activate /mnt/bigdata/linuxhome/jwolters/conda_envs/hybpiper

while read line ; do
# Run main HybPiper command with all available CPUs
    sample_name=$(echo $line | cut -f 1)
    f_reads=$(echo $line | cut -f 2)
    r_reads=$(echo $line | cut -f 3)

    hybpiper assemble -r $f_reads $r_reads -t_dna $targets --prefix $sample_name --bwa --no_intronerate

    # Get runs statistics
    hybpiper stats -t_dna $targets gene namelist.txt


    # Get heatmap of length recovery
    hybpiper recovery_heatmap seq_lengths.tsv

    # Recover DNA 
    hybpiper retrieve_sequences -t_dna $targets dna --single_sample_name $sample_name --fasta_dir 01_dna_seqs
    
    cd $sample_name
    while read gene ; do
        if [ -f $gene/$sample_name/sequences/FNA/$gene.FNA ] ; then
            cat $gene/$sample_name/sequences/FNA/$gene.FNA > $gene.fasta
        else
            echo "No hit found for $sample_name $gene"
        fi
    done < ../target_names.txt
    
    cd ..
done < $inFileName
conda deactivate


