#getGenomeDBNames.pl
use warnings;
use strict;
use Bio::EnsEMBL::Registry;

## Load the registry automatically
my $reg = "Bio::EnsEMBL::Registry";
$reg->load_registry_from_url('mysql://anonymous@ensembldb.ensembl.org');

## Get the genome CB adaptor
my $genome_db_adaptor = $reg->get_adaptor("Multi", "compara", "GenomeDB");

my $all_genome_dbs = $genome_db_adaptor->fetch_all();
foreach my $this_genome_db (@{$all_genome_dbs}) {
  print $this_genome_db->name, "\t", $this_genome_db->dbID(), "\n";
}