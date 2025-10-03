!(import! &self pln-nars)
;; Test cases
!(assertEqual (confidence 1.0 1.0) 0.5)

; NARS Deduction
!(assertEqual (nars_freqD 0.8 0.6) 0.5217391304347826)
!(assertEqual (nars_confD 0.8 0.6 0.9 0.7) 0.5796)
!(assertEqual (nars_powerD 0.8 0.6 0.9 0.7) 0.3024)

; ; NARS Induction
!(assertEqual (nars_freqI 0.8 0.6) 0.8)
!(assertEqual (nars_confI 0.8 0.6 0.9 0.7) 0.4305239179954442)
!(assertEqual (nars_powerI 0.8 0.6 0.9 0.7) 0.3444191343963554)

; ; NARS Abduction
!(assertEqual (nars_freqA 0.8 0.6) 0.6)
!(assertEqual (nars_confA 0.8 0.6 0.9 0.7) 0.50199203187251)
!(assertEqual (nars_powerA 0.8 0.6 0.9 0.7) 0.30119521912350594)

; ; PLN Deduction
!(assertEqual (pln_str_indD 0.8 0.6 0.5 0.7) 0.6399999999999999)
!(assertEqual (pln_str_geoD 0.8 0.6) 0.48)

; ; PLN Induction
!(assertEqual (pln_strI_AB 0.8 0.5 0.7) 0.5714285714285715)
!(assertEqual (pln_strI 0.8 0.6 0.5 0.7 0.9) 0.8571428571428572)

; ; PLN Abduction
!(assertEqual (pln_strA_BC 0.6 0.7 0.5) 0.84)
!(assertEqual (pln_strA 0.8 0.6 0.7 0.5) 0.784)

; ; PLN Confidence
!(assertEqual (pln_conf 0.5 0.7) 0.35)
!(assertEqual (pln_conf 0.9 0.7) 0.63)