<?php 
// PHP program to implement 
// sequence alignment problem. 

// function to find out 
// the minimum penalty 
function getMinimumPenalty($x, $y, 
						$pxy, $pgap, $pp) 
{ 
	$i; $j; // intializing variables 
	
	$m = strlen($x); // length of gene1 
	$n = strlen($y); // length of gene2 
	
	// table for storing optimal 
	// substructure answers 
	$dp[$n + $m + 1][$n + $m + 1] = array(0); 

	// intialising the table 
	for ($i = 0; $i <= ($n+$m); $i++) 
	{ 
		$dp[$i][0] = $i * $pgap; 
		$dp[0][$i] = $i * $pgap; 
	} 

	// calcuting the 
	// minimum penalty 
	for ($i = 1; $i <= $m; $i++) 
	{ 
		for ($j = 1; $j <= $n; $j++) 
		{ 
			if ($x[$i - 1] == $y[$j - 1]) 
			{ 
				$dp[$i][$j] = $dp[$i - 1][$j - 1] + $pp; 
			} 
			else
			{ 
				$dp[$i][$j] = max($dp[$i - 1][$j - 1] + $pxy , 
								$dp[$i - 1][$j] + $pgap , 
								$dp[$i][$j - 1] + $pgap ); 
			} 
		} 
	} 

	// Reconstructing the solution 
	$l = $n + $m; // maximum possible length 
	
	$i = $m; $j = $n; 
	
	$xpos = $l; 
	$ypos = $l; 

	// Final answers for 
	// the respective strings 
	// $xans[$l + 1]; $yans[$l + 1]; 
	
	while ( !($i == 0 || $j == 0)) 
	{ 
		if ($x[$i - 1] == $y[$j - 1]) 
		{ 
			$xans[$xpos--] = $x[$i - 1]; 
			$yans[$ypos--] = $y[$j - 1]; 
			$i--; $j--; 
		} 
		else if ($dp[$i - 1][$j - 1] + 
				$pxy == $dp[$i][$j]) 
		{ 
			$xans[$xpos--] = $x[$i - 1]; 
			$yans[$ypos--] = $y[$j - 1]; 
			$i--; $j--; 
		} 
		else if ($dp[$i - 1][$j] + 
				$pgap == $dp[$i][$j]) 
		{ 
			$xans[$xpos--] = $x[$i - 1]; 
			$yans[$ypos--] = '_'; 
			$i--; 
		} 
		else if ($dp[$i][$j - 1] + 
				$pgap == $dp[$i][$j]) 
		{ 
			$xans[$xpos--] = '_'; 
			$yans[$ypos--] = $y[$j - 1]; 
			$j--; 
		} 
	} 
	while ($xpos > 0) 
	{ 
		if ($i > 0) $xans[$xpos--] = $x[--$i]; 
		else $xans[$xpos--] = '_'; 
	} 
	while ($ypos > 0) 
	{ 
		if ($j > 0) 
			$yans[$ypos--] = $y[--$j]; 
		else
			$yans[$ypos--] = '_'; 
	} 

	// Since we have assumed the 
	// answer to be n+m long, 
	// we need to remove the extra 
	// gaps in the starting 
	// id represents the index 
	// from which the arrays 
	// xans, yans are useful 
	$id = 1; 
	for ($i = $l; $i >= 1; $i--) 
	{ 
		if ($yans[$i] == '_' && 
			$xans[$i] == '_') 
		{ 
			$id = $i + 1; 
			break; 
		} 
	} 

	// Printing the final answer 
	echo "Minimum Penalty in ". 
		"aligning the genes = "; 
	echo $dp[$m][$n] . "\n"; 
	echo "The aligned genes are :\n"; 
	for ($i = $id; $i <= $l; $i++) 
	{ 
		echo $xans[$i]; 
	} 
	echo "\n"; 
	for ($i = $id; $i <= $l; $i++) 
	{ 
		echo $yans[$i]; 
	} 
	return; 
} 


// Driver code 

// // input strings 
// $gene1 = "GCGACCATCT"; 
// $gene2 = "GTGTGGTACTGGG";

// input strings 
$gene1 = "ACCATCT"; 
$gene2 = "TGGTACTGGG"; 
// intialsing penalties 
// of different types 
$misMatchPenalty = 3; 
$gapPenalty = 1; 
$match = 4;

// calling the function 
// to calculate the result 
getMinimumPenalty($gene1, $gene2, 
	$misMatchPenalty, $gapPenalty, $match); 

// This code is contributed by Abhinav96 
?> 
