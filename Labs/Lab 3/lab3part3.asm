# Name:		Christian Boni (cjb90)
# Class:	COE 147 - T/H 1PM
# Date:		1/24/14

.data

buf1: .space 64
buf2: .space 64

q:	.asciiz 	"Please enter your string:\n"
a:	.asciiz 	"Here is the output: "


.text

li	$v0,4		#print out string 'q'
la	$a0,q
syscall

li	$v0,8		#read in string and save to memory
la	$a0,buf1
li	$a1,64
syscall

la	$t0,buf1	#load address of buf1 to $t0
la	$t1,buf2	#load address of buf2 to $t1
li	$s4,10		#ascii code for 'new line'
li	$s6,0		
li	$s7,32		#ascii code for 'space'

LOOP:
	lb	$s0,0($t0)		#load current byte into $s0
	beq	$s0,$s4,COPYADDRESS	#if current byte is null/space/newline procede to copyaddress
	beq	$s0,$s7,COPYADDRESS
	beq	$s0,$zero,COPYADDRESS
	j 	BOTTOM
	
COPYADDRESS:
	add	$t2,$zero,$t0		#copies the current address for buf1 into $t2
	addi	$t0,$t0,1		#increments the address for buf1 and stores current the byte (to check for null)
	lb	$s5,0($t0)
	j 	REVERSE		

REVERSE:
	subi	$s6,$s6,1		#stores letters starting from the end of the first word into buf2 unto the counter reaches 0
	subi	$t2,$t2,1
	lb	$s0,0($t2)
	sb	$s0,0($t1)
	addi	$t1,$t1,1
	beq	$s6,$zero,CHECK
	j	REVERSE

BOTTOM:					#increments the counter and buf1's address
	addi	$s6,$s6,1
	addi	$t0,$t0,1
	j 	LOOP
	
CHECK:					#ends the loop when it reaches a null byte
	beq	$s5,$zero,END
	j	LOOP

END:	
	addi	$t1,$t1,1
	sb	$zero,0($t1)
	
	li	$v0,4		#print out string 'q'
	la	$a0,a
	syscall
	
	li	$v0,4		#print output
	la	$a0,buf2
	syscall
	
	li	$v0,10		#end program
	syscall
	
