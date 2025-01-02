section .data
    cap_error db "Capture error: %s", 0
    filter_str db "tcp or udp", 0

section .text
global start_capture
extern pcap_compile

start_capture:
    push rbp
    mov rbp, rsp
    
    ; Initialize capture device
    call init_capture_device
    
    ; Set capture filter
    call set_packet_filter
    
    ; Start packet processing
    call process_packets
    
    mov rsp, rbp
    pop rbp
    ret

process_packets:
    push rbx
    
.capture_loop:
    ; Get next packet
    call get_next_packet
    
    ; Validate packet
    call validate_packet
    
    ; Process valid packets
    test rax, rax
    jz .capture_loop
    
    call handle_packet
    jmp .capture_loop
    
    pop rbx
    ret

handle_packet:
    ; Packet processing logic
    push rbx
    
    ; Extract headers
    call extract_headers
    
    ; Analyze packet
    call analyze_packet
    
    ; Log packet info
    call log_packet
    
    pop rbx
    ret