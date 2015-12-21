# Name:		Christian Boni (cjb90)
# Class:	COE 147 - T/H 1PM
# Date:		1/17/14

.data

x:	.half 		15
y:	.half		6
z:	.half		0

.text

la	$t0,x		# Load address of x into $t0

lh	$t1,0($t0)	# Load value of x into $t1
lh	$t2,2($t0)	# Load value of y into $t2

add	$t3,$t1,$t2	# Store (x+y) into register $t3

sh	$t3,4($t0)	# Store (x+y) into z
sh	$t3,2($t0)	# Store (x+y) into y
sh	$t3,0($t0)	# Store (x+y) into x
