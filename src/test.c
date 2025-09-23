#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <caml/alloc.h>
#include <caml/mlvalues.h>
#include <caml/memory.h>
#include <caml/callback.h>

#define CAML_NAME_SPACE

/*
 * from ocaml-freestanding
 * Warnings are deliberately disabled here to reduce unnecessary verbosity under
 * normal operation. To enable, replace "called = 1" with "called = 0" and
 * rebuild.
 */
#define STUB_WARN_ONCE(type, function, ret) \
    type __unsup_##function(void) __asm__(#function); \
    type __unsup_##function(void) \
    { \
        static int called = 1; \
        if (!called) {\
            printf("STUB: %s() called\n", #function); \
            called = 1; \
        } \
	errno = ENOSYS; \
	return ret; \
    }

STUB_WARN_ONCE(pid_t, getpid, 2);
STUB_WARN_ONCE(pid_t, getppid, 1);
STUB_WARN_ONCE(char *, secure_getenv, NULL);

char *argv[] = { (char*)"hello" , (char*)NULL};

void print_c_stuff() {
	printf("Hello from C\n");
}

void print_ocaml_stuff() {
	static const value * func = NULL;
	if (func == NULL) {
    func = caml_named_value ("ocaml_entry");
	}
  if (func == NULL) {
    printf("unable to call ocaml\n");
  } else {
		caml_callback(*func, Val_unit);
	}
}

void ocaml_init() {
  print_c_stuff();
	caml_startup(argv);
  printf("caml startup complete!\n");
  print_ocaml_stuff();
}
