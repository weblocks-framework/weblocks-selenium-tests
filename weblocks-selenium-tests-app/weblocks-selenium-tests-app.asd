;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(defpackage #:weblocks-selenium-tests-app-asd
  (:use :cl :asdf))

(in-package :weblocks-selenium-tests-app-asd)

(defsystem weblocks-selenium-tests-app
    :name "weblocks-selenium-tests-app"
    :version (:read-file-from "version.lisp-expr")
    :maintainer "Olexiy Zamkoviy"
    :author "Olexiy Zamkoviy"
    :licence "LLGPL"
    :description "App which demonstrates weblocks components and is used for weblocks selenium tests"
    :depends-on (:weblocks)
    :components ((:file "weblocks-selenium-tests-app")
		 (:module conf
		  :components ((:file "stores"))
		  :depends-on ("weblocks-selenium-tests-app"))
		 (:module src
		  :components ((:file "init-session"))
		  :depends-on ("weblocks-selenium-tests-app" conf))))

