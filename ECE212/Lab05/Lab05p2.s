# Ethan Miller and John Burk 3/14/2019
.global main
.set noreorder
main:
    addi $a0,$0,8 # n = 8 (find 8th fib number)
    jal fibr # call fibr(8)
    addi $0, $0, 0 # branch delay slot
    addi $a0,$0,10 # n = 10 (find 10th fib number)
    jal fibr # call fibr(10)
    addi $0, $0, 0 # branch delay slot
    addi $a0,$0,1 # n = 1 (find 1st fib number)
    jal fibr # call fibr(1)
    addi $0, $0, 0 # branch delay slot
    addi $a0,$0,2 # n = 2 (find 2nd fib number)
    jal fibr # call fibr(2)
    addi $0, $0, 0 # branch delay slot
done:
    j done # infinite loop
    add $0, $0, $0 # branch delay slot
    
# fibr(n) function
fibr:
    slti $t0, $a0, 2 # n <= 1
    bne $t0, $0, ret # if (n <= 1) == 1
    addi $0, $0, 0 # branch delay slot
    addi $sp, $sp, -8 # make room for $a0 and $ra
    sw $ra, 4($sp) # save return address
    sw $a0, 0($sp) # save argument
    addi $a0, $a0, -1  # decrement argument
    jal fibr # recur w/ n = n - 1
    addi $0, $0, 0 # branch delay slot
    lw $a0, 0($sp) # pop argument from stack
    sw $v0, 0($sp) # store returned value in its place
    addi $a0, $a0, -2 # decrement argument by 2
    jal fibr # recur w/ n = n - 2
    addi $0, $0, 0 # branch delay slot
    lw $t1, 0($sp) # t1 = fibr(n - 1)
    add $t1, $t1, $v0 # t1 = fibr(n - 1) + fibr(n - 2)
    addi $v0, $t1, 0 # return t1
    lw $ra, 4($sp) # restore return address
    addi $sp, $sp, 8 # change stack pointer
    jr $ra # return to caller
    add $0, $0, $0 # branch delay slot
ret:
    addi $v0, $a0, 0 # return n
    jr $ra # return to caller
    add $0, $0, $0 # branch delay slot
    