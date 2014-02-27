#editOrthologs.pl
#This script reads in ortholgs and prints out only those with
#one to one orthologs

open(IN,"Orthologs.txt")||die("Orthologs.txt does not open \n");
open(OUT,">editedOrthologs.txt")||die("editedOrthologs.txt does not open \n");
@raw = <IN>;
$totalLength = @raw;
#run through all orthologs
#holds all gene names that have one to one orthologs
#this is used as a check to prevent double reporting
my @orthologs;
print "entering loop with length $totalLength \n";
$count = 0;
for($i = 0; $i<$totalLength;$i++){
	$line = $raw[$i];
	if($line =~ m/ortholog_one2one/){
		@line1 = split(" ",$raw[$i+1]);
		$gene1 = $line1[1];
		$species1 = $line1[2];
		@line2 = split(" ",$raw[$i+2]);
		$gene2 = $line2[1];
		$species2 = $line2[2];
		#loop through previously found orthologs to see if this pair has already been found
		$alreadyFound = 0;
		foreach $gene (@orthologs){
			if($gene eq $gene1 || $gene eq $gene2){
				$alreadyFound = 1;
				}
			}
		if(!$alreadyFound){
			push @orthologs, [$gene1, $gene2];
			print OUT "$gene1\t$species1\t$gene2\t$species2\n"
			$count++;
			}	
		}
	}
print "Final count of pairs is $count \n";