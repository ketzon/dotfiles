;;pour perf
(setq gc-cons-threshold (* 50 1000 1000))
(setq read-process-output-max (* 1024 1024))
(setq doom-modeline-persp-name nil)
(setq doom-modeline-buffer-file-name-style 'truncate-except-project)

;; loop pour tache repetitive
(setq auto-save-timeout 3)
(setq org-todo-repeat-to-state "LOOP")

(after! org-roam
  (setq org-roam-directory "~/org-roam/")
  (setq org-roam-dailies-directory "~/org-roam/daily/")

  ;; templates pour les notes quotidiennes
  (setq org-roam-dailies-capture-templates
        '(("d" "default" entry "* TODO %?"
           :target (file+head "%<%Y-%m-%d>.org"
                             "#+title: %<%A %d %B %Y>\n#+filetags: :daily:\n\n* 🎯 Priorités du jour\n\n* 📋 TODOs\n** À faire aujourd'hui\n** En cours\n\n* 📅 Agenda\n\n* 📝 Notes\n"))
          ("t" "todo rapide" entry "* TODO %?"
           :target (file+head "%<%Y-%m-%d>.org"
                             "#+title: %<%Y-%m-%d>\n#+filetags: :daily:\n")
           :prepend t)))

  ;; Fonction pour TODO rapide
  (defun my/quick-daily-todo ()
    "Ajoute un TODO à la note du jour"
    (interactive)
    (org-roam-dailies-goto-today)
    (goto-char (point-max))
    (insert "\n* TODO ")
    (save-buffer)))

;; org config
(after! org
  ;; duration modulable
  (setq org-effort-durations
        '(("min" . 1)
          ("h" . 60)
          ("d" . 480)  ; 8h par jour
          ("w" . 2400) ; 5 jours par semaine
          ("m" . 9600) ; 4 semaines par mois
          ("y" . 115200))) ; 12 mois par an
  
  ;; set default
  (setq org-duration-format '((special . h:mm)))

  ;; AGENDA FILES - INCLUT org-roam dailies
  (setq org-agenda-files (append '("~/org/"
                                   "~/notes/org/"
                                   "~/org-roam/daily/"))

  ;; TODO KEYWORDS
  (setq org-todo-keywords
        '((sequence "TODO(t)" "NEXT(n)" "IN-PROGRESS(i)" "WAITING(w)" "|" "DONE(d)" "CANCELLED(c)")
          (sequence "OBJECTIF(o)" "MILESTONE(m)" "|" "ACHIEVED(a)" "DROPPED(x)")))

  ;; color TODO
  (setq org-todo-keyword-faces
        '(("OBJECTIF" . "#ff6c6b")
          ("MILESTONE" . "#ECBE7B") 
          ("IN-PROGRESS" . "#51afef")
          ("ACHIEVED" . "#98be65")))

  ;; TAGS
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

  ;; PROGRESS TRACKING
  (setq org-hierarchical-todo-statistics nil)
  (setq org-checkbox-hierarchical-statistics nil)

  ;; TEMPLATES CAPTURE
  (setq org-capture-templates
        '(("o" "Objectif" entry
           (file+headline "~/org/goals.org" "Objectifs")
           "* OBJECTIF %^{Nom objectif} [0%%] :%^{Tag}:
DEADLINE: %^{Deadline}t
:PROPERTIES:
:EFFORT: %^{Estimation effort total}
:PRIORITY: %^{A|B|C}
:RESOURCES: %^{Ressources/semaine}
:WHY: %^{Pourquoi cet objectif}
:SUCCESS: %^{Critères de succès}
:END:

%^{Description détaillée}

** MILESTONE %^{Première étape} [0%%]
** MILESTONE %^{Deuxième étape} [0%%]  
** MILESTONE %^{Troisième étape} [0%%]")

          ("m" "Milestone" entry
           (file+headline "~/org/goals.org" "Objectifs")
           "** MILESTONE %^{Nom milestone} [0%%]
DEADLINE: %^{Deadline}t
:PROPERTIES:
:EFFORT: %^{Estimation effort}
:END:

%^{Description}

*** TODO %^{Sous-tâche 1}
*** TODO %^{Sous-tâche 2}")

          ("r" "Revue Goals" entry
           (file+headline "~/org/goals.org" "Revues")
           "* Revue Goals - Semaine %<%Y-W%U>
:PROPERTIES:
:CREATED: %U
:END:

** Progrès cette semaine
- [ ] Japonais: %^{Progrès Japonais}
- [ ] Sport: %^{Progrès Sport}  
- [ ] Code: %^{Progrès Code}

** Blocages rencontrés
%^{Blocages}

** Ajustements pour la semaine prochaine
%^{Ajustements}

** Priorisation ressources
| Objectif | Temps alloué | Justification |
|----------+--------------+---------------|
| %^{Obj1} | %^{Temps1}   | %^{Just1}     |
| %^{Obj2} | %^{Temps2}   | %^{Just2}     |")))

  ;; COLUMN VIEW
  (setq org-columns-default-format 
        "%40ITEM(Task) %10TODO %10EFFORT(Effort){:} %10CLOCKSUM(Clocked) %16TAGS(Tags)")
        
  ;; PROPRIÉTÉS GLOBALES
  (setq org-global-properties
        '(("EFFORT_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 8:00")
          ("PRIORITY_ALL" . "A B C")
          ("RESOURCES_ALL" . "1h/semaine 2h/semaine 5h/semaine 10h/semaine 15h/semaine"))))

;; CLOCKING
(after! org-clock
  (setq org-clock-continuously t)
  (setq org-clock-idle-time 10)
  (setq org-clock-auto-clock-resolution 'when-no-clock-is-running)
  
  (setq org-clocktable-defaults
        '(:maxlevel 3 :lang "fr" :scope agenda-with-archives 
          :wstart 1 :mstart 1 :step week :stepskip0 t :fileskip0 t
          :tags "OBJECTIF|MILESTONE"))
  (add-hook 'org-clock-in-hook 'org-save-all-org-buffers))

(map! :leader
      ;; Goals existants
      (:prefix-map ("n g" . "goals")
       :desc "Goals dashboard"    "g" #'(lambda () (interactive) (org-agenda nil "g"))
       :desc "Weekly review"      "w" #'(lambda () (interactive) (org-agenda nil "w"))
       :desc "Clock in goal"      "i" #'org-clock-in
       :desc "Clock out"          "o" #'org-clock-out
       :desc "New objectif"       "n" #'(lambda () (interactive) (org-capture nil "o"))
       :desc "New milestone"      "m" #'(lambda () (interactive) (org-capture nil "m"))
       :desc "Review"             "r" #'(lambda () (interactive) (org-capture nil "r")))

      ;; shesh
      (:prefix-map ("n d" . "daily notes")
       :desc "Capture today"      "d" #'org-roam-dailies-capture-today
       :desc "Goto today"         "t" #'org-roam-dailies-goto-today
       :desc "Previous note"      "p" #'org-roam-dailies-goto-previous-note
       :desc "Next note"          "n" #'org-roam-dailies-goto-next-note
       :desc "Quick TODO"         "q" #'my/quick-daily-todo))

;; shortcut globaux compatibles doom
(map! "C-c n d" #'org-roam-dailies-capture-today
      "C-c n t" #'org-roam-dailies-goto-today
      "C-c n q" #'my/quick-daily-todo)
