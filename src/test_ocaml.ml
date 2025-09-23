let print_message msg : unit =
        Printf.printf msg;
        flush stdout

let entry () : unit =
        print_message "Hello world from OCaml\n"

let () =
        Callback.register "ocaml_entry" entry
