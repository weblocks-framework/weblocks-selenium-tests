(in-package :weblocks-selenium-tests)

(setf drakma:*drakma-default-external-format* :utf-8)

(defparameter *selenium-firefox-browser*  "*chrome /usr/local/bin/firefox")
(defparameter *selenium-google-chrome-browser*  "*googlechrome /usr/bin/google-chrome")
(defparameter *selenium-browser* *selenium-firefox-browser*)
(defparameter *in-selenium-session* nil)

(defparameter *site-root-url* "http://localhost:5555/"
  ;"http://me:5555/"
  )
(defparameter *jquery-site-url* "http://localhost:5555/jquery")
(defparameter *site-url*  *site-root-url*)

(selenium::define-iedoc 
  #.(merge-pathnames "misc/iedoc.xml" *compile-file-pathname*))
