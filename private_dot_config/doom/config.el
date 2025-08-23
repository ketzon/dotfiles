;;pour perf
(setq gc-cons-threshold (* 50 1000 1000))
(setq read-process-output-max (* 1024 1024))
(setq doom-modeline-persp-name nil)
(setq doom-modeline-buffer-file-name-style 'truncate-except-project)

; (use-package org-habit-stats
;   :after org-habit
;   :config
;   (setq org-habit-stats-graph-output-file "~/notes/org/habit-stats.svg")  
;   (setq org-habit-stats-calendar-output-file "~/notes/org/habit-calendar.svg"))

;; loop pour tache repetitive
(setq auto-save-timeout 3)
(setq org-todo-repeat-to-state "loop")

(after! org-roam
  (setq org-roam-directory "~/org-roam/")
  (setq org-roam-dailies-directory "~/org-roam/daily/")

  ;; templates pour les notes quotidiennes
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "* todo %?"
           :target (file+head "%<%y-%m-%d>.org"
                             "#+title: %<%a %d %b %y>\n#+filetags: :daily:\n\n* 🎯 priorités du jour\n\n* 📋 todos\n** à faire aujourd'hui\n** en cours\n\n* 📅 agenda\n\n* 📝 notes\n"))
          ("t" "todo rapide" entry "* todo %?"
           :target (file+head "%<%y-%m-%d>.org"
                             "#+title: %<%y-%m-%d>\n#+filetags: :daily:\n")
           :prepend t)))

  ;; fonction pour todo rapide
  (defun my/quick-daily-todo ()
    "ajoute un todo à la note du jour"
    (interactive)
    (org-roam-dailies-goto-today)
    (goto-char (point-max))
    (insert "\n* todo ")
    (save-buffer)))

;; org config
(after! org
  ;; duration modulable
 (add-to-list 'org-modules 'org-habit t)
  (setq org-effort-durations
        '(("min" . 1)
          ("h" . 60)
          ("d" . 480)  ; 8h par jour
          ("w" . 2400) ; 5 jours par semaine
          ("m" . 9600) ; 4 semaines par mois
          ("y" . 115200))) ; 12 mois par an
  
  ;; set default
  (setq org-duration-format '((special . h:mm)))

  (setq org-agenda-files '("~/org/"
                          "~/notes/org/"
                          "~/org-roam/daily/"))

  ;; todo keywords
  (setq org-todo-keywords
        '((sequence "todo(t)" "next(n)" "in-progress(i)" "waiting(w)" "|" "done(d)" "cancelled(c)")
          (sequence "objectif(o)" "milestone(m)" "|" "achieved(a)" "dropped(x)")))

  ;; color todo
  (setq org-todo-keyword-faces
        '(("objectif" . "#ff6c6b")
          ("milestone" . "#ecbe7b") 
          ("in-progress" . "#51afef")
          ("achieved" . "#98be65")))

  ;; tags
  (setq org-tag-alist
        '(("@sport" . ?s)
          ("@code" . ?c) 
          ("@japanese" . ?j)
          ("@learning" . ?l)
          ("@fortnite" . ?f)
          ("@health" . ?h)
          ("@priority_high" . ?1)
          ("@priority_med" . ?2)
          ("@priority_low" . ?3)))

  ;; progress tracking
  (setq org-hierarchical-todo-statistics nil)
  (setq org-checkbox-hierarchical-statistics nil)

  ;; templates capture
  (setq org-capture-templates
        '(("o" "objectif" entry
           (file+headline "~/org/goals.org" "objectifs")
           "* objectif %^{nom objectif} [0%%] :%^{tag}:
deadline: %^{deadline}t
:properties:
:effort: %^{estimation effort total}
:priority: %^{a|b|c}
:resources: %^{ressources/semaine}
:why: %^{pourquoi cet objectif}
:success: %^{critères de succès}
:end:

%^{description détaillée}

** milestone %^{première étape} [0%%]
** milestone %^{deuxième étape} [0%%]  
** milestone %^{troisième étape} [0%%]")

          ("m" "milestone" entry
           (file+headline "~/org/goals.org" "objectifs")
           "** milestone %^{nom milestone} [0%%]
deadline: %^{deadline}t
:properties:
:effort: %^{estimation effort}
:end:

%^{description}

*** todo %^{sous-tâche 1}
*** todo %^{sous-tâche 2}")

          ("r" "revue goals" entry
           (file+headline "~/org/goals.org" "revues")
           "* revue goals - semaine %<%y-w%u>
:properties:
:created: %u
:end:

** progrès cette semaine
- [ ] japonais: %^{progrès japonais}
- [ ] sport: %^{progrès sport}  
- [ ] code: %^{progrès code}

** blocages rencontrés
%^{blocages}

** ajustements pour la semaine prochaine
%^{ajustements}

** priorisation ressources
| objectif | temps alloué | justification |
|----------+--------------+---------------|
| %^{obj1} | %^{temps1}   | %^{just1}     |
| %^{obj2} | %^{temps2}   | %^{just2}     |")))

  ;; column view
  (setq org-columns-default-format 
        "%40item(task) %10todo %10effort(effort){:} %10clocksum(clocked) %16tags(tags)")
        
  ;; propriétés globales
  (setq org-global-properties
        '(("effort_all" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 8:00")
          ("priority_all" . "a b c")
          ("resources_all" . "1h/semaine 2h/semaine 5h/semaine 10h/semaine 15h/semaine"))))

;; clocking
(after! org-clock
  (setq org-clock-continuously t)
  (setq org-clock-idle-time 10)
  (setq org-clock-auto-clock-resolution 'when-no-clock-is-running)
  
  (setq org-clocktable-defaults
        '(:maxlevel 3 :lang "fr" :scope agenda-with-archives 
          :wstart 1 :mstart 1 :step week :stepskip0 t :fileskip0 t
          :tags "objectif|milestone"))
  (add-hook 'org-clock-in-hook 'org-save-all-org-buffers))

(map! :leader
      ;; goals existants
      (:prefix-map ("n g" . "goals")
       :desc "goals dashboard"    "g" #'(lambda () (interactive) (org-agenda nil "g"))
       :desc "weekly review"      "w" #'(lambda () (interactive) (org-agenda nil "w"))
       :desc "clock in goal"      "i" #'org-clock-in
       :desc "clock out"          "o" #'org-clock-out
       :desc "new objectif"       "n" #'(lambda () (interactive) (org-capture nil "o"))
       :desc "new milestone"      "m" #'(lambda () (interactive) (org-capture nil "m"))
       :desc "review"             "r" #'(lambda () (interactive) (org-capture nil "r")))

      ;; shesh
      (:prefix-map ("n d" . "daily notes")
       :desc "capture today"      "d" #'org-roam-dailies-capture-today
       :desc "goto today"         "t" #'org-roam-dailies-goto-today
       :desc "previous note"      "p" #'org-roam-dailies-goto-previous-note
       :desc "next note"          "n" #'org-roam-dailies-goto-next-note
       :desc "quick todo"         "q" #'my/quick-daily-todo))

;; shortcut globaux compatibles doom
(map! "c-c n d" #'org-roam-dailies-capture-today
      "c-c n t" #'org-roam-dailies-goto-today
      "c-c n q" #'my/quick-daily-todo)

