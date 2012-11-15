(in-package :weblocks-selenium-tests)

(setf drakma:*drakma-default-external-format* :utf-8)

(defparameter *selenium-firefox-browser*  "*chrome /usr/local/bin/firefox")
(defparameter *selenium-google-chrome-browser*  "*googlechrome /usr/bin/google-chrome")
(defparameter *selenium-browser* *selenium-firefox-browser*)
(defparameter *in-selenium-session* nil)
(defparameter *site-url*  
  "http://localhost:5555/"
  ;"http://me:5555/"
  )

(selenium::define-iedoc 
  #.(merge-pathnames "misc/iedoc.xml" *compile-file-pathname*))
