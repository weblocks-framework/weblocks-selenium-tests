
(defpackage #:weblocks-selenium-tests-app
  (:use :cl :weblocks
        :f-underscore :anaphora)
  (:import-from :hunchentoot #:header-in
		#:set-cookie #:set-cookie* #:cookie-in
		#:user-agent #:referer)
  (:documentation
   "A web app based on Weblocks with weblocks components demonstrations."))

(in-package :weblocks-selenium-tests-app)

(export '(start-weblocks-selenium-tests-app stop-weblocks-selenium-tests-app))

;; A macro that generates a class or this webapp

(defwebapp weblocks-selenium-tests-app
    :prefix "/"
    :description "weblocks-selenium-tests-app: A new application"
    :init-user-session 'weblocks-selenium-tests-app::init-user-session
    :autostart nil                   ;; have to start the app manually
    :ignore-default-dependencies nil ;; accept the defaults
    :debug t
    )

;; Top level start & stop scripts

(defun start-weblocks-selenium-tests-app (&rest args)
  "Starts the application by calling 'start-weblocks' with appropriate
arguments."
  (apply #'start-weblocks args)
  (start-webapp 'weblocks-selenium-tests-app))

(defun stop-weblocks-selenium-tests-app ()
  "Stops the application by calling 'stop-weblocks'."
  (stop-webapp 'weblocks-selenium-tests-app)
  (stop-weblocks))

