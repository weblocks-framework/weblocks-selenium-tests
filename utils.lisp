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

(defun ensure-jquery-loaded-into-document ()
  (do-get-eval 
    (remove #\Newline (format nil "
                              function addJavascript(jsname,pos, callback){
                              var th = window.document.getElementsByTagName(pos)[0];
                              var s = window.document.createElement('script');
                              s.setAttribute('type','text/javascript');
                              s.setAttribute('src',jsname);
                              s.onload = callback; 
                              th.appendChild(s);
                              }

                              addJavascript('~Apub/scripts/jquery-1.8.2.js', 'body', function(){
                                            window.jQuery.noConflict();
                                            }); " *site-root-url*)))
  (sleep 1))
