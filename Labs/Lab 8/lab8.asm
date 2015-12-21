# Name:		Christian Boni (cjb90)
# Class:	COE 147 - T/H 1PM
# Date:		3/7/14

.data

R_str:	.asciiz	"Right Key\n"
L_str:	.asciiz	"Left Key\n"
U_str:	.asciiz	"Up Key\n"
D_str:	.asciiz	"Down Key\n"
C_str:	.asciiz	"Center Key\n"

.text
	li	$s0,5			#Counter for loop
	li	$s1,5			#Number of Green LEDs on the Board
	li	$s4,0			#Marker if previous move was on Green LED (0 = no, 1 = yes)
loop:			
	beq	$s0,$zero,endLoop	#Loop to initialize 5 random green LEDs
	li	$a1,128
	li	$v0,42
	syscall
	move	$t1,$a0
	
	li	$a1,8
	li	$v0,42
	syscall
	move	$t2,$a0
	
	addi	$s0,$s0,-1
	
	move	$a0, $t1
	move	$a1, $t2
	li	$a2, 3
	jal	_setLED
	
	j	loop
	
endLoop:

	li	$a0, 64			#Initialize red starter LEDs
	li	$a1, 3
	li	$a2, 1
	jal	_setLED
	
	
_poll:					# check for a key press
	beq	$s1,$zero, _exit 
	la	$t0,0xffff0000		# status register address	
	lw	$t0,0($t0)		# read status register
	andi	$t0,$t0,1		# check for key press
	bne	$t0,$0,_keypress
	
	j	_poll

_keypress:
					# handle a keypress to change snake direction
	la	$t0,0xffff0004		# keypress register
	lw	$t0,0($t0)		# read keypress register

	# center key
	subi	$t1, $t0, 66				# center key?
	beq	$t1, $0, center_pressed		# 

	# left key
	subi	$t1, $t0, 226				# left key?
	beq	$t1, $0, left_pressed		# 

	# right key
	subi	$t1, $t0, 227				# right key?
	beq	$t1, $0, right_pressed		# 

	# up key
	subi	$t1, $t0, 224				# up key?
	beq	$t1, $0, up_pressed		# 

	# down key
	subi	$t1, $t0, 225				# down key?
	beq	$t1, $0, down_pressed		# 

	j	_poll

right_pressed:
	beq	$s4,$zero,clearLED1		#Checks if previous LED was green and should be restored (0 = no, 1 = yes)
	li	$s4,0
	move	$a0, $s2
	move	$a1, $s3
	li	$a2, 3
	jal	_setLED
	j	cont1
	
clearLED1:
	li	$a2, 0
	jal	_setLED
	
cont1:	addi	$a0, $a0, 1
	bge	$a0, 128, RIGHT_SIDE
	j	move_done
	RIGHT_SIDE:
	li	$a0, 0
	j	move_done

left_pressed:
	beq	$s4,$zero,clearLED2		#Checks if previous LED was green and should be restored (0 = no, 1 = yes)
	li	$s4,0
	move	$a0, $s2
	move	$a1, $s3
	li	$a2, 3
	jal	_setLED
	j	cont2
	
clearLED2:
	li	$a2, 0
	jal	_setLED
	
cont2:	subi	$a0, $a0, 1
	# if a0<0, a0=127
	blt	$a0, $zero, LEFT_SIDE
	j	move_done
	LEFT_SIDE:
	li	$a0, 127
	j	move_done

up_pressed:
	beq	$s4,$zero,clearLED3		#Checks if previous LED was green and should be restored (0 = no, 1 = yes)
	li	$s4,0
	move	$a0, $s2
	move	$a1, $s3
	li	$a2, 3
	jal	_setLED
	j	cont3
	
clearLED3:
	li	$a2, 0
	jal	_setLED
	
cont3:	subi	$a1, $a1, 1
	blt	$a1, $zero, DOWN_SIDE
	j	move_done
	DOWN_SIDE:
	li	$a1, 7
	j	move_done

down_pressed:
	beq	$s4,$zero,clearLED4		#Checks if previous LED was green and should be restored (0 = no, 1 = yes)
	li	$s4,0
	move	$a0, $s2
	move	$a1, $s3
	li	$a2, 3
	jal	_setLED
	j	cont4
	
clearLED4:
	li	$a2, 0
	jal	_setLED
	
cont4:	addi	$a1, $a1, 1
	bge	$a1, 8, UP_SIDE
	j	move_done
	UP_SIDE:
	li	$a1, 0
	j	move_done

center_pressed:
	beq	$s4,$zero,_poll			#If not on a green LED jump back to polling
	j	removeGreen

move_done:
	jal	_getLED
	bne	$v0, $zero, saveGreen
	li	$a2, 1
	jal	_setLED
		
	j	_poll

removeGreen:
	addi	$s1,$s1,-1
	li	$s4,0
	j	_poll

saveGreen:
	move	$s2, $a0			#Save x,y coordinates of green LED, and set green LED flag ($s4) to 1
	move	$s3, $a1
	li	$a2, 1
	jal	_setLED
	
	li	$s4,1
	j	_poll


_exit:
	li	$v0, 10
	syscall

	# void _setLED(int x, int y, int color)
	#   sets the LED at (x,y) to color
	#   color: 0=off, 1=red, 2=orange, 3=green
	#
	# arguments: $a0 is x, $a1 is y, $a2 is color
	# trashes:   $t0-$t3
	# returns:   none
	#
_setLED:
	# byte offset into display = y * 32 bytes + (x / 4)
	sll	$t0,$a1,5      # y * 32 bytes
	srl	$t1,$a0,2      # x / 4
	add	$t0,$t0,$t1    # byte offset into display
	li	$t2,0xffff0008	# base address of LED display
	add	$t0,$t2,$t0    # address of byte with the LED
	# now, compute led position in the byte and the mask for it
	andi	$t1,$a0,0x3    # remainder is led position in byte
	neg	$t1,$t1        # negate position for subtraction
	addi	$t1,$t1,3      # bit positions in reverse order
	sll	$t1,$t1,1      # led is 2 bits
	# compute two masks: one to clear field, one to set new color
	li	$t2,3		
	sllv	$t2,$t2,$t1
	not	$t2,$t2        # bit mask for clearing current color
	sllv	$t1,$a2,$t1    # bit mask for setting color
	# get current LED value, set the new field, store it back to LED
	lbu	$t3,0($t0)     # read current LED value	
	and	$t3,$t3,$t2    # clear the field for the color
	or	$t3,$t3,$t1    # set color field
	sb	$t3,0($t0)     # update display
	jr	$ra
	
	# int _getLED(int x, int y)
	#   returns the value of the LED at position (x,y)
	#
	#  arguments: $a0 holds x, $a1 holds y
	#  trashes:   $t0-$t2
	#  returns:   $v0 holds the value of the LED (0 or 1)
	#
_getLED:
	# byte offset into display = y * 32 bytes + (x / 4)
	sll  $t0,$a1,5      # y * 32 bytes
	srl  $t1,$a0,2      # x / 4
	add  $t0,$t0,$t1    # byte offset into display
	la   $t2,0xffff0008
	add  $t0,$t2,$t0    # address of byte with the LED
	# now, compute bit position in the byte and the mask for it
	andi $t1,$a0,0x3    # remainder is bit position in byte
	neg  $t1,$t1        # negate position for subtraction
	addi $t1,$t1,3      # bit positions in reverse order
    	sll  $t1,$t1,1      # led is 2 bits
	# load LED value, get the desired bit in the loaded byte
	lbu  $t2,0($t0)
	srlv $t2,$t2,$t1    # shift LED value to lsb position
	andi $v0,$t2,0x3    # mask off any remaining upper bits
	jr   $ra
	


