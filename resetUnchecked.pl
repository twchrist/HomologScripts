#resetUnchecked.pl
$unCheckedFile = "unCheckedZebraInParalogs.txt";
$checkedFile = "checkedZebraInParalogs.txt";
$geneFile = "zebraGenes.txt";

#open input files
open(IN1,"$checkedFile") ||die("$checkedFile does not open");
open(IN2,"$geneFile") ||die("$geneFile does not open");

#open output
open(OUT,">$unCheckedFile") ||die("$unCheckedFile does not open");

@checked = <IN1>;
@genes = <IN2>;
#run through all Genes
foreach $gene (@genes){
	chomp($gene);
	$matchFound = 0;
	foreach $cGene (@checked){
		chomp($cGene);
		if($gene =~ m/$cGene/){
			$matchFound = 1;
			}
		}
		if(!$matchFound){
			print OUT "$gene\n";
			}
			
}
