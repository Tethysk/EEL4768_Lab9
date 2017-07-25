.text # code goes here
	lui $s5, 0x1000 # loading upper address_source
	ori $s2, $s5, 0x0020 # loading lower address_source
	lw  $s4, 4($s2)
	add $s7, $s2, $s4
	sw  $s7, 0($s2)
	lw  $s1, 0($s2)
	lb  $s3, 1($s2)

	
