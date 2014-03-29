(defpackage :cl-battery
  (:use :cl)
  (:export 
    show-bat
    )
  )

(in-package #:cl-battery)

(defun show-bat ()
(let ((bat_stat (open #P"/sys/class/power_supply/BAT0/status"))
      (bat_now  (open #P"/sys/class/power_supply/BAT0/current_now"))
      (bat_full (open #P"/sys/class/power_supply/BAT0/charge_full"))
      (ac_online (open #P"/sys/class/power_supply/ADP0/online"))
      )
  (format *standard-output* "~A ~$% ~A~%" (read-line bat_stat) (* (float (/ (read bat_now) (read bat_full))) 100) 
          (if (equal (read ac_online) 1)
            "To Be Fully Charged"
            "Left"))
  (close bat_stat)
  (close bat_now)
  (close bat_full)))

(sb-ext:save-lisp-and-die #P"bat" :toplevel #'cl-battery:show-bat :executable t)
