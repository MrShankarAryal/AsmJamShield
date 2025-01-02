section .data
    SHA256_K dd 64 dup(0)  ; SHA-256 constants

section .text
global calculate_hash
global verify_hash

calculate_hash:
    push rbp
    mov rbp, rsp
    
    ; Initialize hash context
    call init_hash_context
    
    ; Process blocks
    call process_message_blocks
    
    ; Finalize hash
    call finalize_hash
    
    mov rsp, rbp
    pop rbp
    ret

process_message_blocks:
    ; SHA-256 block processing
    push rcx
    mov rcx, [block_count]

.process_loop:
    ; Process each 512-bit block
    call process_block
    dec rcx
    jnz .process_loop
    
    pop rcx
    ret

process_block:
    ; SHA-256 compression function
    push rbx
    
    ; Message schedule
    call prepare_schedule
    
    ; Compression rounds
    mov ecx, 64
.compress:
    call compression_round
    dec ecx
    jnz .compress
    
    pop rbx
    ret