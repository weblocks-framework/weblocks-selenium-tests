
(in-package :weblocks-selenium-tests-app)
(defvar *demo-actions* nil)

(defun get-upload-directory ()
  (merge-pathnames 
    (make-pathname :directory '(:relative "upload"))
    (compute-webapp-public-files-path (weblocks:get-webapp 'weblocks-selenium-tests-app))))

(defun file-field-demonstration-action (&rest args)
  (do-page 
    (make-quickform 
      (defview 
        nil 
        (:caption "File form field demo" :type form :persistp nil :enctype "multipart/form-data" :use-ajax-p nil)
        (file 
          :present-as file-upload 
          :parse-as (file-upload 
                      :upload-directory (get-upload-directory)
                      :file-name :unique))))))

(defun dialog-demonstration-action (&rest args)
  (let* ((widget))
    (setf widget (make-instance 'composite 
                                :widgets 
                                (list 
                                  "Some dialog content"
                                  (lambda (&rest args)
                                    (render-link (lambda (&rest args)
                                                   (answer widget t))
                                                 "Close dialog")))))
    (do-dialog "Dialog title" widget)))

(defun define-demo-action (link-name action &key (prototype-engine-p t) (jquery-engine-p t))
  "Used to add action to demo list, 
   :prototype-engine-p and :jquery-engine-p keys 
   are responsive for displaying action in one or both demo applications"
  (push (list link-name action prototype-engine-p jquery-engine-p) *demo-actions*))

(define-demo-action "File field form presentation" #'file-field-demonstration-action :jquery-engine-p nil)
(define-demo-action "Dialog sample" #'dialog-demonstration-action :jquery-engine-p nil)

;; Define callback function to initialize new sessions
(defun init-user-session-prototype (root)
  (setf (widget-children root)
        (list (lambda (&rest args)
                (with-html
                  (:ul
                    (loop for (link-title action display-for-prototype display-for-jquery) in (reverse *demo-actions*)
                          if display-for-prototype
                          do
                          (cl-who:htm (:li (render-link action link-title))))))))))

(defun init-user-session-jquery (root)
  (setf (widget-children root)
        (list (lambda (&rest args)
                (with-html
                  (:ul
                    (loop for (link-title action display-for-prototype display-for-jquery) in (reverse *demo-actions*) 
                          if display-for-jquery
                          do
                          (cl-who:htm (:li (render-link action link-title))))))))))

