; Matches the rotation of MTEXT, TEXT, and MULTILEADER objects, 
; It's very niche but I like it
; Written by Isaac Gemal & ChatGPT 8/24/2023

; Function to get the rotation of the object
(defun get-object-rotation (obj type)
  ; If main object is TEXT or MTEXT, use the DXF code 50 to get the rotation
  ; Otherwise, use the ActiveX property for MULTILEADER
  ; https://www.afralisp.net/reference/dxf-group-codes.php
  ; https://help.autodesk.com/view/ACD/2016/ENU/?guid=GUID-EB9C76B1-4CCD-4080-BB04-30A496DA4E09
  (if (or (= type "TEXT") (= type "MTEXT"))
    (cdr (assoc 50 (entget obj)))
    (vla-get-TextRotation (vlax-ename->vla-object obj))
  )
)

; Function to set the rotation of the object
(defun set-object-rotation (obj type rotation)
  ; If destination object is TEXT or MTEXT, use entmod to change the rotation
  ; Otherwise, use the ActiveX property for MULTILEADER
  (if (or (= type "TEXT") (= type "MTEXT"))
    (entmod (subst (cons 50 rotation) (assoc 50 (entget obj)) (entget obj)))
    (vla-put-TextRotation (vlax-ename->vla-object obj) rotation)
  )
)

; Function to prompt the user to select an object and validate its type
(defun get-object (prompt)
  (setq obj (car (entsel prompt)))
  (if obj
    (progn
      (setq type (cdr (assoc 0 (entget obj))))
      (if (member type '("TEXT" "MTEXT" "MULTILEADER"))
        obj
        (progn (princ (strcat "\nError: Selected object is not " prompt)) nil)
      )
    )
    (progn (princ "\nError: No object selected.") nil)
  )
)

; Main function
; ROMA stands for rotate match
(defun c:ROMA4 ()
  (setq mainObj (get-object "\nSelect main TEXT, MTEXT, or MULTILEADER object: "))
  (if mainObj
    (progn
      (setq mainType (cdr (assoc 0 (entget mainObj))))
      (setq mainRotation (get-object-rotation mainObj mainType))
      (setq destObj (get-object "\nSelect destination TEXT, MTEXT, or MULTILEADER object: "))
      (if destObj
        (progn
          (setq destType (cdr (assoc 0 (entget destObj))))
          (set-object-rotation destObj destType mainRotation)
          (princ "\nRotation matched successfully.")
        )
      )
    )
  )
  (princ)
)
