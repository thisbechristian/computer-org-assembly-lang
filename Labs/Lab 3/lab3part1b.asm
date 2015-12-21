# Name:		Christian Boni (cjb90)
# Class:	COE 147 - T/H 1PM
# Date:		1/17/14

.data

q:	.asciiz		"Please enter your integer: \n"
a:	.asciiz		"\nHere is the output: "

.text


li	$v0, 4		#print string 'q'
la	$a0, q
syscall

li	$v0, 5		#get integer
syscall

add	$t0,$t0,$v0	#store integer in $t0


li	$t1, 0x380000	#store mask for bits: 19,20,21 in $t1

and	$t2, $t0, $t1	#use mask to grab bits: 19,20,21 in $t0

srl	$t2, $t2, 19	#shift bits 19,20,21 to 0,1,2 and store in $t2

li	$v0, 4		#print string 'a'
la	$a0, a
syscall

li	$v0, 1		#print outcome
add	$a0, $zero, $t2
syscall

