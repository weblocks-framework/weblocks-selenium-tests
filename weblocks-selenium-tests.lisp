;;;; weblocks-selenium-tests.lisp

(in-package #:weblocks-selenium-tests)

;;; "weblocks-selenium-tests" goes here. Hacks and glory await!

(in-root-suite)

(defsuite* all-tests)

(defmacro def-test-suite (name-or-name-with-args &optional args &body body)
  "Defines test suite inside of all-tests suite"
  `(progn 
     (in-suite all-tests)
     (stefil:defsuite* ,name-or-name-with-args ,args ,@body)))

(deftest uploads-file ()
  (require-firefox
    (let ((old-files-list (cl-fad:list-directory (weblocks-selenium-tests-app::get-upload-directory)))
          (new-files-list))
      (with-new-or-existing-selenium-session
        (do-click-and-wait "link=File field form presentation")
        (do-attach-file "name=file" (format nil "~A/pub/test-data/test-file" (string-right-trim "/" *site-url*)))
        (do-click-and-wait "name=submit")
        (setf new-files-list (cl-fad:list-directory (weblocks-selenium-tests-app::get-upload-directory)))
        (is (= (length new-files-list)
               (1+ (length old-files-list))))
        (mapcar #'delete-file new-files-list)))))

(defun sample-dialog-assertions ()
  (is (string= "Dialog title" (do-get-text "css=h2.title-text")))
  (is (string= "Some dialog content" (do-get-text "css=div.dialog-body p")))
  (is (string= "Close dialog" (do-get-text "css=div.dialog-body a"))))

(deftest shows-dialog ()
  (with-new-or-existing-selenium-session 
    (do-click-and-wait "link=Dialog sample")
    (sample-dialog-assertions)
    (do-click-and-wait "link=Close dialog")))

(deftest shows-dialog-after-page-reloading ()
  (with-new-or-existing-selenium-session 
    (do-click-and-wait "link=Dialog sample")
    (sample-dialog-assertions)
    (do-refresh)
    (do-open-and-wait *site-url*)
    (sample-dialog-assertions)
    (do-click-and-wait "link=Close dialog")))
