
(defpackage #:weblocks-selenium-tests-app
  (:use :cl :weblocks
        :f-underscore :anaphora)
  (:import-from :hunchentoot #:header-in
		#:set-cookie #:set-cookie* #:cookie-in
		#:user-agent #:referer)
  (:export :define-demo-action)
  (:documentation
   "A web app based on Weblocks with weblocks components demonstrations."))

(in-package :weblocks-selenium-tests-app)

(export '(start-weblocks-selenium-tests-app stop-weblocks-selenium-tests-app))

;; A macro that generates a class or this webapp

(defwebapp weblocks-selenium-tests-app
    :prefix "/"
    :description "Weblocks with prototype demo"
    :init-user-session 'weblocks-selenium-tests-app::init-user-session-prototype
    :autostart nil                   ;; have to start the app manually
    :ignore-default-dependencies nil ;; accept the defaults
    :debug t)

(defwebapp weblocks-with-jquery-selenium-tests-app
           :prefix "/jquery"
           :description "Weblocks with jquery demo"
           :init-user-session 'weblocks-selenium-tests-app::init-user-session-jquery
           :autostart nil                   ;; have to start the app manually
           :ignore-default-dependencies t ;; accept the defaults
           :debug t
           :dependencies (list 
                           (make-instance 'script-dependency :url "/pub/scripts/jquery-1.8.2.js")
                           (make-instance 'stylesheet-dependency :url "/pub/stylesheets/main.css")
                           (make-instance 'stylesheet-dependency :url "/pub/stylesheets/layout.css")
                           (make-instance 'script-dependency :url "/pub/scripts/weblocks-jquery.js")
                           (make-instance 'script-dependency :url "/pub/scripts/dialog-jquery.js")
                           (make-instance 'script-dependency :url "/pub/scripts/jquery-seq.js")))

;; Top level start & stop scripts

(defun start-weblocks-selenium-tests-app (&rest args)
  "Starts the application by calling 'start-weblocks' with appropriate
arguments."
  (apply #'start-weblocks args)
  (start-webapp 'weblocks-selenium-tests-app)
  (start-webapp 'weblocks-with-jquery-selenium-tests-app))

(defun stop-weblocks-selenium-tests-app ()
  "Stops the application by calling 'stop-weblocks'."
  (stop-webapp 'weblocks-selenium-tests-app)
  (stop-weblocks))

