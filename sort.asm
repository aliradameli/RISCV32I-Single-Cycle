addi s1, zero, 10 //0
addi t0, zero, 0 //4
outer:
    #t0 : i
    #if i < 10 not branch
    bge  t0, s1, done  //8
    #t1 : j
    addi t1, zero, 0  //12
    #t3 : ptr
    addi t3, zero, 0 //16

    #t2 : i-n-1
    sub  t2, s1, t0  //20
    addi t2, t2, -1 //24

    inner:
        #if j < i-n-1 not branch
        bge  t1, t2, next //28

        # t5 : ptr[j], t6: ptr[j+1]
        lw   t5, 0(t3) //32
        lw   t6, 4(t3) //36

        # t4 == 0 means no swap or a[j] < a[j+1]
        slt  t4, t6, t5  //40
        beq  t4, zero, noswap //44
        #swap
        sw   t6, 0(t3) //48
        sw   t5, 4(t3) //52
    noswap:
        #j++
        addi t1, t1, 1 //56
        addi t3, t3, 4 //60
        jal  zero, inner //64
next:
    #i++
    addi t0, t0, 1 //68
    jal  zero, outer //72
done:
    //76