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
