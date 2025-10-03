!(register-module! ../../PLN)
!(import! &self PLN:pln-nars)

;; NARS Rule implementation
(: Fact Type)
(: Rule Type)

(: addFact (-> Grounded Symbol Number Number Expression))
(= (addFact $sp $var $s $c)
   (add-atom $sp (Fact $var $s $c)))

(: addStatement (-> Grounded Symbol Symbol Number Number Expression))
(= (addStatement $sp $A $B $f $c)
   (add-atom $sp (Rule $A $B $f $c)))

; Deduction
(: nars-deduction (-> Grounded Symbol Symbol Expression))

(= (nars-deduction $sp $A $C)
   (let* (
          ($existing (collapse (match $sp (Rule $A $C $f $c) ($f $c))))
         )

     (if (not (== $existing ()))
         $existing
         (let* (
                ; rule extraction
                ($r1 (match $sp (Rule $A $B $f1 $c1) ($B $f1 $c1)))
                ($r2 (match $sp (Rule $B $C $f2 $c2) ($C $f2 $c2)))
                (($b $f1 $c1) (superpose ($r1)))
                (($c $f2 $c2) (superpose ($r2)))
               )
              (addStatement $sp $A $C 
                (nars_freqD $f1 $f2) 
                (nars_confD $f1 $f2 $c1 $c2))
         )
     )
   )

)


; Induction
(: nars-induction (-> Grounded Symbol Symbol Expression))

(= (nars-induction $sp $B $A)
   (let* (
            ($existing (collapse (match $sp (Fact $A $f $c) ($f $c))))
         )
     (if (not (== $existing ()))
         $existing
         (let* (
                ; rule extraction
                ($r1 (match $sp (Rule $B $A $f1 $c1) ($f1 $c1)))
                ($r2 (match $sp (Fact $B $f2 $c2) ($f2 $c2)))
                (($f1 $c1) (superpose ($r1)))
                (($f2 $c2) (superpose ($r2)))
               )
              (addFact $sp $A 
                  (nars_freqI $f1 $f2) 
                  (nars_confI $f1 $f2 $c1 $c2)
              )
         ))
   )

)


; Abduction
(: nars-abduction (-> Grounded Symbol Symbol Expression))

(= (nars-abduction $sp $A $B)
   (let* (
            ($existing (collapse (match $sp (Fact $A $f $c) ($f $c))))
         )
     (if (not (== $existing ()))
         $existing
         (let* (
                ; rule extraction
                ($r1 (match $sp (Rule $A $B $f1 $c1) ($f1 $c1)))
                ($r2 (match $sp (Fact $B $f2 $c2) ($f2 $c2)))
                (($f1 $c1) (superpose ($r1)))
                (($f2 $c2) (superpose ($r2)))
               )
              (addFact $sp $A 
                  (nars_freqA $f1 $f2) 
                  (nars_confA $f1 $f2 $c1 $c2)
              )
         ))
   )

)



;;; TEST CASES

!(bind! &dSpace (new-space)) ; dSpace : deduction space
!(bind! &iSpace (new-space)) ; iSpace : induction space
!(bind! &aSpace (new-space)) ; aSpace : abduction space

!(addStatement &dSpace A B 0.8 0.9)
!(addStatement &dSpace B C 0.6 0.7)
!(addFact &dSpace B 0.7 0.9)
!(nars-deduction &dSpace A C)
!(assertEqual (match &dSpace (Rule A C $f1 $c1) ($f1 $c1)) (0.5217391304347826 0.5796))


!(addStatement &iSpace B A 0.8 0.9)
!(addFact &iSpace B 0.6 0.7)
!(nars-induction &iSpace B A)
!(assertEqual (match &iSpace (Fact A $f1 $c1) ($f1 $c1)) (0.8 0.4305239179954442))


!(addStatement &aSpace A B 0.8 0.9)
!(addFact &aSpace B 0.6 0.7)
!(nars-abduction &aSpace A B)
!(assertEqual (match &aSpace (Fact A $f1 $c1) ($f1 $c1)) (0.6 0.50199203187251))