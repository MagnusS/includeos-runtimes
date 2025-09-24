(* Based on code from https://github.com/ocaml-multicore/effects-examples/{concurrent,sched}.ml *)

(* Demonstrate the concurrent scheduler
   ------------------------------------
    Spawn binary tree of tasks in depth-first order

        ************
         Fiber tree
        ************
              0
            /  \
           1    2
          / \  / \
         3   4 5  6

*)

let log = Printf.printf

module Sched = struct
        type _ eff += Fork  : (unit -> unit) -> unit eff
        type _ eff += Yield : unit eff

        let fork f = Effect.perform (Fork f)
        let yield () = Effect.perform Yield

        (* A concurrent round-robin scheduler *)
        let run main =
          let run_q = Queue.create () in
          let enqueue k = Queue.push k run_q in
          let dequeue () =
            if Queue.is_empty run_q then () else Effect.Deep.continue (Queue.pop run_q) ()
          in
          let rec spawn f =
            (* Effect handler => instantiates fiber *)
            match f () with
            | () -> dequeue ()
            | exception e ->
                ( print_string (Printexc.to_string e);
                  dequeue () )
            | effect Yield, k ->
                ( enqueue k; dequeue () )
            | effect (Fork f), k ->
                ( enqueue k; spawn f )
          in
          spawn main
end

let rec f id depth =
  log "Starting number %i\n%!" id;
  if depth > 0 then (
    log "Forking number %i\n%!" ((id * 2) + 1);
    Sched.fork (fun () -> f ((id * 2) + 1) (depth - 1));
    log "Forking number %i\n%!" ((id * 2) + 2);
    Sched.fork (fun () -> f ((id * 2) + 2) (depth - 1)))
  else (
    log "Yielding in number %i\n%!" id;
    Sched.yield ();
    log "Resumed number %i\n%!" id);
  log "Finishing number %i\n%!" id

let entry () = Sched.run (fun () -> f 0 2)

let () =
        Callback.register "ocaml_entry" entry
