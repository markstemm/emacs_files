;(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
;(load-theme 'zenburn t)
(add-to-list 'load-path "/Users/mstemm/downloads/ess-16.04/lisp")
(add-to-list 'load-path "/mnt/sf_mstemm/downloads/ess-16.04/lisp")
(load "ess-site")
(require 'package)
(setq package-archives
      '(("melpa-stable" . "http://stable.melpa.org/packages/")
	("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(require 'magit)
(add-to-list 'custom-theme-load-path "~/src/emacs-color-theme-solarized")
(load-theme 'solarized t)
(set-frame-parameter nil 'background-mode 'dark)
(set-terminal-parameter nil 'background-mode 'dark)
(autoload 'markdown-mode "markdown-mode"
  "Major mode for editing Markdown files" t)
(setq svn-status-verbose nil)
;(setq svn-status-default-diff-arguments '("--diff-cmd" "/home/mstemm/bin/bdiff" "-x" "-b" "-B"))
(setq svn-status-default-diff-arguments nil)
(global-font-lock-mode 1)
(global-set-key "\M-?" 'help-command)	;beyond any doubt, binding this to ^H was the stupidest thing RMS did to EMACS
(global-set-key "\M-?\M-?" 'help-for-help) ;let's be as consistent as possible
(global-set-key "\C-xn" 'other-window)
(global-set-key "\C-xp" '(lambda () (interactive) (other-window -1)))
(global-set-key "\C-xd" 'delete-window)
(global-set-key "\C-x\C-g" 'gdb)
(global-set-key "\C-x\C-v" 'find-file-other-window)
(global-set-key "\C-x\C-l" 'goto-line)
(global-set-key "\C-x\C-m" 'compile)
(global-set-key "\C-x\C-n" 'next-error)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\M-h" 'backward-kill-word)
(global-set-key "\e\C-h" 'backward-kill-word)
(global-set-key "\e\C-?" 'backward-kill-word) ;DEL doesn't seem to work
(global-set-key "\M-=" 'what-line)
(global-set-key "\C-x\C-z" 'shrink-window) 
(global-set-key "\C-xz" 'grow-window)
(global-set-key "\C-z" 'suspend-emacs)
(global-set-key "\C-q" 'indent-region)
(global-set-key "\C-t" 'call-last-kbd-macro)
(global-set-key "\C-x\m" 'magit-status)

(global-set-key "\C-m" 'newline-and-indent)

(defun count-words-region (start end)
  (interactive "r")
  (save-excursion
    (let ((n 0))
      (goto-char start)
      (while (< (point) end)
	(if (forward-word 1)
	    (setq n (1+ n))))
      (message "Region has %d words" n)
      n)))

(setq c-tab-always-indent nil)

(setq ruby-indent-level 4)

(setq cmake-tab-width 8)

;; turn on line number mode
(line-number-mode 1)

;(load "~/elisp/juttle-derived-mode.el")
;(autoload 'juttle-derived-mode "juttle-derived-mode" "Juttle mode" t)

(setq auto-mode-alist
      (nconc (list '("\\.[ly]$" . c-mode) ;for lex/yacc input
                   '("\\.pl$" . perl-mode)
		   '("\\.pm$" . perl-mode)
                   '("\\.tgz" . tar-mode)
		   '("\\.java$" . java-mode)
		   '("\\.juttle$" . juttle-derived-mode)
		   '("\\.js$" . js2-mode)
		   '("\\.cc$" . c++-mode)
		   '("\\.hh$" . c++-mode)
		   '("\\.h$" . c-mode)
		   '("\\.c$" . c-mode)
		   '("\\.H$" . c-mode)
		   '("\\.C$" . c-mode)		   
		   '("\\.xsd$" . xml-mode)		   
                   '("\\.html$". html-helper-mode)
		   '("\\.md$". markdown-mode)
		   '("\\.markdown$". markdown-mode)
                   )
             auto-mode-alist))

;;limit the size of shell buffers
(setq comint-buffer-maximum-size 10000)
(add-hook 'comint-output-filter-functions
	  'comint-truncate-buffer)

(defun my-c-mode-hook ()
  (c-set-style "linux")

  (setq c-basic-offset 8)

  (define-key c-mode-map "\C-c\C-c" 'compile)
  (define-key c++-mode-map "\C-c\C-c" 'compile)
  (define-key c-mode-map "\C-cg" 'gdb)
  (define-key c++-mode-map "\C-cg" 'gdb)
  (define-key c-mode-map "\r" 'newline-and-indent)
  (define-key c++-mode-map "\r" 'newline-and-indent))

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

(setq buffers-menu-sort-function
      'sort-buffers-menu-by-size)

(autoload 'compile-internal "compile")
(defun grope (sym)
  (interactive (list (read-string "Grope for: " (current-word))))
  (compile-internal (concat "grope " sym) "No more grope hits" "grope"
                    nil grep-regexp-alist))
;(setq tab-width 4)
;(setq indent-tabs-mode nil) 

(defun any-mode-untabify ()
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "[ \t]+$" nil t)
      (delete-region (match-beginning 0) (match-end 0)))
    (goto-char (point-min))
;    (if (search-forward "\t" nil t)
;	(untabify (1- (point)) (point-max)))
    )
  nil)

(add-hook 'text-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'xml-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'perl-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'c-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'java-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'c++-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'cc-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'latex-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'python-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'sgml-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'ruby-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'lua-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'sql-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))

(add-hook 'ess-mode-hook
	  '(lambda ()
	     (make-local-variable 'write-contents-functions)
	     (add-hook 'write-contents-functions 'any-mode-untabify)))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-diff-arguments
   (quote
    ("--function-context" "--ignore-space-change" "--no-ext-diff" "--stat"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
