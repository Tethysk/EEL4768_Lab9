#	Author(s): Dr. Foster
# 	Class: EEL 4768C Comp. Arch. & Org., all sections/times
# 	Last Modified: 1/20/2017
#
# 	Purpose: Copy an array of 1-byte values from a source array to a destination array
#	Inputs/Outputs: 
#		0x10010000 - 4-byte starting address of source array 
#		0x10010004 - 4-byte starting address of destination array 
#		0x10010008 - one-byte unsigned length of both arrays
#	Assumptions: User supplies valid addresses pointing to data memory

# 	Test data for debugging - to be removed/commented out before submission
.data 0x10010000		# This forces the assembler to start places constants at this address
	.word 0x10010020	# point to 0x10010020 for source array
.data 0x10010004
	.word 0x10010040	# point to 0x10010040 for destination array
.data 0x10010008		
	.byte 5				# length of arrays
.data 0x10010020		# supply one-byte test data
	.byte 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12
.data 0x10010040		# initialize destination array to incorrect answers
	.byte 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff  
# end of test data for debugging

.text
	lui $t0, 0x1001
	lw  $t1, 0($t0)		# get address of source table
	lw  $t2, 4($t0) 	# get address of destination table
	lbu $t3, 8($t0) 	# load length of arrays
	
loop:
	beq $t3, $0, done   # if length is 0, exit
	lb $t4, 0($t1)		# grab byte from source...
	sb $t4, 0($t2)		# ...and store in destination array
	addiu $t1, $t1, 1	# point to next byte to move (i.e. address pointed increases by 1)
	addiu $t2, $t2, 1	# point to next byte of space in dest.
	addi  $t3, $t3, -1  # decrement the loop counter
	beq $0, $0, loop
	
done:
	nop
