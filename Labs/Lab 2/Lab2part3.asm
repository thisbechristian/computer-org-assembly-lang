# Name:		Christian Boni (cjb90)
# Class:	COE 147 - T/H 1PM
# Date:		1/17/14


.data

v1:	.asciiz 	"What is the first value?\n"
v2:	.asciiz 	"What is the second value?\n"
st1:	.asciiz		"The difference of "
st2:	.asciiz		" and "
st3:	.asciiz		" is "

.text

li	$v0, 4		# Prints string v1
la	$a0, v1
syscall		

li	$v0, 5		# Stores value 1 to $t0
syscall
add	$t0, $zero, $v0	

li	$v0, 4		# Prints string v2
la	$a0, v2
syscall

li	$v0, 5		# Stores value 2 to $t1
syscall
add	$t1, $zero, $v0

sub	$t2, $t0, $t1	# Subtracts value 1 and value 2 and stores it into $t2

li	$v0, 4		# Prints string st1
la	$a0, st1
syscall

li	$v0, 1		# Prints value 1
add	$a0, $zero, $t0
syscall

li	$v0, 4		# Prints string st2
la	$a0, st2
syscall

li	$v0, 1		# Prints value 2
add	$a0, $zero, $t1
syscall

li	$v0, 4		# Prints string st3
la	$a0, st3
syscall

li	$v0, 1		# Prints result
add	$a0, $zero, $t2
syscall

li	$v0, 10		#Ends program
syscall

