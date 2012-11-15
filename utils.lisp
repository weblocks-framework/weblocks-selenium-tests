(in-package :weblocks-selenium-tests)

(defmacro with-new-or-existing-selenium-session (&body body)
  `(progn  
     (if *in-selenium-session* 
       (progn 
         ,@body) 
       (with-selenium-session 
         (*selenium-session* *selenium-browser* *site-url*)
         (do-open-and-wait *site-url*)
         (let ((*in-selenium-session* t))
           (do-set-timeout 1000)
           ,@body) 
         (do-test-complete)))))

(defun browser-is-firefox-p ()
  (string= *selenium-browser* *selenium-firefox-browser*))

(defmacro require-firefox (&body body)
  `(if (browser-is-firefox-p)
     (progn ,@body)
     (warn "Skipping test, browser is not firefox")))
