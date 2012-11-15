;;;; weblocks-selenium-tests.asd

(asdf:defsystem #:weblocks-selenium-tests
  :serial t
  :description "Describe weblocks-selenium-tests here"
  :author "Olexiy Zamkoviy <olexiy.z@gmail.com>"
  :license "LLGPL"
  :depends-on (#:stefil
               #:selenium)
  :components ((:file "package")
               (:file "weblocks-selenium-tests")))

