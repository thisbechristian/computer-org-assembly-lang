# Name:		Christian Boni (cjb90)
# Class:	COE 147 - T/H 1PM
# Date:		1/17/14

.data

str: .space 64

q:	.asciiz 	"Please enter your string:\n"
a:	.asciiz 	"Here is the output: "


.text

li	$v0,4		#print out string 'q'
la	$a0,q
syscall

li	$v0,8		#read in string to memory
la	$a0,str
li	$a1,64
syscall

la	$t0,str		#load address of start of string to $t0

LOOP:

lb	$t1, 0($t0)		#load current byte into $t1

beq	$t1, $zero, END		#check for null terminator at end of string which ends the loop

slti	$t2, $t1, 91		#branch if it is a lowercase letter
beq	$t2, $zero, LOWER

UPPER:
	slti	$t2, $t1, 65		#convert uppercase letter to lowercase
	bne	$t2, $zero, BOTTOM		
	addi	$t1, $t1, 32
	sb	$t1, 0($t0)
	j	BOTTOM
LOWER:	
	slti	$t2, $t1, 123		#convert lowercase letter to uppercase
	beq	$t2, $zero, BOTTOM
	slti	$t2, $t1, 97
	bne	$t2, $zero, BOTTOM
	subi	$t1, $t1, 32
	sb	$t1, 0($t0) 
	
BOTTOM:	
	addi	$t0, $t0 ,1		#increment address for the next bit
	j	LOOP
	
END:	
	li	$v0,4		#print out string 'a'
	la	$a0,a
	syscall
	
	li	$v0,4		#print out result
	la	$a0,str
	syscall	
	
	
	
	
