(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
;; (unless (package-installed-p 'htmlize)
;; 	(package-install 'htmlize))

(require 'ox-publish)
;; org-site/build-site.el
(defun my/org-publish-org-sitemap-format (entry style project)
  "Custom sitemap entry formatting: add date"
  (cond ((not (directory-name-p entry))
         (let ((preview (if (my/get-preview (concat "content/" entry))
                            (my/get-preview (concat "content/" entry))
                          "(No preview)")))
           (format "[[file:%s][(%s) %s]]\n%s"
                   entry
                   (format-time-string "%Y-%m-%d"
                                       (org-publish-find-date entry project))
                   (org-publish-find-title entry project)
                   preview)))
        ((eq style 'tree)
         (file-name-nondirectory (directory-file-name entry)))
        (t entry)))
(defun my/org-publish-org-sitemap (title list)
  "Sitemap generation function."
  (concat "#+OPTIONS: toc:nil")
  (org-list-to-subtree list))

(defun my/get-preview (file)
  "get preview text from a file

 Uses the function here as a starting point:
 https://ogbe.net/blog/blogging_with_org.html"
  (with-temp-buffer
    (insert-file-contents file)
    (goto-char (point-min))
    (when (re-search-forward "^#\\+BEGIN_PREVIEW$" nil 1)
      (goto-char (point-min))
      (let ((beg (+ 1 (re-search-forward "^#\\+BEGIN_PREVIEW$" nil 1)))
            (end (progn (re-search-forward "^#\\+END_PREVIEW$" nil 1)
                        (match-beginning 0))))
        (buffer-substring beg end)))))
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
                                      <a href='/index.html'>Home</a> /
                                      <a href='/writing.html'>Case Studies</a> /
                                      <a href='/about.html'>About Me</a>
                                      </div>")
             :recursive t
             :base-directory "./content"
             :publishing-directory "./public"
             :publishing-function 'org-html-publish-to-html
	     :with-toc t
	     :auto-sitemap t
	     :sitemap-title nil
	     :sitemap-format-entry 'my/org-publish-org-sitemap-format
             :sitemap-function 'my/org-publish-org-sitemap
             :sitemap-sort-files 'anti-chronologically
             :sitemap-filename "sitemap.org"
             :sitemap-style 'tree
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
