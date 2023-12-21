; Written by Isaac Gemal and GPT-4 12/2023... But mostly GPT-4
; Simple work in progress tool to help me grade site plans
; Has some bugs but it's good enough for now
(defun c:MarkIntegerElevations  (/ pt1 pt2 elev1 elev2 startElev endElev currentElev dist ptAlongLine)
  ; Prompt for input
  (setq pt1 (getpoint "\nSelect first point: "))
  (setq elev1 (getreal "\nEnter elevation for first point: "))
  (setq pt2 (getpoint "\nSelect second point: "))
  (setq elev2 (getreal "\nEnter elevation for second point: "))

  ; Draw a line between the points
  (entmake (list (cons 0 "LINE") (cons 10 pt1) (cons 11 pt2)))

  ; Calculate distance and elevation range
  (setq dist (distance pt1 pt2))
  (setq startElev (fix (min elev1 elev2))) ; Equivalent to floor for positive numbers
  (setq endElev (1+ (fix (max elev1 elev2)))) ; Equivalent to ceiling for positive numbers

  ; Adjust for negative numbers
  (if (< elev1 0) (setq startElev (1- startElev)))
  (if (< elev2 0) (setq endElev (1- endElev)))

  ; Calculate contour locations and draw circles
  (setq currentElev startElev)
  (while (< currentElev endElev)
    (setq ptAlongLine 
      (polar pt1 
             (angle pt1 pt2) 
             (* dist (/ (- currentElev elev1) (- elev2 elev1)))
      )
    )
    (entmake (list (cons 0 "CIRCLE") (cons 10 ptAlongLine) (cons 40 0.5))) ; Draw circle with radius 0.5
    (setq currentElev (1+ currentElev))
  )

  ; Termination
  (princ)
)
