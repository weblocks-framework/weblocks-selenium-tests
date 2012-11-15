;;;; weblocks-selenium-tests.asd

(asdf:defsystem #:weblocks-selenium-tests
 :serial t
 :description "Describe weblocks-selenium-tests here"
 :author "Olexiy Zamkoviy <olexiy.z@gmail.com>"
 :license "LLGPL"
 :depends-on (#:stefil #:selenium #:weblocks-selenium-tests-app)
 :components 
 ((:file "package")
  (:file "parameters" :depends-on ("package"))
  (:file "utils" :depends-on ("parameters"))
  (:file "weblocks-selenium-tests" :depends-on ("parameters" "package" "utils"))))

