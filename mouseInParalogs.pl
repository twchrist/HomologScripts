#mouseInParalogs.pl
use warnings;
use strict;
use Bio::EnsEMBL::Registry;

## Load the registry automatically
my $reg = "Bio::EnsEMBL::Registry";
$reg->load_registry_from_url('mysql://anonymous@ensembldb.ensembl.org');

open(OUT,">mouseInParalogs.txt") ||die("zebraInParalogs.txt does not open");

## Get the compara mlss adaptor
my $mlss_adaptor = $reg->get_adaptor("Multi", "compara", "MethodLinkSpeciesSet");

## Get the compara homology adaptor
my $homology_adaptor = $reg->get_adaptor("Multi", "compara", "Homology");
my $genome_db_adaptor = $reg->get_adaptor("Multi", "compara", "GenomeDB");

#get genome databases
#my $mouse_genome_db = $genome_db_adaptor->fetch_by_registry_name("mouse");
my $zebra_genome_db = $genome_db_adaptor->fetch_by_registry_name("zebrafish");

my $seq_member_adaptor = $reg->get_adaptor("Multi", "compara", "SeqMember");
print "fetching gene members \n";
my $gene_members = $seq_member_adaptor->fetch_all_by_source_genome_db_id("ENSEMBLPEP",134);
my $count = 0;
my $paralogs = 0;
 	 foreach my $this_member (@{$gene_members}) {
	    #now fetch in paralogues for first gene member

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
 	 