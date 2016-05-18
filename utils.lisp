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
    ; Here we take jQuery library for jQuery backend test app
    (remove #\Newline (format nil "
                              function addJavascript(jsname,pos, callback){
                              var th = window.document.getElementsByTagName(pos)[0];
                              var s = window.document.createElement('script');
                              s.setAttribute('type','text/javascript');
                              s.setAttribute('src',jsname);
                              s.onload = callback; 
                              th.appendChild(s);
                              }
                              // This is to initiate jQuery app
                              //window.open('~Ajquery').close();

                              addJavascript('~Ajquery/pub/scripts/jquery-1.8.2.js', 'body', function(){
                                            window.jQuery.noConflict();
                                            }); " *site-root-url* *site-root-url*)))
  (sleep 1))

(defun md5-sum (file-name)
  (ironclad:byte-array-to-hex-string 
    (ironclad:digest-file 
      :md5 file-name)))

(defun images-different-p (file-1 file-2)
  (string/= (md5-sum file-1) (md5-sum file-2)))

(defun do-screen-state-test (file-name &key wait-after-resize)
  (unless *do-screen-state-tests* 
    (return-from do-screen-state-test))
  (let* ((parts (reverse (ppcre:split "/" file-name)))
         (temporary-file-name 
           (merge-pathnames 
             (make-pathname 
               :name (car parts) 
               :type "png")
             *screen-state-tests-temp-dir*))
         (path (merge-pathnames 
                 (make-pathname 
                   :name (car parts)
                   :directory (list* :relative (reverse (cdr parts)))
                   :type "png")
                 *screen-state-tests-dir*)))
    (require-firefox 
      (do-get-eval "window.resizeTo(1350, 768);")
      (when wait-after-resize 
        (do-wait-for-page-to-load wait-after-resize))
      (ensure-directories-exist path)
      (ensure-directories-exist temporary-file-name)
      (cond 
        ((not (probe-file path)) (do-capture-entire-page-screenshot (princ-to-string path) ""))
        ((probe-file path)
         (do-capture-entire-page-screenshot (princ-to-string temporary-file-name) "")
         (eval `(is (not (images-different-p ,path ,temporary-file-name)))))))))
