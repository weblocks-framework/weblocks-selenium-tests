
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
                                  (make-widget "Some dialog content")
                                  (lambda (&rest args)
                                    (render-link (lambda (&rest args)
                                                   (answer widget t))
                                                 "Close dialog")))))
    (do-dialog "Dialog title" widget)))

(defstore *tests-store* :memory)

(defclass test-model ()
  ((id) 
   (title :accessor test-model-title :initarg :title) 
   (content :accessor test-model-content :initarg :content)))

(defun gridedit-demonstration-action (&rest args)
  (let* ((widget)
         (composite))
    (setf widget (make-instance 'gridedit :data-class 'test-model))
    (setf composite (make-instance 'composite 
                                   :widgets (list 
                                              (lambda (&rest args)
                                                (with-html 
                                                  (:h1 "Gridedit")))
                                              widget 
                                              (lambda (&rest args)
                                                (render-link 
                                                  (lambda (&rest args)
                                                    (answer composite t))
                                                  "Back")))))
    (do-page composite)))

(defun navigation-demonstration-action (&rest args)
  (let ((widget)
        (navigation))
    (setf navigation (make-navigation 
                       "toplevel-nav"
                       (list "First pane" (make-widget "First pane value") nil)
                       (list "Second pane" (make-widget "Second pane value") "second-pane")
                       (list "Third pane (first nested pane)" 
                             (make-navigation 
                               "second-level-nav-1"
                               (list "First nested pane" (make-widget "First nested pane") nil)
                               (list "Second nested pane" (make-widget "Second nested pane") "second-nested-pane")
                               (list "Third nested pane (with 2-level nesting)" 
                                     (make-navigation 
                                       "third-level-nav" 
                                       (list "First nested pane" (make-widget "First nested pane") nil)
                                       (list "Second nested pane" (make-widget "Second nested pane") "second-nested-pane"))
                                     "third-nested-pane")) "third-pane")
                       (list "Fourth pane (second nested pane)" 
                             (make-navigation 
                               "second-level-nav-2"
                               (list "First nested pane" (make-widget "First nested pane"))
                               (list "Second nested pane" (make-widget "Second nested pane") "second-nested-pane")) "fourth-pane")
                       (list "Fifth pane" (make-widget "Fifth pane") "fifth-pane")
                       (list "Sixth pane (third nested pane)" 
                             (make-navigation 
                               "second-level-nav-3"
                               (list "First nested pane" (make-widget "First nested pane"))
                               (list "Second nested pane" (make-widget "Second nested pane") "second-nested-pane")) "sixth-pane")))
    (setf widget 
          (make-instance 'composite 
                         :widgets (list 
                                    navigation
                                    (lambda (&rest args)
                                      (with-html 
                                        (:div :style "clear:both"
                                          (render-link (lambda (&rest args)
                                                     (answer widget t)) "back")))))))
    (do-page widget)))

(defun define-demo-action (link-name action &key (prototype-engine-p t) (jquery-engine-p t))
  "Used to add action to demo list, 
   :prototype-engine-p and :jquery-engine-p keys 
   are responsive for displaying action in one or both demo applications"
  (setf *demo-actions* 
        (remove-if 
          (lambda (item)
            (or 
              (string= (first item) link-name)
              (equal (second item) action)))
          *demo-actions*))

  (setf *demo-actions* 
        (remove (find action *demo-actions*) *demo-actions*))
  (push (list link-name action prototype-engine-p jquery-engine-p) *demo-actions*))

(defun float-input-field-demonstration-action (&rest args)
  (do-page 
    (make-quickform 
      (defview 
        nil 
        (:caption "Input with float value parser demo" :type form :persistp nil :enctype "multipart/form-data" :use-ajax-p nil)
        (file 
          :present-as input 
          :parse-as (float))))))



(defun nl2br (text)
  (cl-ppcre:regex-replace-all #\newline text "<br/>"))

(defun/cc quickform-demonstration-action (&rest args)
  (let ((widget ))
    (setf widget 
          (make-quickform 
            (defview 
              nil 
              (:caption "A Quickform" :type form :persistp nil)
              (some-text  
                :present-as input))
            :answerp nil
            :on-success (lambda (form data)
                          (let ((display-results-widget))
                            (setf  display-results-widget 
                                   (make-widget 
                                     (lambda/cc (&rest args)
                                       (with-html 
                                         (:h1 "And quickform returned following data for us (output via "
                                          (:a :href "http://www.lispworks.com/documentation/HyperSpec/Body/f_descri.htm"
                                           :target "_blank"
                                           "describe")
                                          ")")
                                         (:pre
                                           (str 
                                             (ppcre:regex-replace-all 
                                               #\Space
                                               (nl2br 
                                                 (with-output-to-string (s)
                                                   (describe data s)))
                                               "&nbsp;")))
                                         (render-link 
                                           (lambda/cc (&rest args)
                                             (answer display-results-widget nil))
                                           "Enter another value")
                                         "&nbsp;"
                                         (render-link 
                                           (lambda/cc (&rest args)
                                             (answer widget nil))
                                           "Back to list of examples")))))
                            (do-page display-results-widget)))
            :on-cancel (lambda (&rest args)
                         (answer widget))))
    (do-page widget)))

(defun/cc a-long-page-action (&rest args)
          (let ((widget ))
            (setf widget 
                  (make-widget (lambda (&rest args)
                                 (let ((text  "This should be a long page for testing Weblocks behaviour on getting back to short page. It should scroll top."))
                                   (with-html 
                                     (loop for i across text do 
                                           (cl-who:htm 
                                             (str i)
                                             (:br)))
                                     (:br)
                                     (render-link (lambda (&rest args)
                                                    (answer widget)) "back"))))))
            (do-page widget)))

(defun/cc flash-tests-action (&rest args)
  (let ((flash (make-instance 'flash))
        (composite))
    (do-page 
      (setf composite 
            (make-instance 
              'composite 
              :widgets 
              (list 
                (lambda (&rest args)
                  (mark-dirty flash))
                flash 
                (make-widget 
                  (let ((lambda2))
                    (setf lambda2 (lambda (&rest args)
                                    (with-html 
                                      (:h1 "A flash widget")
                                      (:ul 
                                        (:li (:a :href "javascript:;"
                                              :onclick (ps:ps-inline 
                                                         (initiate-action 
                                                           (ps:LISP 
                                                             (make-action 
                                                               (lambda (&rest args)
                                                                 (flash-message flash "Test message"))))
                                                           (ps:LISP (session-name-string-pair))))
                                              "Show test flash message through ajax, after no redirect"))
                                        (:li (:a :href 
                                              (make-action-url 
                                                (make-action 
                                                  (lambda (&rest args)
                                                    (flash-message flash "Test message"))))
                                              "Show test flash message after no redirect"))
                                        (:li (:a :href 
                                              (make-action-url 
                                                (make-action 
                                                  (lambda (&rest args)
                                                    (flash-message flash "Test message")
                                                    (redirect "/?test=true" :defer nil))))
                                              "Show test flash message after single redirect"))
                                        (:li (:a :href "javascript:;"
                                              :onclick (ps:ps-inline 
                                                         (initiate-action 
                                                           (ps:LISP 
                                                             (make-action 
                                                               (lambda (&rest args)
                                                                 (flash-message flash "Test message")
                                                                 (redirect "/?test=true" :defer nil))))
                                                           (ps:LISP (session-name-string-pair))))
                                              "Show test flash message through ajax, after single redirect"))
                                        (:li 
                                          (:a :href (let ((url))
                                                      (setf url (make-action-url 
                                                                  (make-action 
                                                                    (lambda (&rest args)
                                                                      (cond 
                                                                        ((weblocks-util:request-parameter "test2") 
                                                                         (redirect (format nil "/?test3=true" url) :defer nil))
                                                                        (t 
                                                                         (flash-message flash "Test message")
                                                                         (redirect (format nil "~A&test2=true" url) :defer nil))))))))
                                           "Show test flash message after double redirect"))
                                        (:li 
                                          (:a :href "javascript:;"
                                           :onclick (ps:ps-inline 
                                                      (initiate-action 
                                                        (ps:LISP 
                                                          (let ((action)
                                                                (url))
                                                            (setf action (make-action 
                                                                           (lambda (&rest args)
                                                                             (cond 
                                                                               ((weblocks-util:request-parameter "test2") 
                                                                                (redirect (format nil "/?test3=true" url) :defer nil))
                                                                               (t 
                                                                                (flash-message flash "Test message")
                                                                                (redirect (format nil "~A&test2=true" url) :defer nil))))))
                                                            (setf url (make-action-url action))
                                                            action))
                                                        (ps:LISP (session-name-string-pair))))
                                           "Show test flash message through ajax after double redirect")))
                                      (render-link 
                                        (lambda (&rest args)
                                          (answer composite t))
                                        "Back"))))))))))))

(define-demo-action "File field form presentation" #'file-field-demonstration-action :jquery-engine-p nil)
(define-demo-action "Dialog sample" #'dialog-demonstration-action :jquery-engine-p nil)
(define-demo-action "Navigation sample" #'navigation-demonstration-action)
(define-demo-action "Input sample with float parser" #'float-input-field-demonstration-action)
(define-demo-action "Gridedit" #'gridedit-demonstration-action)
(define-demo-action "Quickform" #'quickform-demonstration-action)
(define-demo-action "A long page for test" #'a-long-page-action)
(define-demo-action "Flash demo" #'flash-tests-action)

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
  (weblocks-utils:require-assets 
    "https://raw.github.com/html/weblocks-assets/master/weblocks-jquery/0.1.4/")
  (weblocks-utils:require-assets 
    "https://raw.github.com/html/weblocks-assets/master/jquery-seq/0.0.3/") 
  (weblocks-utils:require-assets 
    "https://raw.github.com/html/weblocks-assets/master/jquery/1.8.2/")

  (setf (widget-children root)
        (list (lambda (&rest args)
                (with-html
                  (:ul
                    (loop for (link-title action display-for-prototype display-for-jquery) in (reverse *demo-actions*) 
                          if display-for-jquery
                          do
                          (cl-who:htm (:li (render-link action link-title))))))))))

(defun render-apps-list ()
  (let* ((uri-path (request-uri-path))
         (urls (mapcar #'weblocks::weblocks-webapp-prefix weblocks::*active-webapps*))
         (apps (copy-list weblocks::*active-webapps*)))
    (when (find uri-path urls :test #'string=)
      (flet ((current-webapp-p (i)
               (string= 
                 (string-right-trim "/" (weblocks::weblocks-webapp-prefix i)) 
                 (string-right-trim "/" uri-path))))
        (with-html 
        (:div :style "position:fixed;top:20px;right:20px;background:white;border:3px solid #001D23;text-align:left;"
         (:ul :style "padding:10px 30px;margin:0;"
           (loop for i in (sort apps #'string> :key #'weblocks::weblocks-webapp-description) do 
                 (cl-who:htm 
                   (:li (:a :style (format nil "font-size: 15px;text-decoration:none;~A" (if (current-webapp-p i) "font-weight:bold;" "")) :href (weblocks::weblocks-webapp-prefix i) 
                         (str (weblocks::weblocks-webapp-description i)))))))))))))

(defmethod render-page-body :after ((app weblocks-selenium-tests-app) body-string)
  (render-apps-list))

(defmethod render-page-body :after ((app weblocks-with-jquery-selenium-tests-app) body-string)
  (render-apps-list))

