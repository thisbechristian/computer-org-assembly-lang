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
					#Set Sum to A XOR B XOR Cin
	xor	$t5, $a0, $a1		# $t5 = A XOR B
	xor	$v0, $t5, $a2		# $v0 = A XOR B XOR Cin
	
					#Set Cout to (A AND B) OR ((A XOR B) AND Cin)
	and	$t6, $a0, $a1		# $t6 = A AND B
	and	$t7, $t5, $a2		# $t7 = A XOR B AND Cin
	or	$v1, $t6, $t7		# $v1 = (A AND B) OR ((A XOR B) AND Cin)
	
        jr $ra


# AddNumbers 
# 	it adds two strings, each of which represents a 8-bit number 
# INPUT:
# 	$a0 = address of A
# 	$a1 = address of B
# 	$a2 = address of C
# OUTPUT:
#	$v0 = overflow bit (either 0 or 1 in decimal)

pAddNumbers:
	li	$t3, 15		#Set $t3 to 15 for 0-15 iterations
	li	$v0, 0		#Initialize Cin = 0
	li	$v1, 0		#Initialize Sum = 0
	move	$t0, $a0	#Copy addresses of A,B,C into $t0-$t2
	move	$t1, $a1
	move	$t2, $a2
	
	add	$t0, $t0, $t3	#Add 15 Byte offset to address A and B
	add	$t1, $t1, $t3
	
AddNumbers:
	
	addi	$t0, $t0, -1	#Decrement Byte offset on address A and B
	addi	$t1, $t1, -1

	addi	$sp, $sp, -8 	#Decrement the stack and push current Return Address and Sum
	sw	$v0, 0($sp)
	sw	$ra, 4($sp)

	lb	$a0, 0($t0)	#Extract and Convert Bits X any Y that are going to be added
	lb	$a1, 0($t1)
	addi	$a0, $a0, -0x30
	addi	$a1, $a1, -0x30
	move	$a2, $v1	#Store Cin into $a2
	
	addi	$t3, $t3, -1	#Decrement Counter
	
	jal 	BitAdder
	
	beq	$t3, $zero, pDone	#If counter = zero, all bits have been added
	
	jal	AddNumbers		
				
Done:
	lw	$t0, 0($sp)	#Increment the stack and pop current Return Address and Sum
	lw	$ra, 4($sp)
	addi	$sp, $sp, 8
	
	addi	$t0, $t0, 0x30	#Convert Bit to a Character
	
	sb	$t0, 0($t2)	#Store Byte in C
	
	addi	$t2, $t2, 1	#Increment the address of C
	
	jr $ra
	
pDone:
	move	$v0, $v1	 #Store overflow bit in $v0
	j	Done


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
        jal pAddNumbers
	
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
	
	
