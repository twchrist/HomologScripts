#zebraTopInParalogs.pl
#this script runs through all genes and prints only the top scoring in paralog 
use warnings;
use strict;
use Bio::EnsEMBL::Registry;

## Load the registry automatically
print "starting the script \n";
my $reg = "Bio::EnsEMBL::Registry";
$reg->load_registry_from_url('mysql://anonymous@ensembldb.ensembl.org');
#stores only the top paired paralogs
open(OUT1,">topZebraInParalogs.txt") ||die("topZebraInParalogs.txt does not open");
#keeps track of what genes have been checked
open(OUT2,">checkedZebraInParalogs.txt") ||die("checkedZebraInParalogs.txt does not open");

## Get the compara homology adaptor
my $homology_adaptor = $reg->get_adaptor("Multi", "compara", "Homology");
my $genome_db_adaptor = $reg->get_adaptor("Multi", "compara", "GenomeDB");

#get genome databases
my $mouse_genome_db = $genome_db_adaptor->fetch_by_registry_name("mouse");
#my $zebra_genome_db = $genome_db_adaptor->fetch_by_registry_name("zebrafish");
my $gene_member_adaptor = $reg->get_adaptor("Multi", "compara", "GeneMember");
#load in genes
open(IN,"zebraGenes.txt") ||die("zebraGenes.txt does not open");
my @genes = <IN>; 
my @paralogs;
#used later to hold total percent identity for each pair
my @averages;
my $count =0;
print "made it to the loop\n";
 	 foreach my $geneName (@genes){
		#fetch gene member using ID
		chomp($geneName);
		print "$geneName \n";
		my $this_member = $gene_member_adaptor->fetch_by_source_stable_id("ENSEMBLGENE",$geneName);
		my $homologies = $homology_adaptor->fetch_all_in_paralogues_from_Member_NCBITaxon($this_member, $mouse_genome_db->taxon);
			#run through all homologies
			$count =0;
		    foreach my $homology (@{$homologies}){

			    my $homMembers = $homology->get_all_Members();
			    my $avg = 0;
			    foreach my $member (@{$homMembers}){
                                   $avg += $member->perc_id;
			    	}
			    	push @averages, $avg;
				$count++;
		
			    }
			    #this makes sure the workup is only applied to genes with homologies
			    if($count){
			    #get index of max percent id
			    my $max;
                            my $index;
                            my $x = 0;
			   for ( @averages )
                            {
                                $index = $x and $max = $_
                                    if !defined $max or $_ > $max;
                                $x++;
                            }
			
                            #grab correct homology and ouput data
                            my $hom = $homologies->[$index];
			    my $members = $hom->get_all_Members();
			    my $genes = $hom->get_all_GeneMembers();
			    #check to make sure neither of these paralogs have been called before
				my $gene1 = $genes->[0]->stable_id();
				my $gene2 = $genes->[1]->stable_id();
				my $alreadyFound = 0;
				foreach my $gene (@paralogs){
				if($gene eq $gene1 || $gene eq $gene2){
					$alreadyFound = 1;
					}
				}
				#if gene hasn't already been printed out then catalog it's data
				if(!$alreadyFound){
					print OUT1 $genes->[0]->stable_id(), "\t";
					print OUT1 $members->[0]->perc_id,"\t",$members->[0]->perc_pos,"\t",$members->[0]->perc_cov,"\t";
					print OUT1 $genes->[1]->stable_id(), "\t";
					print OUT1 $members->[1]->perc_id,"\t",$members->[1]->perc_pos,"\t",$members->[1]->perc_cov,"\n";
					#adds genes to list to prevent recalling
					push @paralogs, $gene1;
					push @paralogs, $gene2;
				}
                            
                            #prep for next round 
                            undef @averages;
		    }
			    #this gene has been checked so it gets printed to the checked list
			    print OUT2 "$geneName\n";
		 
  	}
 
 	 