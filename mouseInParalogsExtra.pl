#mouseInParalogsExtra.pl
#this script runs through the genes that have not been checked to see if there are any more paralogs to be found

use warnings;
use strict;
use Bio::EnsEMBL::Registry;

## Load the registry automatically
my $reg = "Bio::EnsEMBL::Registry";
$reg->load_registry_from_db(-host => 'useastdb.ensembl.org', -user => 'anonymous');

open(OUT,">mouseInParalogs2.txt") ||die("mouseInParalogs2.txt does not open");
open(OUT2,">checkedMouseInParalogs.txt")||die("checkedMouseInParalogs.txt does not open");


## Get the compara homology adaptor
my $homology_adaptor = $reg->get_adaptor("Multi", "compara", "Homology");
my $genome_db_adaptor = $reg->get_adaptor("Multi", "compara", "GenomeDB");

#get genome databases
#my $mouse_genome_db = $genome_db_adaptor->fetch_by_registry_name("mouse");
my $zebra_genome_db = $genome_db_adaptor->fetch_by_registry_name("zebrafish");
my $gene_member_adaptor = $reg->get_adaptor("Multi", "compara", "GeneMember");
open(IN,"unCheckedMouseInParalogs.txt") ||die("unCheckedMouseInParalogs.txt does not open");
my @genes = <IN>; 
#load in unchecked genes

my $count = 0;
my $paralogs = 0;
 	 foreach my $geneName (@genes){
		#fetch gene member using ID
		chomp($geneName);
		print OUT2 "$geneName\n";
		my $this_member = $gene_member_adaptor->fetch_by_source_stable_id("ENSEMBLGENE",$geneName);
		    my $homologies = $homology_adaptor->fetch_all_in_paralogues_from_Member_NCBITaxon($this_member, $zebra_genome_db->taxon);

		    foreach my $single (@{$homologies}){
		    	
			    print OUT $single->description(), "\n";
			    my $genes = $single->get_all_GeneMembers();
			    foreach my $gene (@{$genes}){
			    	print OUT $gene->source_name(), " ", $gene->stable_id(), " (", $gene->genome_db()->name(()), ")\n";
			    	$paralogs++;
			    	}
			    print OUT "\n";
			    }
			    
			    $count++;
		 
  	}
  	
  print "$count genes were pulled and $paralogs paralogs \n";
 	 