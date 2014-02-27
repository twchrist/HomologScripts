#parseGenes.pl
open(IN,"zebraGenes.txt") ||die("zebraGenes.txt does not open");
open(OUT,">zg.txt") ||die("zg.txt does not open");
@raw = <IN>;
foreach $line (@raw){
	@data = split(" ",$line);
	$gene = $data[1];
	print OUT "$gene\n";
	}