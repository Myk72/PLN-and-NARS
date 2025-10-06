!(register-module! ../../../PLN)
!(import! &self PLN:pln-nars)
!(import! &self PLN:rules:pln-rule)


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