#s1 = n : 10 
addi s1, zero, 10
#t0 : i
addi t0, zero, 0
outer:
    #if i < 10 not branch
    bge  t0, s1, done
    #t1 : j
    addi t1, zero, 0
    #t3 : ptr
    addi t3, zero, 0

    #t2 : i-n-1
    sub  t2, s1, t0
    addi t2, t2, -1

    inner:
        #if j < i-n-1 not branch
        bge  t1, t2, next

        # t5 : ptr[j], t6: ptr[j+1]
        lw   t5, 0(t3)
        lw   t6, 4(t3)

        # t4 == 0 means no swap or a[j] < a[j+1]
        slt  t4, t6, t5
        beq  t4, zero, noswap
        #swap
        sw   t6, 0(t3)
        sw   t5, 4(t3)
    noswap:
        #j++
        addi t1, t1, 1
        addi t3, t3, 4
        jal  zero, inner
next:
    #i++
    addi t0, t0, 1
    jal  zero, outer
done:


sub t0, t1, t2 # t0 = t1 - t2
