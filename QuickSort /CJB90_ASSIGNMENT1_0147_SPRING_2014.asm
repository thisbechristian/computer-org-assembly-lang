#COE 0147 Project 1 - MIPS Sort
# Name:		Christian Boni (cjb90)
# Class:	COE 147 - T/H 1PM
# Date:		3/20/14


.data

error_str: .asciiz "\nError - Incorrect Order:\n"

num_lists: .byte 5 #number of lists to sort

array_list: .word test1, test2, test3, test4, test5
size_list: .word t1size, t2size, t3size, t4size, t5size

# ====== DO NOT EDIT BELOW THIS LINE ====== #


.text 

li $s0, 0

la $s1, array_list
la $s2, size_list


main_loop:
lw $a0, 0($s1)
lw $t0, 0($s2)
lb $a1, 0($t0)


jal sort

jal print_array

li $a0, 10
li $v0, 11
syscall

addi $s0, $s0, 1
addi $s1, $s1, 4
addi $s2, $s2, 4

la $t1, num_lists
lb $t0, 0($t1)
bne $t0, $s0, main_loop

#main loop end - program termination
li $v0, 10
syscall


sort:
addi $sp, $sp, -24
sw $ra, 0($sp)
sw $a0, 4($sp)
sw $a1, 8($sp)
sw $s0, 12($sp)
sw $s1, 16($sp)
sw $s2, 20($sp)
# ======= PUT YOUR SORT ALGORITHM HERE ======== #
# ==== Register $a0 contains array pointer ==== #
# ==== Register $a1 contains array length ===== #

#-------------------------------------------------------------------------------------------------------------------------------------------------------------

move	$s0, $a0		#Store address and length of array in $s0-$s1
move	$s1, $a1

move	$v0, $zero		#Initialize low ($v0) to 0 and high ($v1) to (length of array-1)
addi	$v1, $a1, -1

slt	$t0, $v0, $v1		#Check to see if low < high
bne	$t0, 1, end		#If there is only one time in the array, branch to end

#-------------------------------------------------------------------------------------------------------------------------------------------------------------

move	$t0, $s0			#Store address and length of array -1 (counter) in $t0-$t1
move	$t1, $v1			#Counter is $t1

check:					#while(A[i] <= A[i+1]): loop to check if the array was previously sorted
					
	beq	$t1, $zero, end		#If counter = 0 branch to end, this means the entire array was previously sorted.
	
	lw	$t2, 0($t0)		#Load A[i] into $t2
	lw	$t3, 4($t0)		#Load A[i+1] into $t3
	bgt	$t2, $t3, endCheck	#If A[i] > A[i+1], terminate the loop
	
	addi	$t0, $t0, 4		#i++
	subi	$t1, $t1, 1		#Decrement the counter
	
	j check

endCheck:

#-------------------------------------------------------------------------------------------------------------------------------------------------------------

jal 	quickSort
j 	end


#Inputs: 	low: $v0, high: $v1
quickSort:

addi	$sp, $sp, -16		#Prologue: Decrement the stack and push current return address
sw	$ra, 0($sp)

slt	$t0, $v0, $v1		#Check to see if low < high
bne	$t0, 1, baseCase	#If base case of recursion is reached, branch to "baseCase"

sub	$t0, $v1, $v0		#Check to see if length of array <= 10
blt 	$t0, 11, baseCase2	#If second base case of recursion is reached, branch to "baseCase2"

jal	partition		#$s2 will contain new pivot

sw	$v0, 4($sp)		#Push current low, high, and new pivot ($s2) onto the stack 
sw	$v1, 8($sp)
sw	$s2, 12($sp)	

addi	$v1, $s2, -1		#Recursively sort from low to (pivot-1)
jal	quickSort

lw	$v0, 4($sp)		#Get current low, high, and new pivot ($s2) from the stack 
lw	$v1, 8($sp)
lw	$s2, 12($sp)

addi	$v0, $s2, 1		#Recursively sort from (pivot+1) to high
jal	quickSort

endQuickSort:

lw	$ra, 0($sp)		#Epilogue: Increment the stack and pop current return address, low, high, and pivot from the stack
lw	$v0, 4($sp)
lw	$v1, 8($sp)
lw	$s2, 12($sp)
addi	$sp, $sp, 16	
jr	$ra

#-------------------------------------------------------------------------------------------------------------------------------------------------------------
baseCase2:

# Inputs low $v0, high $v1, original array pointer $s0
insertionSort:

move	$t4, $s0	#Store pointer to beginning of the *original* array in $t4
sll	$t0, $v0, 2	#Get offset of low in word format
add	$t4, $t4, $t0	#Add offset of low to get starting point of the sub-array and store in $t4
sub	$t5, $v1, $v0	#Store counter / (length of array - 1) to $t5
		
		
move	$t0, $t4	#Store temporary pointer to beginning of array in $t0
addi	$t0, $t0, 4	#Increment pointer to array so it points to A[1], this is because A[0] is already sorted in terms of insertion sort
		
loop1:						#for(int i = counter; i > 0; i--) 
	beq	$t5, $zero, endLoop1		#Branch to endLoop if Counter = 0;
		
	lw	$t1, 0($t0)			#Load A[i] in $t1
	addi	$t3, $t0, -4			#Store pointer to A[i-x] in $t3, where x = 1 (however in this case 4 beacuse of word addressing)
		
	loop2:						#while(A[i] < A[i-x] && (x <= i))
		slt	$t6, $t3, $t4		
		bne	$t6, $zero, endLoop2		#Branch to endLoop2 if reached an address prior to the beginning of array, condition: (x > i)
		
		lw	$t2, 0($t3)			#Load A[i-x] in $t2
		slt	$t7, $t1, $t2		
		beq	$t7, $zero, endLoop2		#Branch to endLoop2 if A[i] >= A[i-x]
	
		sw	$t2, 4($t3)			#Store A[i-x] into A[(i-x) + 1]
			
		addi	$t3, $t3, -4			#Increment x and Store new pointer to A[i-x] in $t3
			
		j loop2
			
	endLoop2:
		
	addi	$t3, $t3, 4			#Decrement x and Store new pointer to A[i-x] in $t3
	sw	$t1, 0($t3)			#Store A[i] into A[i-x], in its correctly sorted position
		
	addi	$t0, $t0, 4			#Increment A[i] to A[i+1]
	addi	$t5, $t5, -1			#Decrement the counter (i)
		
	j loop1
		
endLoop1:

#-------------------------------------------------------------------------------------------------------------------------------------------------------------

baseCase:
lw	$ra, 0($sp)		#Epilogue for BaseCase: Increment the stack and pop only the current return address
addi	$sp, $sp, 16
jr	$ra

#-------------------------------------------------------------------------------------------------------------------------------------------------------------

# Inputs low $v0, high $v1, Output pivot index $s2
partition:

add	$t0, $v0, $v1 	#Find pivot point index by using the middle of the array
addi	$t0, $t0, 1	#Add one to get true length of array
div	$s2, $t0, 2	#$s2 contains current pivot point index

move	$t0, $s0	#Store temp addresses of array in $t0, $t1
move	$t1, $s0
sll 	$s2, $s2, 2	#Get offset of pivot and high in word format
sll 	$v1, $v1, 2
add	$t0, $t0, $s2	#Add offset of pivot point to address
add	$t1, $t1, $v1	#Add offset of high to address
srl	$s2, $s2, 2	#Return offset of pivot and high to byte format
srl 	$v1, $v1, 2


lw	$t6, ($t0)	#Swap pivot and high, pivot value stored in $t6
lw	$t3, ($t1)	
sw	$t6, ($t1)
sw	$t3, ($t0)

move	$t0, $v0	#$t0 is the storeindex
move	$t7, $v0	#$t7 is the counter 'i'

loop:			#for(i = low; i < high; i++)
slt	$t1, $t7, $v1
bne	$t1, 1 loopEnd

move	$t1, $s0	#Store temp address of array in $t1
sll 	$t7, $t7, 2	#Get offset of i in word format
add	$t1, $t1, $t7 	#Add offset of i to address
lw	$t2, ($t1)	#Store value of array[i] into $t2
srl 	$t7, $t7, 2	#Return offset of i in byte format

sgt 	$t3, $t2, $t6	#if(array[i] <= pivotvalue) 
bne	$t3, $zero, loopBottom	#else branch to loopBottom

move	$t3, $s0	#Store temp address of array in $t3
sll 	$t0, $t0, 2	#Get offset of storeIndex in word format
add	$t3, $t3, $t0 	#Add offset of storeindex to address
lw	$t4, ($t3)	#Store value of array[storeindex] into $t4
srl 	$t0, $t0, 2	#Return offset of storeIndex in byte format
		
sw	$t4, ($t1)	#Swap array[i] and array[storeindex]
sw	$t2, ($t3)
addi	$t0, $t0, 1	#Increment storeIndex

loopBottom:
addi	$t7, $t7, 1	#Increment counter
j	loop

loopEnd:
move	$t1, $s0	#Store temp address of array in $t1
move	$t2, $s0	#Store temp address of array in $t2
sll 	$t0, $t0, 2	#Get offset of storeIndex and high in word format
sll 	$v1, $v1, 2
add	$t1, $t1, $t0	#Add offset of storeindex point to address
add	$t2, $t2, $v1	#Add offset of high value (pivot) to address
srl 	$t0, $t0, 2	#Return offset of storeIndex and high in byte format
srl 	$v1, $v1, 2

lw	$t3, ($t1)	#Swap array[storeindex] and array[right] (pivot)
lw	$t4, ($t2)	
sw	$t3, ($t2)
sw	$t4, ($t1)

move	$s2, $t0	#Store new pivot index into $s2
jr	$ra

end:

#-------------------------------------------------------------------------------------------------------------------------------------------------------------

# ======== DO NOT EDIT BELOW THIS LINE ======== #
lw $s2, 20($sp)
lw $s1, 16($sp)
lw $s0, 12($sp)
lw $a1, 8($sp)
lw $a0, 4($sp)
lw $ra, 0($sp)
addi $sp, $sp, 24
#sort return
jr $ra



print_array:
addi $sp, $sp, -12
sw $s0, 0($sp)
sw $s1, 4($sp)
sw $s2, 8($sp)

li $s0, 0
move $s1, $a0
add $s2, $a1, -1
lw $t1, 0($s1)
ble $s2, $zero, print_last

print_loop:
lw $t0, 0($s1)
lw $t1, 4($s1)

#print value in $t0
addi $a0, $t0, 0
li $v0, 1
syscall

li $v0, 11
li $a0, 44
syscall
li $a0, 32
syscall

#compare $t0 to $t1
ble $t0, $t1 noerr

#comparision failed, print error msg
add $a0, $t1, 0
li $v0, 1
syscall
la $a0, error_str
li $v0, 4
syscall
add $a0, $t0, 0
li $v0, 1
syscall
li $v0, 11
li $a0, 32
syscall
li $a0, 62
syscall
li $a0, 32
syscall
add $a0, $t1, 0
li $v0, 1
syscall
j exit_print

#no error, check loop
noerr:
addi $s0, $s0, 1
addi $s1, $s1, 4
addi $t2, $s2, 0
bne $s0, $t2, print_loop


#print last value
print_last:
addi $a0, $t1, 0
li $v0, 1
syscall
exit_print:
li $v0, 11
li $a0, 10
syscall

#print_array return
lw $s2, 8($sp)
lw $s1, 4($sp)
lw $s0, 0($sp)
addi $sp, $sp, 12
jr $ra



# ============== PLACE ARRAY DATAS HERE =============== #
# ======= Array sizes MUST be greater than zero ======= #

.data
test1:  .word 0x01, 0x02, 0x04, 0x08, 0x10, 0x11, 0x12, 0x14, 0x18, 0x1C
t1size: .byte 10
test2:	.word 0x04, 0x02, 0x01, 0x1C, 0x10, 0x11, 0x10, 0x14, 0x18, 0x08
t2size: .byte 10
test3:	.word 0x1C, 0x18, 0x14, 0x12, 0x11, 0x10, 0x08, 0x04, 0x02, 0x01
t3size: .byte 10
test4:	.word 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10, 0x10
t4size: .byte 10
test5:	.word 0xFF
t5size: .byte 1

# ========== ADD ANY DATA SEGMENT ITEMS HERE ========== #

