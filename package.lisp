;;;; package.lisp

(defpackage #:weblocks-selenium-tests
  (:use #:cl #:stefil #:selenium)
  (:export 
    :all-tests :deftest :defsuite :in-root-suite :defsuite* :is :in-suite :def-test-suite 
    :do-click-and-wait 
    :*site-url* :*site-root-url* :*jquery-site-url* 
    :*in-selenium-session* :*selenium-browser* 
    :with-new-or-existing-selenium-session 
    :with-new-or-existing-selenium-session-on-jquery-site 
    :require-firefox))

