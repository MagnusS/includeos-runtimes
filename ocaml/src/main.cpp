/*#include <iostream>
#include "test.c"

int main(){*/

#include <os>
#include <service>
#include "test.c"

void Service::start(const std::string& args){
  std::cout << "Hello world from IncludeOS main\n";

  ocaml_init();
}
