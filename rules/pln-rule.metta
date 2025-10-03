!(register-module! ../../PLN)
!(import! &self PLN:pln-nars)

;; PLN Rule implementation
(: Fact Type)
(: Rule Type)

(: addFact (-> Grounded Symbol Number Number Expression))
(= (addFact $sp $var $s $c)
   (add-atom $sp (Fact $var $s $c)))

(: addStatement (-> Grounded Symbol Symbol Number Number Expression))
(= (addStatement $sp $A $B $f $c)
   (add-atom $sp (Rule $A $B $f $c)))

; Deduction
(: pln-deduction-ind (-> Grounded Symbol Symbol Expression))

(= (pln-deduction-ind $sp $A $C)
   (let* (
          ; checks if already exists
          ($existing (collapse (match $sp (Rule $A $C $s $c) ($s $c))))
         )

     (if (not (== $existing ()))
         $existing
         (let* (
                ; rule extraction
                ($r1 (match $sp (Rule $A $B $s_AB $c_AB) ($B $s_AB $c_AB)))
                ($r2 (match $sp (Rule $B $C $s_BC $c_BC) ($s_BC $c_BC)))
                (($B $s_AB $c_AB) (superpose ($r1)))
                (($s_BC $c_BC) (superpose ($r2)))

                ; fact extraction
                ($factB (match $sp (Fact $B $s_B $c_B) ($s_B $c_B)))
                (($s_B $c_B) (superpose ($factB)))
                ($factC (match $sp (Fact $C $s_C $c_C) ($s_C $c_C)))
                (($s_C $c_C) (superpose ($factC)))
               )
               
              (addStatement $sp $A $C 
                (pln_str_indD $s_AB $s_BC $s_B $s_C) 
                (pln_conf $c_AB $c_BC))
         )
     )
   )

)



(: pln-deduction-geo (-> Grounded Symbol Symbol Expression))

(= (pln-deduction-geo $sp $A $C)
   (let* (
          ; checks if already exists
          ($existing (collapse (match $sp (Rule $A $C $s $c) ($s $c))))
         )

     (if (not (== $existing ()))
         $existing
         (let* (
                ; rule extraction
                ($r1 (match $sp (Rule $A $B $s_AB $c_AB) ($B $s_AB $c_AB)))
                ($r2 (match $sp (Rule $B $C $s_BC $c_BC) ($s_BC $c_BC)))
                (($B $s_AB $c_AB) (superpose ($r1)))
                (($s_BC $c_BC) (superpose ($r2)))
               )

              (addStatement $sp $A $C 
                (pln_str_geoD $s_AB $s_BC) 
                (pln_conf $c_AB $c_BC))
         )
     )
   )

)



; Induction
(: pln-induction (-> Grounded Symbol Symbol Expression))

(= (pln-induction $sp $A $C)
   (let* (
          ; checks if already exists
          ($existing (collapse (match $sp (Rule $A $C $s $c) ($s $c))))
         )

     (if (not (== $existing ()))
         $existing
         (let* (
                ; rule extraction
                ($r1 (match $sp (Rule $B $A $s_BA $c_BA) ($B $s_BA $c_BA)))
                ($r2 (match $sp (Rule $B $C $s_BC $c_BC) ($B $s_BC $c_BC)))
                (($B $s_BA $c_BA) (superpose ($r1)))
                (($B $s_BC $c_BC) (superpose ($r2)))

               ;  fact extraction
                ($factA (match $sp (Fact $A $s_A $c_A) ($s_A $c_A)))
                (($s_A $c_A) (superpose ($factA)))
                ($factB (match $sp (Fact $B $s_B $c_B) ($s_B $c_B)))
                (($s_B $c_B) (superpose ($factB)))
                ($factC (match $sp (Fact $C $s_C $c_C) ($s_C $c_C)))
                (($s_C $c_C) (superpose ($factC)))
               )
               
              (addStatement $sp $A $C 
                (pln_strI $s_BA $s_BC $s_B $s_A $s_C) 
                (pln_conf $c_BA $c_BC))
         )
     )
   )

)



; Abduction
(: pln-abduction (-> Grounded Symbol Symbol Expression))

(= (pln-abduction $sp $A $C)
   (let* (
          ; checks if already exists
          ($existing (collapse (match $sp (Rule $A $C $s $c) ($s $c))))
         )

     (if (not (== $existing ()))
         $existing
         (let* (
                ; rule extraction
                ($r1 (match $sp (Rule $A $B $s_AB $c_AB) ($B $s_AB $c_AB)))
                ($r2 (match $sp (Rule $C $B $s_CB $c_CB) ($B $s_CB $c_CB)))
                (($B $s_AB $c_AB) (superpose ($r1)))
                (($B $s_CB $c_CB) (superpose ($r2)))

               ;  fact extraction
                ($factB (match $sp (Fact $B $s_B $c_B) ($s_B $c_B)))
                (($s_B $c_B) (superpose ($factB)))
                ($factC (match $sp (Fact $C $s_C $c_C) ($s_C $c_C)))
                (($s_C $c_C) (superpose ($factC)))
               )
               
              (addStatement $sp $A $C 
                (pln_strA $s_AB $s_CB $s_C $s_B) 
                (pln_conf $c_AB $c_CB))
         )
     )
   )

)

;;; TEST CASES

!(bind! &diSpace (new-space)) ; diSpace : deduction-induction space
!(bind! &dgSpace (new-space)) ; dgSpace : deduction-geo space
!(bind! &iSpace (new-space))  ; iSpace : induction space
!(bind! &aSpace (new-space))  ; aSpace : abduction space


!(addStatement &diSpace A B 0.8 0.9)
!(addStatement &diSpace B C 0.6 0.7)
!(addFact &diSpace B 0.5 0.9)
!(addFact &diSpace C 0.7 0.8)
!(pln-deduction-ind &diSpace A C)
!(assertEqual (match &diSpace (Rule A C $s1 $c1) ($s1 $c1)) (0.6399999999999999 0.63))


!(addStatement &dgSpace A B 0.8 0.9)
!(addStatement &dgSpace B C 0.6 0.7)
!(addFact &dgSpace B 0.5 0.9)
!(addFact &dgSpace C 0.7 0.8)
!(pln-deduction-geo &dgSpace A C)
!(assertEqual (match &dgSpace (Rule A C $s1 $c1) ($s1 $c1)) (0.48 0.63))


!(addStatement &aSpace A B 0.8 0.9)
!(addStatement &aSpace C B 0.6 0.7)
!(addFact &aSpace A 0.7 0.9)
!(addFact &aSpace B 0.5 0.8)
!(addFact &aSpace C 0.7 0.6)
!(pln-abduction &aSpace A C)
!(assertEqual (match &aSpace (Rule A C $s1 $c1) ($s1 $c1)) (0.784 0.63))



!(addStatement &iSpace B A 0.8 0.9)
!(addStatement &iSpace B C 0.6 0.7)
!(addFact &iSpace A 0.7 0.9)
!(addFact &iSpace B 0.5 0.8)
!(addFact &iSpace C 0.9 0.6)
!(pln-induction &iSpace A C)
!(assertEqual (match &iSpace (Rule A C $s1 $c1) ($s1 $c1)) (0.8571428571428572 0.63))