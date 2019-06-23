Declare ML Module "paramcoq".

Variable A : Prop.
Variable B : Prop.

Variable R_b : B -> B -> Prop.

Realizer A as A_r arity 2 := (fun a1 a2 => a1 = a2).
Realizer B as B_r arity 2 := R_b.

Definition cpsT := forall (α:Prop), (B -> α) -> α.

Parametricity cpsT.

Definition id := fun (x : B) => x.

Definition kT := (B -> A).

Parametricity kT.

(* Note that by the fundamental property, the premises are trivially
   satisfied, but the translation really wants an honest-to-goodness
   term and not a variable. *)
Theorem Cont_Shuffle : forall e k, (cpsT_R e e) -> (kT_R k k) ->
                              ((e A k) = (k (e B id))).
Proof.
  intros e k P_e P_k.
  unfold cpsT_R in P_e.
  (* The only clever part: instantiate the relation between types
     A and B to be that a is related to (k b) in the A relation*)
  set (P := (P_e A B (fun (a:A) (b:B) => (A_r a (k b))) k id)).
  unfold id in P at 1.

  exact (P (fun b₁ b₂ H0 => (P_k b₁ b₂ H0))).
Qed.