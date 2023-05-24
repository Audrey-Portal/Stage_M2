#!/usr/bin/python3

#Ligne de commande : 
##python3 Create_gff_busco.py -i input_file.tsv -o output_file.gff

#Importer packages: 
import argparse 

def create_gff_busco(input_file, output_file):
    """
    Creates gff of busco genes of species
    """
        
    #open input file and read lines : 
    f=open(input_file,"r")
    in_file=f.readlines()       

    #open output file :
    out=open(output_file,"w")

    for l in in_file: 
        line=l.strip().split("\t")
        out.write("{}\tBUSCO\tgene\t{}\t{}\t{}\t{}\t.\t{}\n".format(str(line[0]),str(line[3]),str(line[4]),str(line[6]),str(line[5]),str(line[1])))

def main(): 
    parser = argparse.ArgumentParser()
        
    #input:
    parser.add_argument('-i', '--input', type=str, help='tsv file from busco analysis')
    #output: 
    parser.add_argument('-o', '--output', type=str, help='gff of busco gene positions')                     

    args = parser.parse_args()
        
    #Lancer fonctions: 
    print("Starting to gff")
    create_gff_busco(args.input,args.output)
    print("The gff has been completed")
        

if "__main__" == __name__:
    main()