(in-package :ter)

(defun config (&rest keys)
  (let ((app-code :ter)
        (env-code :development)
        (graph *graph*))
    (seph::environment-at graph
                        :code env-code
                        :application (seph::application-at graph :code app-code :ensure t)
                        :ensure t)
    (seph:fruit* graph app-code env-code keys)))

(defun (setf config) (value &rest keys)
  (let ((app-code :ter)
        (env-code :development)
        (graph *graph*))
    (seph::environment-at graph
                          :code env-code
                          :application (seph::application-at graph :code app-code :ensure t)
                          :ensure t)
    (setf (seph:fruit* graph app-code env-code keys) value)))
