void kernel(void) {
    char *string = "Kernel Loaded ";
    volatile char *video = (volatile char *)0xB8000;
    while (*string != 0) {
        *video++ = *string++;
        *video++ = 0x07;
    }

    return;
}
