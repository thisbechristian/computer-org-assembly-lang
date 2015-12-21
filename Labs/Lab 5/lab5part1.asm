# Name:		Christian Boni (cjb90)
# Class:	COE 147 - T/H 1PM
# Date:		2/8/14

.data

String: .space 		64
S1:	.asciiz 	"Enter your string: "
S2:	.asciiz 	"Here is your output: "

.text

li	$v0, 4		#Print out S1
la	$a0, S1
syscall

li	$v0, 8		#Read in String
la	$a0, String
li	$a1, 64
syscall

la	$s0, String	#Copy address of String into $s0
li	$s1, -1		#Initialize counter of characters in String as $s1
li	$s2, 0		#Initialize counter for letters changed to 0 to $s2
li	$s3, 4		#Number of letters to be changed stored in $s3
li	$s4, 0x2A	#Ascii code for an '*' in $s4
li	$s5, 0		#Initialize counter #2 for current number of letters changed to 0 to $s5

NumChar:
	lb	$t1, 0($s0)		#Loop which reads in each byte of the string incrementing the counter until it reaches null
	addi	$s1, $s1, 1
	addi	$s0, $s0, 1
	bne	$t1, $zero, NumChar
	
Loop:
	li	$v0, 42			#Generates a random number with range 0 <= X < N where (N = $s1)
	li	$a0, 1
	move	$a1, $s1
	syscall
	
	move 	$t0, $a0		#Copy random number into $t0
	move	$s5, $zero		#Re-Initialize counter to 0 to $s5
	move	$t3, $sp		#Copy address of current stack pointer to $t3
	
	beq	$s2, $zero, Return
Check:	
	lb	$t1, 0($t3)		#Read byte off stack and increment the stack
	addi	$t3, $t3, 1		
	
	beq	$t0, $t1, Loop		#If random index in stack = new random index, then branch back to loop to get new random index
	
	addi	$s5, $s5, 1		#Else increment the counter and check the remaining bytes of the random indexes in the stack
	bne	$s5, $s2, Check
	
Return:	
	addi	$sp, $sp, -1		#Push byte onto the stack and decrement the stack
	sb	$t0, 0($sp)
	addi	$s2, $s2, 1		#Increment the counter of number of letters changed
	bne 	$s2, $s3, Loop		#Branch back to loop if more letters need to be changed
	la	$s0, String
Swap:	
	lb	$t1, 0($sp)		#Pop byte off stack and increment the stack
	addi	$sp, $sp, 1
	
	add	$s0, $s0, $t1		#Go to the random index in the address and change it to an '*'
	sb	$s4, 0($s0)
	sub	$s0, $s0, $t1
	
	addi	$s3, $s3, -1		#Decrement the counter for how many letters need to be changed
	bne	$s3, $zero, Swap

li	$v0, 4		#Print out S1
la	$a0, S2
syscall	
		
li	$v0, 4				#Print the result
la	$a0, String
syscall

	

