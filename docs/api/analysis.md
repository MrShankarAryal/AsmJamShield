# Analysis API Documentation

## Packet Analysis

### `analyze_packet(packet_buffer, size)`
Performs deep packet inspection.

### `detect_anomalies(packet_data, threshold)`
Identifies suspicious patterns.

## Threat Detection

### `analyze_threats()`
Real-time threat analysis engine.

## Configuration

### `set_analysis_params()`
```assembly
mov rdi, analysis_config
call set_analysis_params
```