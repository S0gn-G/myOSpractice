#include "types.h"
#include "riscv.h"

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid() {
  int id = r_tp();
  return id;
}
