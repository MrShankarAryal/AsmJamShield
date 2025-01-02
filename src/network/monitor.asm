section .data
    pcap_error db "PCAP error: %s", 0
    interface_name db "eth0", 0
    
section .bss
    pcap_handle resq 1
    packet_stats resb 1024
    
section .text
global start_monitoring
extern pcap_open_live
extern process_packet

start_monitoring:
    push rbp
    mov rbp, rsp
    sub rsp, 128
    
    ; Initialize packet capture
    call init_packet_capture
    test rax, rax
    jz pcap_init_error
    
    ; Set up packet filters
    call configure_filters
    
    ; Start capture loop
    call capture_loop
    
    mov rsp, rbp
    pop rbp
    ret

capture_loop:
    push rbx
    
.capture:
    ; Capture packet
    mov rdi, [pcap_handle]
    lea rsi, [packet_buffer]
    call pcap_next
    
    ; Process packet securely
    test rax, rax
    jz .capture
    
    ; Validate packet
    lea rdi, [packet_buffer]
    mov rsi, rax
    call validate_packet
    
    ; Process if valid
    test rax, rax
    jz .capture
    
    call process_packet
    
    ; Check for termination signal
    call check_termination
    test rax, rax
    jz .capture
    
    pop rbx
    ret