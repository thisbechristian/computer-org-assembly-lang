.data
A:	.space	64
B:	.space	64
C:	.space	64

A_str: 	.asciiz	"Please enter the first 16-bit binary number: "
B_str:	.asciiz	"Please enter the second 16-bit binary number: "
C_str:	.asciiz	"Sum is: "
OV_str:	.asciiz	"\nOverflow bit: "

.text
	j main		# DO NOT EDIT THIS LINE

########################
# PLACE YOUR CODE HERE #
########################
# BitAdder
#	adds two bits with the carry in and outputs the 1-bit sum and carry out for the next step
# INPUT:
# 	BitAdder expects arguments in $a0, $a1, $a2
# 	$a0 = specific bit (of values either 0 or 1 in decimal) from A, do not pass character '0' or '1'
# 	$a1 = specific bit (of values either 0 or 1 in decimal) from B, do not pass character '0' or '1'
# 	$a2 = carry in (of values either 0 or 1 in decimal) from previous step
# OUTPUT: 
# 	$v0 = 1-bit sum in $v0 
#	$v1 = carry out for the next stage
BitAdder:
	# prologue
	
	# body
	
	# epilogue

	# return
        jr $ra


# AddNumbers 
# 	it adds two strings, each of which represents a 8-bit number 
# INPUT:
# 	$a0 = address of A
# 	$a1 = address of B
# 	$a2 = address of C
# OUTPUT:
#	$v0 = overflow bit (either 0 or 1 in decimal)
AddNumbers:
	# prologue

	# body

	# loop 16 times for 16 bits 

	# add bit-by-bit
	jal BitAdder

	# loop ends, set $v0 with the overflow

	# epilogue

	
	# return
	jr $ra


#============================================== 
#Do NOT edit the rest of the code in this file.
#============================================== 

main: #
        jal setRegisterStates

	# print A_str
	la	$a0, A_str
	li	$v0, 4
	syscall

	# read A
	la	$a0, A
	li	$a1, 64
	li	$v0, 8
	syscall

	# print B_str
	la	$a0, B_str
	li	$v0, 4
	syscall

	# read B
	la	$a0, B
	li	$a1, 64
	li	$v0, 8
	syscall

	# clip A and B to 16-characters
	li	$t0, 0x00
	la	$t1, A
	sh	$t0, 16($t1)
	la	$t1, B
	sh	$t0, 16($t1)

	# call AddNumbers
	la	$a0, A
	la	$a1, B
	la	$a2, C
        jal AddNumbers
	
	move	$t3, $v0	# save overflow bit

	# clip C to 16-characters
	li	$t0, 0x00
	la	$t1, C
	sh	$t0, 16($t1)

	# print C_str
	la	$a0, C_str
	li	$v0, 4
	syscall

	# print C
	la	$a0, C
	li	$v0, 4
	syscall

	# print OV_str
	la	$a0, OV_str
	li	$v0, 4
	syscall

	# print overflow
	move	$a0, $t3
	li	$v0, 1
	syscall
	
	# done
        jal checkRegisterStates

        li $v0, 10          #Exit
        syscall

setRegisterStates:
    li $s0, -1
    li $s1, -1
    li $s2, -1
    li $s3, -1
    li $s4, -1
    li $s5, -1
    li $s6, -1
    li $s7, -1
    sw $sp, old_sp_value
    sw $s0, ($sp)       #Write something at the top of the stack
    jr $ra

checkRegisterStates:

    bne $s0, -1, checkRegisterStates_failedCheck
    bne $s1, -1, checkRegisterStates_failedCheck
    bne $s2, -1, checkRegisterStates_failedCheck
    bne $s3, -1, checkRegisterStates_failedCheck
    bne $s4, -1, checkRegisterStates_failedCheck
    bne $s5, -1, checkRegisterStates_failedCheck
    bne $s6, -1, checkRegisterStates_failedCheck
    bne $s7, -1, checkRegisterStates_failedCheck

    lw $t0, old_sp_value
    bne $sp, $t0, checkRegisterStates_failedCheck

    lw $t0, ($sp)
    bne $t0, -1, checkRegisterStates_failedCheck

    jr $ra                      #Return: all registers passed the check.
    
    checkRegisterStates_failedCheck:
        la $a0, failed_check    #Print out the failed register state message.
        li $v0, 4
        syscall

        li $v0, 10              #Exit prematurely.
        syscall

.data
	old_sp_value:   .word 0
	failed_check:   .asciiz "One or more registers was corrupted by your code.\n"
	
	
