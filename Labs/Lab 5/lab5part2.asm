# Name:		Christian Boni (cjb90)
# Class:	COE 147 - T/H 1PM
# Date:		2/8/14

.data

S1:	.asciiz 	"Enter the sequence index: "
S2:	.asciiz 	"The Fibonacci value is: "

.text

li	$v0, 4		#Print out S1
la	$a0, S1
syscall

li	$v0, 5		#Read in integer and store in $a0
syscall
move	$s0, $v0
li	$s3, 0		#Initialize the sum to 0 in $s3

jal	pFibonacci

li	$v0, 4		#Print out S2
la	$a0, S2
syscall

li	$v0, 1		#Print out result
move	$a0, $s3
syscall

li	$v0, 10		#End Program
syscall

pFibonacci:
	slti	$t0, $s0, 3		#Check if the current sequence index is less than 3, if not branch to Fibonacci
	beq	$t0, $zero, Fibonacci
	
	slti	$t0, $s0, 1		#Check if the current sequence index is a 0 or 1-2 to set the sum to a 0 or a 1
	bne	$t0, $zero, Return0
	
Return1:
	li	$s3, 1			#Set sum to 1
	jr 	$ra

Return0:
	li	$s3, 0			#Set sum to 0
	jr 	$ra
	
Fibonacci:
	addi	$sp, $sp, -16		#Decrement the counter to store ~ |return address| |current index N| |Sum of fib(N-1)| |Sum of fib(N-2)|
	sw	$ra, 0($sp)		#					$ra		$s0		 $s1		   $s2
	sw	$s0, 4($sp)
		
	addi	$s0, $s0, -1		#Calculate Sum of fib(N-1)
	
	jal	pFibonacci
	
	sw	$s3, 8($sp)		#Save Sum of fib(N-1) on stack
	
	lw	$s0, 4($sp)		#Get current index N from stack
	
	addi	$s0, $s0, -2		#Calculate Sum of fib(N-1)
	
	jal	pFibonacci
	
	sw	$s3, 12($sp)		#Save Sum of fib(N-2) on stack
	
	lw	$ra, 0($sp)		#Pop stack to retrieve ~ |return address| |current index N| |Sum of fib(N-1)| |Sum of fib(N-2)|
	lw	$s0, 4($sp)
	lw	$s1, 8($sp)
	lw	$s2, 12($sp)
	
	addi	$sp, $sp, 16
	
	add	$s3, $s1, $s2		#Calculate the sum of Fib(N) = Fib(N-1) + Fib(N-2)
	
	jr	$ra
	
	
