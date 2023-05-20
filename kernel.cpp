extern "C" void kernel(void) {
  *(char *)0xb8000 = 'P';
  return;
}
