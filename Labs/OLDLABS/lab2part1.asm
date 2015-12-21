.data:

    #Question 1: What is the machine code (in hexadecimal) of these instructions?
    #Sequence 1
    # - Machine Code 1:
    # - Machine Code 2:
    #Sequence 2
    # - Machine Code 1:
    # - Machine Code 2:

    #Question 2: What instruction format are these instructions (R, I, or J)?
    #Sequence 1:
    #Sequence 2:

    #Question 3: What are the values (in hexadecimal) of the immediate field in each instructions?
    #Sequence 1
    # - Immediate Field 1:
    # - Immediate Field 2:
    #Sequence 2
    # - Immediate Field 1:
    # - Immediate Field 2:



.text:

    #============================================================
    #Place here your first instructions to put 0xDEADACFB into $t1.




    #============================================================

    #============================================================
    #Place here your second instructions to put 0xDEADACFB into $t1



  
    #===========================================================

    #============================================================
    #DO NOT MODIFY *ANYTHING* BELOW THIS LINE
    #============================================================
    #The following code uses system calls (syscalls)
    #to print out the result of your code and your answers to the questions.

    #Just to see if it worked, we'll print out $t1.
    addi    $v0, $zero, 4
    la      $a0, result_str
    syscall

    add     $a0, $zero, $t1 #Copy $t1 into $a0 (required to print it)
    addi    $v0, $zero, 34
    syscall

.data
    result_str:     .asciiz "$t1 contains:\n"
    blank_line_str: .asciiz "\n"


