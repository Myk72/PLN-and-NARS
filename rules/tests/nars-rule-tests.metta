!(register-module! ../../../PLN)
!(import! &self PLN:pln-nars)
!(import! &self PLN:rules:nars-rule)

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