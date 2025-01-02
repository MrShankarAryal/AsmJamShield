section .data
    welcome_msg db "SecureNetMonitor v1.0", 0
    startup_error db "Startup error: %s", 0

section .text
global _start
extern initialize_security_context
extern start_monitoring
extern cleanup_resources

_start:
    push rbp
    mov rbp, rsp
    
    ; Initialize core systems
    call initialize_security_context
    test rax, rax
    jz startup_failed
    
    ; Start monitoring
    call start_monitoring
    
    ; Cleanup and exit
    call cleanup_resources
    mov rax, 60
    xor rdi, rdi
    syscall

startup_failed:
    mov rdi, 1
    call exit