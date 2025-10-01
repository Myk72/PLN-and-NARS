;;; Parameter description:

; f - frequency
; c - confidence
; s - strength
; p - power (Expectation)
; k - expectation parameter
; n - number of evidential observations
; A, B, C - statements

; Confidence formula:
; c = n / (n + k)
(= (confidence $n $k)
   (/ $n (+ $n $k)))
   
;;; Non-Axiomatic Reasoning System (NARS)

;; Deduction implementation in NARS
; Rule:
; A -> B with (f1, c1)
; B -> C with (f2, c2)
; then A -> C with (f, c)

; Conclusion Truth Value:
; f = (f1 * f2) / (f1 + f2 - f1 * f2)
; c = c1 * c2 (f1 + f2 - f1 * f2)
; p = f * c = (f1 * f2 * c1 * c2)

(= (nars_freqD $f1 $f2)
   (/ (* $f1 $f2) (+ $f1 (* $f2 (- 1 $f1)))))


(= (nars_confD $f1 $f2 $c1 $c2)
   ( * (* $c1 $c2) (+ $f1 (* $f2 (- 1 $f1)))))
   
(= (nars_powerD $f1 $f2 $c1 $c2)
   (* (nars_freqD $f1 $f2)
      (nars_confD $f1 $f2 $c1 $c2)))


;; Induction implementation in NARS
; Rule:
; B -> A with (f1, c1)
; B with (f2, c2)
; then A with (f, c)

; Conclusion Truth Value:
; f = f1
; c = (f2 * c1 * c2) / (f2 * c1 * c2 + k)
; p = f * c = (f1 * f2 * c1 * c2) / (f2 * c1 * c2 + k)

; (= (nars-induction-freq f1 f2) f1)
(= (nars_freqI $f1 $f2) $f1)

(= (nars_confI $f1 $f2 $c1 $c2 $k)
   (/ 1 (+ 1 (/ $k (* $f2 (* $c1 $c2))))))
   
(= (nars_powerI $f1 $f2 $c1 $c2 $k)
   (* (nars_freqI $f1 $f2)
      (nars_confI $f1 $f2 $c1 $c2 $k)))



;; Abduction implementation in NARS
; Rule:
; A -> B with (f1, c1)
; B with (f2, c2)
; then A with (f, c)

; Conclusion Truth Value:
; f = f2
; c = (f1 * c1 * c2) / (f1 * c1 * c2 + k)
; p = f * c = (f1 * f2 * c1 * c2) / (f1 * c1 * c2 + k)

; (= (nars-abduction-freq f1 f2) f2)
(= (nars_freqA $f1 $f2) $f2)

(= (nars_confA $f1 $f2 $c1 $c2 $k)
   (/ 1 (+ 1 (/ $k (* $f1 (* $c1 $c2))))))

(= (nars_powerA $f1 $f2 $c1 $c2 $k)
   (* (nars_freqA $f1 $f2)
      (nars_confA $f1 $f2 $c1 $c2 $k)))


;;; Probabilistic Logic Networks (PLN)


;; Deduction implementation in PLN
; Rule:
; A -> B with (s_AB, c_AB)
; B -> C with (s_BC, c_BC)
; then A -> C with (s_AC, c_AC)

; Conclusion Truth Value:
; Independence based formula:
; s_AC = s_AB * s_BC + ((1 - s_AB) * (s_C - s_B * s_BC)) / (1 - s_B)

; Concept geometry formula:
; s_AC = s_AB * s_BC / min(1, s_AB + s_BC)


(= (pln_str_indD $s_AB $s_BC $s_B $s_C)
   (+ (* $s_AB $s_BC)
      (/ (* (- 1 $s_AB) (- $s_C (* $s_B $s_BC)))
         (- 1 $s_B))))
         
(= (pln_str_geoD $s_AB $s_BC)
   (let* (($prod (* $s_AB $s_BC))
          ($sum  (+ $s_AB $s_BC)))
      (/ $prod (if (< $sum 1) $sum 1))))


;; Induction implementation in PLN
; Rule:
; B -> A with (s_BA, c_BA)
; B -> C with (s_BC, c_BC)
; then A -> C with (s_AC, c_AC)

; Reversed rule:
; A -> B with (s_AB, c_AB)
; s_AB = s_BA * s_B / s_A

; Substitution to the deduction formula:
; s_AC = (s_BA * s_B / s_A) * s_BC 
;        + ((s_A - (s_BA * s_B)) * (s_C - s_B * s_BC)) / (s_A * (1 - s_B))


(= (pln_strI_AB $s_BA $s_B $s_A)
   (/ (* $s_BA $s_B) $s_A))


(= (pln_strI $s_BA $s_BC $s_B $s_A $s_C)
   (let* (($s_AB (pln_strI_AB $s_BA $s_B $s_A))
          ($part1 (* $s_AB $s_BC))
          ($part2 (/ (* (- 1 $s_AB) 
                       (- $s_C (* $s_B $s_BC)))
                    (- 1 $s_B))))
      (+ $part1 $part2)))

;; Abduction implementation in PLN
; Rule:
; A -> B with (s_AB, c_AB)
; C -> B with (s_CB, c_CB)
; then A -> C with (s_AC, c_AC)

; Reversed rule:
; B -> C with (s_BC, c_BC)
; s_BC = s_CB * s_C / s_B

; Substitution to the deduction formula:
; s_AC = s_AB * (s_CB * s_C / s_B) 
;        + ((1 - s_AB) * (s_C - (s_CB * s_C))) / (1 - s_B)


(= (pln_strA_BC $s_CB $s_C $s_B)
   (/ (* $s_CB $s_C) $s_B))
   

(= (pln_strA $s_AB $s_CB $s_C $s_B)
   (let* (($s_BC (pln_strA_BC $s_CB $s_C $s_B))
          ($part1 (* $s_AB $s_BC))
          ($part2 (/ (* (- 1 $s_AB) 
                       (- $s_C (* $s_CB $s_C)))
                    (- 1 $s_B))))
      (+ $part1 $part2)))