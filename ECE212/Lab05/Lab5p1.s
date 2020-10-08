# Ethan Miller and John Burk 3/14/2019
.global main
.set noreorder
main:
    addi $a0,$0,8 # n = 8 (find 8th fib number)
    jal fib # call fib(8)
    addi $0, $0, 0 # branch delay slot
    addi $a0,$0,10 # n = 10 (find 10th fib number)
    jal fib # call fib(10)
    addi $0, $0, 0 # branch delay slot
    addi $a0,$0,1 # n = 1 (find 1st fib number)
    jal fib # call fib(1)
    addi $0, $0, 0 # branch delay slot
    addi $a0,$0,2 # n = 2 (find 2nd fib number)
    jal fib # call fib(2)
    addi $0, $0, 0 # branch delay slot
done:
    j done # infinite loop
    add $0, $0, $0 # branch delay slot
    
# fib(n) function
fib:
    addi $t0, $0, 1 # prev = fib(-1)
    addi $v0, $0, 0 # cur = fib(0)
    addi $t1, $0, 0 # i = 0
    addi $t2, $0, 0 # t = 0
loop:
    slt $t3, $t1, $a0 # i < n
    beq $t3, $0, endfor # branch if i < n = 0
    addi $0, $0, 0 # branch delay slot
    add $t2, $v0, $t0 # t = cur + prev
    addi $t0, $v0, 0 # prev = cur
    addi $v0, $t2, 0 # cur = t
    addi $t1, 1 # i++
    j loop # restart loop
    addi $0, $0, 0 # branch delay slot
endfor:
    jr $ra # return to caller
    add $0, $0, $0 # branch delay slot


