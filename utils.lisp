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

(defmacro with-new-or-existing-selenium-session-on-jquery-site (&body body)
  `(let ((*site-url* *jquery-site-url*))
     (with-new-or-existing-selenium-session ,@body)))

(defun browser-is-firefox-p ()
  (string= *selenium-browser* *selenium-firefox-browser*))

(defun browser-is-google-chrome-p ()
  (string= *selenium-browser* *selenium-google-chrome-browser*))

(defmacro require-firefox (&body body)
  `(if (browser-is-firefox-p)
     (progn ,@body)
     (warn "Skipping test, browser is not firefox")))

(defmacro require-google-chrome (&body body)
  `(if (browser-is-google-chrome-p)
     (progn ,@body)
     (warn "Skipping test, browser is not google-chrome")))
