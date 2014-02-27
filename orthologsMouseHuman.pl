#orthologsMouseHuman.pl
#this script takes in the list of sample human genes with zebrafish duplicate paralogs
#and determines the closest mouse ortholog to the human gene.

use warnings;
use strict;
use Bio::EnsEMBL::Registry;

## Load the registry automatically
my $reg = "Bio::EnsEMBL::Registry";
$reg->load_registry_from_db(-host => 'useastdb.ensembl.org', -user => 'anonymous');

## Get the compara homology adaptor
my $homology_adaptor = $reg->get_adaptor("Multi", "compara", "Homology");
#get genemember adaptor
my $gene_member_adaptor = $reg->get_adaptor("Multi", "compara", "GeneMember");

#read in sample gene set
open(IN,"sampleWGDParalogs.txt")||die("sampleWGDParalogs.txt does not open");
open(OUT,">sampleWGDSetEdited.txt")||die("sampleWGDSetEdited.txt does not open");

print OUT '#GeneName\t#OrthoGene\t#mouseOrthoGene\t#ZebraFishGene1\t#ZebraFishGene2';
my @raw = <IN>;

foreach my $line (@raw){
	#eliminate comment lines
	my $fL = substr($line, 0, 1);
	if($fL ne '#' ){
		my @inputGenes = split('\t',$line);
		#ensure that gene is human
		my $inputGene = $inputGenes[1];
			#fetch gene member for human gene
			my $gene_member = $gene_member_adaptor->fetch_by_source_stable_id("ENSEMBLGENE","$inputGene");
			#get homologies compared to mouse
			my $homologies = $homology_adaptor->fetch_all_by_Member_paired_species($gene_member, "Mus_musculus");
			
			#run through all homologies
			foreach my $single (@{$homologies}){
			#get gene members of homology
			    my $genes = $single->get_all_GeneMembers();
			    #reprint sample dataset but include mouse ortholog
			    print OUT $inputGenes[0], "\t", $inputGenes[1], "\t", $genes->[1]->stable_id(), "\t", $inputGenes[2], "\t", $inputGenes[3];
			    
			    }
			
		}
	
	}