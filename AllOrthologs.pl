#allOrthologs.pl
use warnings;
use strict;
use Bio::EnsEMBL::Registry;

## Load the registry automatically
my $reg = "Bio::EnsEMBL::Registry";
$reg->load_registry_from_db(-host => 'useastdb.ensembl.org', -user => 'anonymous');

open(OUT,">Orthologs.txt") ||die("Orthologs.txt does not open");

## Get the compara mlss adaptor
my $mlss_adaptor = $reg->get_adaptor("Multi", "compara", "MethodLinkSpeciesSet");

## Get the compara homology adaptor
my $homology_adaptor = $reg->get_adaptor("Multi", "compara", "Homology");


## Get all the homologues
my $this_mlss = $mlss_adaptor->fetch_by_method_link_type_genome_db_ids('ENSEMBL_ORTHOLOGUES', [134, 110]);
print OUT $this_mlss->toString()."\n";
my $all_homologies = $homology_adaptor->fetch_all_by_MethodLinkSpeciesSet($this_mlss);
my $count =0;
foreach my $this_homology (@{$all_homologies}) {
	
	  ## print the members in this homology
	  print OUT $this_homology->description(), "\n";
	  my $gene_members = $this_homology->get_all_GeneMembers();
 	 foreach my $this_member (@{$gene_members}) {
	    print OUT $this_member->source_name(), " ", $this_member->stable_id(), " (", $this_member->genome_db()->name(()), ")\n";
  	}
 	 print OUT "\n";
  	 
	$count++;
}

print "There are $count relations between mouse and zebrafish \n";