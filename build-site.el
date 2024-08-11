(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
;; (unless (package-installed-p 'htmlize)
;; 	(package-install 'htmlize))

(require 'ox-publish)
(require 'simple-httpd)
;; Define the publishing project
(setq org-publish-project-alist
      (list
       (list "org-site:static"
	     :base-directory "./assets/"
	     :base-extension "css\\|js\\|png\\|jpg\\|gif\\|pdf\\|mp3\\|mp4\\|ogg\\|swf"
	     :publishing-directory "./public/assets"
	     :recursive t
	     :publishing-function 'org-publish-attachment
	     )
       (list "reed-portfolio-site"
	     :html-preamble (concat "<div class='topnav'>
                                      <a href='/portfolio.html'>Home</a> /
                                      <a href='/writing.html'>Blog</a> /
                                      <a href='/about.html'>About Me</a>
                                      </div>")
             :recursive t
             :base-directory "./content"
             :publishing-directory "./public"
             :publishing-function 'org-html-publish-to-html
	     :with-toc t
	     :section-numbers nil
	     :with-creator nil
	     :with-author t
	     :time-stamp-file nil
	     :language nil
	     )))
(setq org-html-validation-link nil
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"https://cdn.simplecss.org/simple.min.css\" />")

;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Generate the site output
;;(setq debug-on-error t)
(org-publish-all t)
(message "Build complete!")
