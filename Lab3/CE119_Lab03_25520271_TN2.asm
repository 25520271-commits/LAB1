# ============================================================
# CE119 - Lab 03 - TN2: Dao thu tu tu tai cho (in-place)
# MSSV: 25520271    d = 1
# Y tuong: dao toan bo chuoi, sau do dao lai tung tu.
# ============================================================
        .data
t1:     .asciiz "kien truc may tinh"
t2:     .asciiz "mips"
t3:     .asciiz ""
t4:     .asciiz "a bc def"
t5:     .asciiz "moi thu tuc co mot khung ngan xep"   # S(d), d = 1
table:  .word   t1, t2, t3, t4, t5
bar:    .asciiz "|"
nl:     .asciiz "\n"

        .text
        .globl main
# main: voi moi chuoi trong table -> reverse_words -> in |chuoi|
# Thanh ghi: $s0 = con tro bang, $s1 = so chuoi con lai, $s2 = dia chi chuoi
main:
        la    $s0, table
        li    $s1, 5
m_loop:
        beq   $s1, $zero, m_done
        lw    $s2, 0($s0)       
        move  $a0, $s2
        jal   reverse_words
        li    $v0, 4            
        la    $a0, bar
        syscall
        li    $v0, 4            
        move  $a0, $s2
        syscall
        li    $v0, 4            
        la    $a0, bar
        syscall
        li    $v0, 4
        la    $a0, nl
        syscall
        addi  $s0, $s0, 4
        addi  $s1, $s1, -1
        j     m_loop
m_done:
        li    $v0, 10
        syscall

strlen:
        move  $v0, $zero
sl_loop:
        addu  $t0, $a0, $v0
        lb    $t1, 0($t0)
        beq   $t1, $zero, sl_done
        addi  $v0, $v0, 1
        j     sl_loop
sl_done:
        jr    $ra

rev_range:
rr_loop:
        sltu  $t0, $a0, $a1     
        beq   $t0, $zero, rr_done
        lb    $t0, 0($a0)
        lb    $t1, 0($a1)
        sb    $t1, 0($a0)
        sb    $t0, 0($a1)
        addi  $a0, $a0, 1
        addi  $a1, $a1, -1
        j     rr_loop
rr_done:
        jr    $ra
reverse_words:
        addi  $sp, $sp, -12     
        sw    $ra, 8($sp)
        sw    $s0, 4($sp)
        sw    $s1, 0($sp)
        move  $s0, $a0          
        jal   strlen            
        move  $a0, $s0           
        addu  $a1, $s0, $v0
        addi  $a1, $a1, -1      
        jal   rev_range
        move  $s1, $s0          
rw_scan:
        lb    $t0, 0($s1)
        beq   $t0, $zero, rw_last   
        li    $t1, 32               
        bne   $t0, $t1, rw_next
        move  $a0, $s0              
        addi  $a1, $s1, -1
        jal   rev_range
        addi  $s0, $s1, 1           
rw_next:
        addi  $s1, $s1, 1
        j     rw_scan
rw_last:
        move  $a0, $s0              
        addi  $a1, $s1, -1
        jal   rev_range
        lw    $s1, 0($sp)      
        lw    $s0, 4($sp)
        lw    $ra, 8($sp)
        addi  $sp, $sp, 12     
        jr    $ra
