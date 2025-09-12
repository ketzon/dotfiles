;;; config.el -*- lexical-binding: t; -*-

;; delete le putain de mode log
(setq org-agenda-start-with-log-mode nil)
(setq org-agenda-skip-deadline-if-done t
      org-agenda-skip-scheduled-if-done t)


;; -------------------------------------------------------------------
;; opti perf 
;; -------------------------------------------------------------------
(setq auto-save-timeout 3)                          
(setq read-process-output-max (* 1024 1024))       
(setq doom-modeline-persp-name nil)
(setq doom-modeline-buffer-file-name-style 'truncate-except-project)
(setq echo-keystrokes 0.02)

;; -------------------------------------------------------------------
;; orgmode + orgmode
;; -------------------------------------------------------------------
(after! org-roam
  (setq org-roam-directory (expand-file-name "~/org-roam/"))
  (setq org-roam-dailies-directory "daily/")
  (org-roam-db-autosync-mode 1)

  ;; template daily
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "* TODO %?"
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%a %d %b %Y>\n#+filetags: :daily:\n\n* 🎯 priorités du jour\n\n* 📋 todos\n** à faire aujourd'hui\n** en cours\n\n* 📅 agenda\n\n* 📝 notes\n"))
          ("t" "todo rapide" entry "* TODO %?"
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n#+filetags: :daily:\n")
           :prepend t)))

  ;; todo function
  (defun my/quick-daily-todo ()
    "Ajoute un TODO à la note du jour."
    (interactive)
    (org-roam-dailies-goto-today)
    (goto-char (point-max))
    (insert "\n* TODO ")
    (save-buffer)))

;; -------------------------------------------------------------------
;; org overall
;; -------------------------------------------------------------------
(after! org
  (add-to-list 'org-modules 'org-habit t)

  (setq org-effort-durations
        '(("min" . 1)
          ("h"   . 60)
          ("d"   . 480)    ; 8h par jour
          ("w"   . 2400)   ; 5 jours
          ("m"   . 9600)   ; 4 semaines
          ("y"   . 115200))) ; 12 mois
  (setq org-duration-format '((special . h:mm)))

  ;; my file
  (setq org-agenda-files
        (append
         (directory-files-recursively "~/org" "\\.org$")
         (directory-files-recursively "~/notes/org" "\\.org$")
         (directory-files-recursively "~/org-roam/daily" "\\.org$")))

  ;; todo in maj
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "IN-PROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")
          (sequence "OBJECTIF(o)" "MILESTONE(m)" "|" "ACHIEVED(a)" "DROPPED(x)")))

  (setq org-todo-keyword-faces
        '(("OBJECTIF" . "#ff6c6b")
          ("MILESTONE" . "#ecbe7b")
          ("IN-PROGRESS" . "#51afef")
          ("ACHIEVED" . "#98be65")))

  ;; tags
  (setq org-tag-alist
        '(("@sport" . ?s)
          ("@code" . ?c)
          ("@japanese" . ?j)
          ("@learning" . ?l)
          ("@fortnite" . ?f)
          ("@health" . ?h)
          ("@priority_high" . ?1)
          ("@priority_med"  . ?2)
          ("@priority_low"  . ?3)))

  (setq org-hierarchical-todo-statistics nil
        org-checkbox-hierarchical-statistics nil)

  ;; tempalte for capture
  (setq org-capture-templates
        '(("o" "objectif" entry
           (file+headline "~/org/goals.org" "objectifs")
           "* OBJECTIF %^{nom objectif} [0%%] :%^{tag}:\nDEADLINE: %^{deadline}t\n:PROPERTIES:\n:EFFORT: %^{estimation effort total}\n:PRIORITY: %^{A|B|C}\n:RESOURCES: %^{ressources/semaine}\n:WHY: %^{pourquoi cet objectif}\n:SUCCESS: %^{critères de succès}\n:END:\n\n%^{description détaillée}\n\n** MILESTONE %^{première étape} [0%%]\n** MILESTONE %^{deuxième étape} [0%%]\n** MILESTONE %^{troisième étape} [0%%]")
          ("m" "milestone" entry
           (file+headline "~/org/goals.org" "objectifs")
           "** MILESTONE %^{nom milestone} [0%%]\nDEADLINE: %^{deadline}t\n:PROPERTIES:\n:EFFORT: %^{estimation effort}\n:END:\n\n%^{description}\n\n*** TODO %^{sous-tâche 1}\n*** TODO %^{sous-tâche 2}")
          ("r" "revue goals" entry
           (file+headline "~/org/goals.org" "revues")
           "* Revue goals - semaine %<%Y-W%V>\n:PROPERTIES:\n:CREATED: %u\n:END:\n\n** Progrès cette semaine\n- [ ] japonais: %^{progrès japonais}\n- [ ] sport: %^{progrès sport}\n- [ ] code: %^{progrès code}\n\n** Blocages rencontrés\n%^{blocages}\n\n** Ajustements pour la semaine prochaine\n%^{ajustements}\n\n** Priorisation ressources\n| objectif | temps alloué | justification |\n|----------+--------------+---------------|\n| %^{obj1} | %^{temps1}   | %^{just1}     |\n| %^{obj2} | %^{temps2}   | %^{just2}     |")))

  (setq org-columns-default-format
        "%40ITEM(Task) %10TODO %10Effort(Effort){:} %10CLOCKSUM(Clocked) %16TAGS(Tags)")

  (setq org-global-properties
        '(("EFFORT_ALL"    . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 8:00")
          ("PRIORITY_ALL"  . "A B C")
          ("RESOURCES_ALL" . "1h/semaine 2h/semaine 5h/semaine 10h/semaine 15h/semaine")))

  (setq org-todo-repeat-to-state "TODO")

  (setq org-agenda-custom-commands
        '(("m" "ALL active TODOs"
           ((agenda "")
            (todo "TODO|IN-PROGRESS|MILESTONE")))
          ("n" "ALL TODOs"
           ((agenda "")
            (alltodo "")))
          ("g" "Goals Dashboard"
           ((todo "OBJECTIF"
                  ((org-agenda-overriding-header "🎯 MES OBJECTIFS PRINCIPAUX")
                   (org-agenda-prefix-format " %i %-12:c [%e] ")
                   (org-agenda-sorting-strategy '(priority-down effort-up))))
            (todo "IN-PROGRESS|MILESTONE"
                  ((org-agenda-overriding-header "🔥 EN COURS")
                   (org-agenda-prefix-format " %i %-12:c [%e] ")))
            (agenda ""
                    ((org-agenda-span 14)
                     (org-agenda-start-on-weekday nil)
                     (org-agenda-overriding-header "📅 DEADLINES À VENIR")))
            (todo "NEXT"
                  ((org-agenda-overriding-header "⚡ PROCHAINES ACTIONS")))))
          ("w" "Weekly Review"
           ((agenda "" ((org-agenda-span 7)
                        (org-agenda-start-on-weekday 1)))
            (todo "ACHIEVED" ((org-agenda-overriding-header "✅ ACHIEVEMENTS CETTE SEMAINE")))
            (todo "OBJECTIF|MILESTONE"
                  ((org-agenda-overriding-header "📊 ÉTAT DES OBJECTIFS")
                   (org-agenda-prefix-format " %i %-12:c [%e] %s"))))))))

;; -------------------------------------------------------------------
;; Org Clock
;; -------------------------------------------------------------------
(after! org-clock
  (setq org-clock-continuously t
        org-clock-idle-time 10
        org-clock-auto-clock-resolution 'when-no-clock-is-running
        org-clocktable-defaults
        '(:maxlevel 3 :lang "fr" :scope agenda-with-archives
          :wstart 1 :mstart 1 :step week :stepskip0 t :fileskip0 t
          :match "TODO=\"OBJECTIF\"|TODO=\"MILESTONE\""))
  (add-hook 'org-clock-in-hook #'org-save-all-org-buffers))

;; -------------------------------------------------------------------
;; shortcut
;; -------------------------------------------------------------------
(map! :leader
      ;; Goals
      (:prefix-map ("n g" . "goals")
       :desc "Goals dashboard" "g" (cmd! (org-agenda nil "g"))
       :desc "Weekly review"   "w" (cmd! (org-agenda nil "w"))
       :desc "Clock in goal"   "i" #'org-clock-in
       :desc "Clock out"       "o" #'org-clock-out
       :desc "New objectif"    "n" (cmd! (org-capture nil "o"))
       :desc "New milestone"   "m" (cmd! (org-capture nil "m"))
       :desc "Review"          "r" (cmd! (org-capture nil "r")))

      ;; Daily notes
      (:prefix-map ("n d" . "daily notes")
       :desc "Capture today"   "d" #'org-roam-dailies-capture-today
       :desc "Goto today"      "t" #'org-roam-dailies-goto-today
       :desc "Previous note"   "p" #'org-roam-dailies-goto-previous-note
       :desc "Next note"       "n" #'org-roam-dailies-goto-next-note
       :desc "Quick TODO"      "q" #'my/quick-daily-todo))

;; global shortcut with cc
(map! "C-c n d" #'org-roam-dailies-capture-today
      "C-c n t" #'org-roam-dailies-goto-today
      "C-c n q" #'my/quick-daily-todo)

;; ------- Vue calendrier (mois/semaine) -------
(use-package! calfw
  :commands (cfw:open-org-calendar))

(use-package! calfw-org
  :after (calfw org)
  :config
  (setq cfw:org-overwrite-default-keybinding t))

(map! :leader
      :desc "Agenda visuel (calfw)"
      "o c" #'cfw:open-org-calendar)

;;; === calfw blocks ===

(use-package! calfw :defer t)
(use-package! calfw-org :after calfw)
(use-package! calfw-blocks
  :after calfw-org
  :commands (my/open-org-calendar-blocks))

(defun my/open-org-calendar-blocks ()
  "Ouvrir Calfw en vue hebdo 'block-week' avec les sources Org."
  (interactive)
  (require 'calfw) (require 'calfw-org) (require 'calfw-blocks)
  (let ((src (cfw:org-create-source "SteelBlue")))
    (cfw:open-calendar-buffer
     :view 'block-week
     :contents-sources (list src))))

(map! :leader
      :desc "Agenda en blocs"
      "o b" #'my/open-org-calendar-blocks)

;; toujours en state emacs (pas d'interception par evil)
(with-eval-after-load 'calfw
  (evil-set-initial-state 'cfw:calendar-mode 'emacs))

(defun my/cfw--call (sym)
  (cond
   ((and (fboundp sym) (commandp sym)) (call-interactively sym))
   ((fboundp sym) (funcall sym))
   (t (message "Function %s not found" sym))))

(defun my/cfw-left  () (interactive)
  (if (fboundp 'cfw:navi-previous-day-command)
      (my/cfw--call 'cfw:navi-previous-day-command)
    (my/cfw--call 'cfw:navi-previous-day)))

(defun my/cfw-right () (interactive)
  (if (fboundp 'cfw:navi-next-day-command)
      (my/cfw--call 'cfw:navi-next-day-command)
    (my/cfw--call 'cfw:navi-next-day)))

(defun my/cfw-down () (interactive)
  (if (fboundp 'cfw:navi-next-week-command)
      (my/cfw--call 'cfw:navi-next-week-command)
    (my/cfw--call 'cfw:navi-next-week)))

(defun my/cfw-up   () (interactive)
  (if (fboundp 'cfw:navi-previous-week-command)
      (my/cfw--call 'cfw:navi-previous-week-command)
    (my/cfw--call 'cfw:navi-previous-week)))

(defun my/cfw-today () (interactive)
  (if (fboundp 'cfw:navi-goto-today-command)
      (my/cfw--call 'cfw:navi-goto-today-command)
    (my/cfw--call 'cfw:navi-goto-today)))

(defun my/cfw-change-view (view)
  "changer la vue de calfw à view et rafraîchir."
  (interactive)
  (let ((cp (cfw:cp-get-component)))
    (cfw:cp-set-view cp view)
    (cfw:refresh-calendar-buffer)))

;; ----------------- keymaps dans le calendrier -----------------
(with-eval-after-load 'calfw-blocks
  (let ((m cfw:calendar-mode-map))
    ;; vues
    (define-key m (kbd "d") #'cfw:change-view-day)
    (define-key m (kbd "w") #'cfw:change-view-week)
    (define-key m (kbd "m") #'cfw:change-view-month)
    (define-key m (kbd "b") (lambda () (interactive) (my/cfw-change-view 'block-week)))
    (define-key m (kbd "3") (lambda () (interactive) (my/cfw-change-view 'block-3-day)))
    (define-key m (kbd "5") (lambda () (interactive) (my/cfw-change-view 'block-5-day)))

    ;; navigation (robuste)
    (define-key m (kbd "h") #'my/cfw-left)
    (define-key m (kbd "l") #'my/cfw-right)
    (define-key m (kbd "j") #'my/cfw-down)
    (define-key m (kbd "k") #'my/cfw-up)

    ;; actions
    (define-key m (kbd "t") #'my/cfw-today)
    (define-key m (kbd "q") (lambda () (interactive) (quit-window t))) ; fermer
    (define-key m (kbd "g") #'cfw:refresh-calendar-buffer)
    (define-key m (kbd "r") #'cfw:refresh-calendar-buffer)
    (define-key m (kbd "RET") #'cfw:show-details)
    (define-key m (kbd "SPC") #'cfw:show-details)
    (define-key m (kbd "TAB") #'cfw:navi-next-item)
    (define-key m (kbd "<backtab>") #'cfw:navi-prev-item)))
