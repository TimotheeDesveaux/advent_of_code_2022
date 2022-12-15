#!/usr/bin/env -S sbcl --script

(defun dist (p1 p2)
  (+
    (abs (- (getf p1 :x) (getf p2 :x)))
    (abs (- (getf p1 :y) (getf p2 :y)))))

(defun make-sensor (sensor-x sensor-y beacon-x beacon-y)
  (list :x sensor-x :y sensor-y :radius (dist
                                          (list :x sensor-x :y sensor-y)
                                          (list :x beacon-x :y beacon-y))))

(defun part-one (file)
  (let ((row 2000000)
        (beacon-on-row nil)
        (sensors nil))
    (with-open-file (input file) :direction :input :if-does-not-exists nil
      (when input
        (loop for line = (read-line input nil)
          while line
          do (with-input-from-string (numbers (remove-if-not
                                                #'(lambda (c)
                                                    (or (digit-char-p c)
                                                        (equal c #\SPACE)
                                                        (equal c #\-)))
                                                line))
               (let ((sensor-x (read numbers))
                     (sensor-y (read numbers))
                     (beacon-x (read numbers))
                     (beacon-y (read numbers)))
                 (if (= beacon-y row)
                   (pushnew beacon-x beacon-on-row))
                 (push
                   (make-sensor sensor-x sensor-y beacon-x beacon-y)
                   sensors))))))
    (let ((range-min nil)
          (range-max nil))
      (loop for sensor in sensors
        do (let ((width (- (getf sensor :radius)
                           (abs (- row (getf sensor :y))))))
             (if (or
                   (not range-min)
                   (<
                     (- (getf sensor :x) width)
                     range-min))
               (setq range-min (- (getf sensor :x) width)))
             (if (or
                   (not range-max)
                   (>
                     (+ (getf sensor :x) width)
                     range-max))
               (setq range-max (+ (getf sensor :x) width)))))
      (-
        (1+ (abs (- range-max range-min)))
        (length beacon-on-row)))))

(defun in_bound (bound point)
  (and
    (and (< 0 (getf point :x))
         (< (getf point :x) bound))
    (and (< 0 (getf point :y))
         (< (getf point :y) bound))))

(defun part-two (file)
  (let ((bound 4000000)
        (sensors nil))
    (with-open-file (input file) :direction :input :if-does-not-exists nil
      (when input
        (loop for line = (read-line input nil)
          while line
          do (with-input-from-string (numbers (remove-if-not
                                                #'(lambda (c)
                                                    (or (digit-char-p c)
                                                        (equal c #\SPACE)
                                                        (equal c #\-)))
                                                line))
               (let ((sensor-x (read numbers))
                     (sensor-y (read numbers))
                     (beacon-x (read numbers))
                     (beacon-y (read numbers)))
                 (push
                   (make-sensor sensor-x sensor-y beacon-x beacon-y)
                   sensors))))))
    (let ((up_coeffs nil)
          (down_coeffs nil))
      (loop for sensor in sensors
        do (push (1+ (+
                        (- (getf sensor :y)
                           (getf sensor :x))
                        (getf sensor :radius)))
                 up_coeffs)
            (push (1- (-
                        (- (getf sensor :y)
                           (getf sensor :x))
                        (getf sensor :radius)))
                   up_coeffs)
            (push (1+ (+
                        (+ (getf sensor :y)
                           (getf sensor :x))
                        (getf sensor :radius)))
                   down_coeffs)
            (push (1- (-
                        (+ (getf sensor :y)
                           (getf sensor :x))
                        (getf sensor :radius)))
                   down_coeffs))
      (loop for up_coeff in up_coeffs
        do (loop for down_coeff in down_coeffs
             do (let ((point (list
                               :x (floor (- down_coeff up_coeff)
                                         2)
                               :y (floor (+ down_coeff up_coeff)
                                         2))))
                  (if (in_bound bound point)
                    (if (every #'(lambda (s)
                                   (> (dist point s)
                                      (getf s :radius)))
                              sensors)
                      (return-from part-two
                                   (+ (* (getf point :x) 4000000)
                                      (getf point :y)))))))))))

(let ((file "input.txt"))
  (format t "part one: ~a~%" (part-one file))
  (format t "part two: ~a~%" (part-two file)))
