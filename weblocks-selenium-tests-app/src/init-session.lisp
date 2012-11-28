
(in-package :weblocks-selenium-tests-app)

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

;; Define callback function to initialize new sessions
(defun init-user-session (root)
  (setf (widget-children root)
        (list (lambda (&rest args)
                (with-html
                  (:ul
                    (:li (render-link #'file-field-demonstration-action "File field form presentation")) 
                    (:li (render-link #'dialog-demonstration-action "Dialog sample"))))))))

