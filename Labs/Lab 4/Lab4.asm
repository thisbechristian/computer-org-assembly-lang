# Name:		Christian Boni (cjb90)
# Class:	COE 147 - T/H 1PM
# Date:		1/31/14

.data

ok:		.asciiz 	"The LED pattern matches."

not_ok:		.asciiz		"The LED pattern doesn't match!"

.text
li 	$a0,	0xFFFF0008	#LED memory starts at this address
li 	$a1,	0x7EF965BD	#LEDs to turn on

jal	drawPattern		#Jump and link to drawPattern
jal	getPattern		#Jump and link to getPattern

bne 	$a1, $v0, else		#Return values should be in $v0
la 	$a0, ok			#Load ok string if equal
j end

else:
	la $a0, not_ok		#Load not_ok string if not equal
end:
	li $v0, 4		#Print the string
	syscall
 	
 	li $v0, 10		#Exit
	syscall

drawPattern:
sw	$a1,0($a0)
jr 	$ra

getPattern:
lw	$v0,0($a0)
jr 	$ra

disruptPattern:
