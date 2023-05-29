void print(char *mem) { mem = mem; }

void start(void) {
  char *vidmem = (char *)0xb800;
  print(vidmem);
}

__asm("hlt");
