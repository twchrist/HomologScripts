#getMouseGenes.pl
#This script will create a text file that holds all zebrafish genes
use warnings;
use strict;
use Bio::EnsEMBL::Registry;

## Load the registry automatically
my $reg = "Bio::EnsEMBL::Registry";
$reg->load_registry_from_url('mysql://anonymous@ensembldb.ensembl.org');

open(OUT,">pufferGenes.txt") ||die("mouseGenes.txt does not open");

my $seq_member_adaptor = $reg->get_adaptor("Multi", "compara", "SeqMember");
print "fetching gene members \n";
my $gene_members = $seq_member_adaptor->fetch_all_by_source_genome_db_id("ENSEMBLGENE",65);
print "starting loop through genes \n";
my $count = 0;
 	 foreach my $gene (@{$gene_members}) {
	    #now fetch in paralogues for first gene member
		print OUT  $gene->stable_id(), "\n";
			    
			    $count++;
  	}
  	
print "$count genes were pulled\n";
