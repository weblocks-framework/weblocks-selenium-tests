
(in-package :weblocks-selenium-tests-app)

;;; Multiple stores may be defined. The last defined store will be the
;;; default.
(defstore *weblocks-selenium-tests-app-store* :prevalence
  (merge-pathnames (make-pathname :directory '(:relative "data"))
		   (asdf-system-directory :weblocks-selenium-tests-app)))

