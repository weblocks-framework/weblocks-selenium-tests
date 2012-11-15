;;;; weblocks-selenium-tests.lisp

(in-package #:weblocks-selenium-tests)

;;; "weblocks-selenium-tests" goes here. Hacks and glory await!

(in-root-suite)

(defsuite* all-tests)

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
