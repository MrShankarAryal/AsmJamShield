section .data
    aes_sbox db 99 dup(0)  ; AES S-box
    aes_key_schedule times 240 db 0
    
section .text
global aes_encrypt_block
global aes_key_expansion

aes_encrypt_block:
    push rbp
    mov rbp, rsp
    sub rsp, 176
    
    ; Save state array
    movdqu xmm0, [rdi]      ; Input block
    
    ; Initial AddRoundKey
    movdqu xmm1, [rsi]      ; First round key
    pxor xmm0, xmm1
    
    ; Main rounds
    mov rcx, 13             ; 14 rounds for AES-256
aes_round:
    ; SubBytes
    call aes_sub_bytes
    
    ; ShiftRows
    call aes_shift_rows
    
    ; MixColumns (except last round)
    cmp rcx, 1
    je skip_mix_columns
    call aes_mix_columns
    
skip_mix_columns:
    ; AddRoundKey
    movdqu xmm1, [rsi + rcx*16]
    pxor xmm0, xmm1
    
    dec rcx
    jnz aes_round
    
    ; Store result
    movdqu [rdx], xmm0
    
    mov rsp, rbp
    pop rbp
    ret

aes_sub_bytes:
    ; Implement S-box substitution
    push rcx
    mov rcx, 16
sub_loop:
    ; S-box lookup and substitution
    movzx eax, byte [state + rcx - 1]
    mov al, [aes_sbox + rax]
    mov [state + rcx - 1], al
    loop sub_loop
    pop rcx
    ret