
type __ = Obj.t
let __ = let rec f _ = Obj.repr f in Obj.repr f

type nat =
| O
| S of nat

type nat0 = nat

type 'a list =
| Nil
| Cons of 'a * nat0 * 'a list

(** val head : nat0 -> 'a1 list -> __ **)

let head _ = function
| Nil -> Obj.magic __
| Cons (h, _, _) -> Obj.magic h

(** val valid : nat0 -> nat0 **)

let valid =
  Obj.magic head O (Cons ((fun x -> x), O, Nil))

(** val applyer : nat0 -> (nat0 -> nat0) list -> nat0 list -> nat0 **)

let applyer n fs ns =
  Obj.magic head n fs (head n ns)
let _ = applyer 1 (Cons (0, O, Nil)) (Cons ((fun x -> S x), O, Nil))