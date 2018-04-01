;http://keisanbutsuriya.hateblo.jp/entry/2015/01/29/182251
(require 'package)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)


;;
;;
;;
;; (require 'mozc)
;; (set-language-environment "Japanese")
;; (setq default-input-method "japanese-mozc")
;; (prefer-coding-system 'utf-8)


;;
;; Auto Complete
;;
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'text-mode)         ;; text-modeでも自動的に有効にする
(add-to-list 'ac-modes 'fundamental-mode)  ;; fundamental-mode
(add-to-list 'ac-modes 'org-mode)
(add-to-list 'ac-modes 'yatex-mode)
(ac-set-trigger-key "TAB")
(setq ac-use-menu-map t)       ;; 補完メニュー表示時にC-n/C-pで補完候補選択
(setq ac-use-fuzzy t)          ;; 曖昧マッチx


;;reference=============================================
;;http://d.hatena.ne.jp/sandai/20120304/p2
;; load-pathの追加関数
(defun add-to-load-path (&rest paths)
  (let (path)
    (dolist (path paths paths)
      (let ((default-directory (expand-file-name (concat user-emacs-directory path))))
        (add-to-list 'load-path default-directory)
        (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
            (normal-top-level-add-subdirs-to-load-path))))))


;; load-pathに追加するフォルダ
;; 2つ以上フォルダを指定する場合の引数 => (add-to-load-path "elisp" "xxx" "xxx")
(add-to-load-path "elisp")

;; 文字コード
(set-language-environment "Japanese")
(let ((ws window-system))
 (cond ((eq ws 'w32)
        (prefer-coding-system 'utf-8-unix)
        (set-default-coding-systems 'utf-8-unix)
        (setq file-name-coding-system 'sjis)
        (setq locale-coding-system 'utf-8))
       ((eq ws 'ns)
        (require 'ucs-normalize)
        (prefer-coding-system 'utf-8-hfs)
        (setq file-name-coding-system 'utf-8-hfs)
        (setq locale-coding-system 'utf-8-hfs))))


;; ------------------------------------------------------------------------
;; @ auto-install.el

;; パッケージのインストールを自動化
;; http://www.emacswiki.org/emacs/auto-install.el
(when (require 'auto-install nil t)
  (setq auto-install-directory "~/.emacs.d/elisp/")
  (auto-install-update-emacswiki-package-name t)
  (auto-install-compatibility-setup))

;;================================================================

(add-to-list 'default-frame-alist
	     '(font . "-*-Menlo-normal-normal-normal-*-*-*-*-*-m-0-fontset-startup"))


;;
;;;clang-format
;;;
;; (load "/usr/share/emacs/site-lisp/clang-format-3.9/clang-format.el")
;; (add-hook 'c-mode-common-hook
;;           (function (lambda ()
;;                     (add-hook 'after-save-hook
;;                               'clang-format-buffer))))




;;;  起動時の画面なし
(setq inhibit-startup-message t)

;;(tool-bar-mode -1)        ; メニューバーを隠す

;; C-k １回で行全体を削除する
(setq kill-whole-line t)

;; 対応する括弧をハイライトする
(show-paren-mode 1)

;; ¥の代わりにバックスラッシュを入力する
(define-key global-map [?¥] [?\\])

;; ウィンドウを切り替える
(define-key global-map (kbd "s-o") 'other-window) 

;; 指定行にジャンプする
(global-set-key "\C-xj" 'goto-line)

;; C-x C-l で現在行を top にする
;; 元々は C-u 0 C-l
;; ちなみに C-l は現在行を center にする
(defun line-to-top-of-window ()
  "Move the line point is on to top of window."
  (interactive) 
  (recenter 0))
(global-set-key "\C-x\C-l" 'line-to-top-of-window)

;; isearch の文字を取得
;; C-s した後に C-d すれば search する文字の入力を省けることに。
(defun isearch-yank-char ()
  "Pull next character from buffer into search string."
  (interactive)
  (isearch-yank-string
   (save-excursion
     (and (not isearch-forward) isearch-other-end
          (goto-char isearch-other-end))
     (buffer-substring (point) (1+ (point))))))
(define-key isearch-mode-map "\C-d" 'isearch-yank-char)

;; メニューバーを消す
(menu-bar-mode nil)

;; 行数を表示する
(global-linum-mode t)

;;; 履歴数を大きくする
(setq history-length 10000)

;;; ミニバッファの履歴を保存する
(savehist-mode 1)

;;; 最近開いたファイルを保存する数を増やす
(setq recentf-max-saved-items 10000)

;; Color
(if window-system (progn
    (set-background-color "Black")
    (set-foreground-color "LightGray")
    (set-cursor-color "Gray")
    (set-frame-parameter nil 'alpha 88) ;透明度
    ))


;; バックアップを残さない
(setq make-backup-files nil)



;; 1行ずつスクロール
(setq scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
(setq comint-scroll-show-maximum-output t) ;; shell-mode

;;ref
;;http://emacs.rubikitch.com/tabbar/
;;
;;    タブ   


(require 'tabbar)
(tabbar-mode)

(tabbar-mwheel-mode nil)                  ;; マウスホイール無効
(setq tabbar-buffer-groups-function nil)  ;; グループ無効
(setq tabbar-use-images nil)              ;; 画像を使わない


;;----- キーに割り当てる
(global-set-key (kbd "<C-tab>") 'tabbar-forward-tab)
(global-set-key (kbd "<C-S-iso-lefttab>") 'tabbar-backward-tab)


;;----- 左側のボタンを消す
(dolist (btn '(tabbar-buffer-home-button
               tabbar-scroll-left-button
               tabbar-scroll-right-button))
  (set btn (cons (cons "" nil)
                 (cons "" nil))))


;;----- タブのセパレーターの長さ
(setq tabbar-separator '(2.0))


;;----- タブの色（CUIの時。GUIの時は後でカラーテーマが適用）
(set-face-attribute
 'tabbar-default nil
 :background "brightblue"
 :foreground "white"
 )
(set-face-attribute
 'tabbar-selected nil
 :background "#ff5f00"
 :foreground "brightwhite"
 :box nil
 )
(set-face-attribute
 'tabbar-modified nil
 :background "brightred"
 :foreground "brightwhite"
 :box nil
 )


;;----- 表示するバッファ
(defun my-tabbar-buffer-list ()
  (delq nil
        (mapcar #'(lambda (b)
                    (cond
                     ;; Always include the current buffer.
                     ((eq (current-buffer) b) b)
                     ((buffer-file-name b) b)
                     ((char-equal ?\  (aref (buffer-name b) 0)) nil)
                     ((equal "*scratch*" (buffer-name b)) b) ; *scratch*バッファは表示する
                     ((char-equal ?* (aref (buffer-name b) 0)) nil) ; それ以外の * で始まるバッファは表示しない
                     ((buffer-live-p b) b)))
                (buffer-list))))
(setq tabbar-buffer-list-function 'my-tabbar-buffer-list)


;;multi-termの設定
;; (when (require 'multi-term nil t)
;;   ;;使用するシェルを指定
;;   (setq multi-term-program "/bin/bash"))


(global-set-key "\C-h" 'delete-backward-char)




(add-to-list 'load-path "/usr/local/share/gtags")

(require 'gtags)
(add-hook 'c-mode-common-hook 'gtags-mode)
(add-hook 'c++-mode-hook 'gtags-mode)
(add-hook 'java-mode-hook 'gtags-mode)
(add-hook 'python-mode-hook 'gtags-mode)


(setq gtags-path-style 'relative)             ;相対パス表示にする
(global-set-key "\M-t" 'gtags-find-tag)       ;関数の定義場所の検索
(global-set-key "\M-r" 'gtags-find-rtag)      ;関数や使用箇所の検索
(global-set-key "\M-s" 'gtags-find-symbol)    ;変数の使用箇所の検索
(global-set-key "\M-a" 'gtags-pop-stack)      ;タグジャンプした箇所からひとつ戻る
(global-set-key "\M-l" 'gtags-find-with-grep) ;タグファイルを検索する
(setq view-read-only t)  ; 読み込み専用バッファを自動的にview-modeにする
(setq gtags-read-only t) ; 上と合わせることで、タグジャンプ先をview-modeにする。



;; http://d.hatena.ne.jp/kyagi/20080226/1204034637 より、タグファイルの切り替えをする。
;; 個人的な設定として、本家の「F12」キーから「F10」に変更した。
;;; ** gtags-mode
(global-set-key "\M-." 'gtags-find-tag)
(autoload 'gtags-find-tag "gtags" "" t)
(autoload 'gtags-mode "gtags" "" t)
;(add-hook 'gtags-mode-hook 'setnu-mode)
(setq gtags-auto-update t)

;; Markdown-mode
;;===============================================================================
;; markdownをgithubふうにしてくれるもの
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;; F8でnetreee-windowが開くようにする
(global-set-key [f8] 'neotree-toggle)


(setq github-user "RoyMoto")
(setq github-pass "10t0061b")
;;(setq github-api-url "https://api.github.com")

(defun my-markdown-preview ()
  (interactive)
  (when (get-process "grip") (kill-process "grip"))
  (when (get-process "grip<1>") (kill-process "grip<1>"))  ;; プロセスが二重に起動していた場合、そちらもkillする
  (start-process "grip" "*grip*" "grip" (format "--user=%s" github-user) (format "--pass=%s" github-pass) "--api-url=https://api.github.com"  "--browser" buffer-file-name)
  (when (get-process "grip") (set-process-query-on-exit-flag (get-process "grip") nil))
  (when (get-process "grip<1>") (set-process-query-on-exit-flag (get-process "grip<1>") nil))    ;; プロセスが二重に起動していた場合、そちらもフラグを設定する
  )
(define-key global-map (kbd "C-c p") 'my-markdown-preview)



;;quickrun
;;==============================================================================
;; pythonようにquickrunを導入
;;
(global-set-key (kbd "<f5>") 'quickrun)
(global-set-key (kbd "C-<f5>") 'quickrun-with-arg)
(global-set-key (kbd "M-<f5>") 'quickrun-compile-only)

;;jedi
;;=============================================================================
;; python用に補完機能として追加
;;
(require 'epc)
(require 'auto-complete-config)
(require 'python)

;; 補完対象とするソースコードまでのパス
(require 'jedi)
(add-hook 'python-mode-hook 'jedi:setup)
(setq jedi:complete-on-dot t)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (helm-gtags volatile-highlights helm-projectile helm w3m tabbar quickrun python-mode neotree mozc markdown-mode jedi git-gutter clang-format))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work



;;  ;;; helmの設定
(require 'helm-config)
(helm-mode 1)
(helm-migemo-mode 1)

;; ;; C-hで前の文字削除
;; (define-key helm-map (kbd "C-h") 'delete-backward-char)
;; (define-key helm-find-files-map (kbd "C-h") 'delete-backward-char)

;; ;; TABとC-zを入れ替える
;; (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)   ; rebind tab to run persistent action
;; (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)       ; make TAB work in terminal
;; (define-key helm-map (kbd "C-z")  'helm-select-action)            ; list actions using C-z
;; ;;(define-key helm-find-files-map (kbd "TAB") 'helm-execute-persistent-action)
;; ;;(define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)

;; ;; キーバインド
(global-set-key (kbd "C-c h") 'helm-mini)
(global-set-key (kbd "<f10>") 'helm-mini)
(define-key global-map (kbd "C-x b")   'helm-buffers-list)
(define-key global-map (kbd "C-x b") 'helm-for-files)
(define-key global-map (kbd "C-x C-f") 'helm-find-files)
(define-key global-map (kbd "M-x")     'helm-M-x)
(define-key global-map (kbd "M-y")     'helm-show-kill-ring)
