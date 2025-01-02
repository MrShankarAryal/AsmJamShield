# Core API Documentation

## Initialization Functions

### `initialize_security_context()`
Initializes the security monitoring system.
```assembly
push rbp
mov rbp, rsp
call initialize_security_context
```

### `verify_secure_boot()`
Verifies system integrity during startup.

## Memory Management

### `setup_secure_memory()`
Configures protected memory regions.

## Error Handling

### Error Codes
- `0x01`: Initialization failed
- `0x02`: Memory allocation error
- `0x03`: Security verification failed