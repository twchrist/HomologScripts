#parseOutGenesZI.pl
#this script runs through all of the paralogs identified and all of the genes in an organism
#and creates a list of all those genes that are not involved, so far, in a paralog relationship
#with small changes this file will be run on in and out paralogs for mice and zebrafish

#file to store paralogs that need to be checked
open(OUT1,">unCheckedZebraInParalogs.txt") ||die("unCheckedZebraInParalogs.txt does not open");
open(OUT2,">checkedZebraInParalogs.txt") ||die("checkedZebraInParalogs.txt does not open");
#read in full list of genes
open(IN1,"zebraGenes.txt")||die("zebraGenes.txt does not open");
#read in paralogs
open(IN2,"zebraInParalogs.txt")||die("zebraInParalogs.txt does not open");

@genes = <IN1>;
@paralogs = <IN2>;
$count = 0;
#run through all genes
foreach $gene (@genes){
	$ID = $gene;
	chomp($ID);
	$found = 0;
	#run through paralog list 
	foreach $log (@paralogs){
		if($log =~ m/$ID/){
			$found = 1;
			last;
			}
		}
		if(!$found){
			print OUT1 "$ID\n";
			$count ++;
			}
		else{
			print OUT2 "$ID\n";
			}
	}
print "$count genes yet to be found \n";