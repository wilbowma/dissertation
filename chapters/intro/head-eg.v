Require Extraction.
Definition Nat := nat.

Inductive List (A : Set) : Nat -> Set :=
| nil : List A 0
| cons : forall (h:A) (n:Nat), List A n -> List A (1 + n).

Definition head {A} {n : Nat} (v : List A (1 + n)) :=
  match v with
  | cons _  h _ t => h
  end.

(* Example invalid := head nil. *)
Example valid : (Nat -> Nat) := head (cons _ (fun x => x) 0 (nil _)).
Print valid.

Definition applyer {n : Nat} (fs : List (Nat -> Nat) (1 + n))
                             (ns : List Nat (1 + n)) :=
  (head fs) (head ns).

Extraction "head.ml" head valid applyer.