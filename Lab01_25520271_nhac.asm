# ============================================================
# Lab01_25520271_nhac.asm - Phat Ode to Joy bang syscall MIDI (a=1, b=7)
# Cao do phat = cao do trong mang + a (a=1); ms = do dai * 220 (150+10*b);
# Nhac cu 73 (b mod 4 = 3), am luong 100.
#
# Vai tro thanh ghi:
#   $s0 = con tro mang cao do      $s1 = con tro mang do dai
#   $s2 = so not con lai           $s3 = tong thoi luong du kien (ms)
#   $s4 = thoi diem bat dau (syscall 30, 32 bit thap)
#   $s5 = a (so nua cung dich giong)   $s6 = do dai 1 don vi nhip (ms)
#   $s7 = so hieu nhac cu
#   $t0 = cao do thuc phat   $t1 = thoi luong not (ms)   $t2 = thoi gian do duoc
#   $v0 = so hieu syscall;  $a0-$a3 = doi so syscall
# ============================================================
        .data
caodo:  .word 64, 64, 65, 67, 67, 65, 64, 62, 60, 60, 62, 64, 64, 62, 62
dodai:    .word 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3, 1, 4
sonot:  .word 15                    
a:  .word 1                     
donvi:   .word 220                   
sohieu:  .word 73                    
space:  .asciiz " "
nl:     .asciiz "\n"
msg_t:  .asciiz "Tong du kien (ms): "
msg_m:  .asciiz "Thoi gian do duoc (ms): "

        .text
        .globl main
main:   la   $s0, caodo
        la   $s1, dodai
        lw   $s2, sonot
        lw   $s5, a
        lw   $s6, donvi
        lw   $s7, sohieu
        li   $s3, 0                 
        li   $v0, 30                
        syscall
        move $s4, $a0

loop:   beq  $s2, $zero, done
        lw   $t0, 0($s0)
        addu $t0, $t0, $s5          
        lw   $t1, 0($s1)
        mul  $t1, $t1, $s6          
        addu $s3, $s3, $t1          
        move $a0, $t0               
        li   $v0, 1
        syscall
        la   $a0, space
        li   $v0, 4
        syscall
        move $a0, $t1
        li   $v0, 1
        syscall
        la   $a0, nl
        li   $v0, 4
        syscall
        move $a0, $t0               
        move $a1, $t1
        move $a2, $s7
        li   $a3, 100
        li   $v0, 33               
        syscall
        addiu $s0, $s0, 4
        addiu $s1, $s1, 4
        addiu $s2, $s2, -1
        j    loop

done:   li   $v0, 30                
        syscall
        subu $t2, $a0, $s4          
        la   $a0, msg_t
        li   $v0, 4
        syscall
        move $a0, $s3
        li   $v0, 1
        syscall
        la   $a0, nl
        li   $v0, 4
        syscall
        la   $a0, msg_m
        li   $v0, 4
        syscall
        move $a0, $t2
        li   $v0, 1
        syscall
        la   $a0, nl
        li   $v0, 4
        syscall
        li   $v0, 10
        syscall
