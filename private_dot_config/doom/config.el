;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;;pour perf
(setq gc-cons-threshold (* 50 1000 1000))
(setq read-process-output-max (* 1024 1024))
(setq doom-modeline-persp-name nil)
(setq doom-modeline-buffer-file-name-style 'truncate-except-project)

;; loop pour tache repetitive
(setq auto-save-timeout 3)
(setq org-todo-repeat-to-state "LOOP")

;; config org
(after! org
  (setq org-agenda-files '("~/org/"
                           ;; "~/Documents/org/"  ; décommente si tu as ça
                            "~/notes/org"          ; décommente si tu as ça
                           ;; ajoute tes vrais chemins de fichiers org
                           ))

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
          ("@fortnite" . ?l)
          ("@health" . ?h)
          ("@priority_high" . ?1)
          ("@priority_med" . ?2)
          ("@priority_low" . ?3)))

  ;; PROGRESS TRACKING
  (setq org-hierarchical-todo-statistics nil)
  (setq org-checkbox-hierarchical-statistics nil)

  ;; MA TEMPLATES CAPTURE (peut etre opti)
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

;; voir comment gerer le clocking, si utile ou non ?
(after! org-clock
  (setq org-clock-continuously t)
  (setq org-clock-idle-time 10)
  (setq org-clock-auto-clock-resolution 'when-no-clock-is-running)
  
  (setq org-clocktable-defaults
        '(:maxlevel 3 :lang "fr" :scope agenda-with-archives 
          :wstart 1 :mstart 1 :step week :stepskip0 t :fileskip0 t
          :tags "OBJECTIF|MILESTONE")))

;; ===== KEYBINDINGS RAPIDES =====
(map! :leader
      (:prefix-map ("n g" . "goals")
       :desc "Goals dashboard"    "g" #'(lambda () (interactive) (org-agenda nil "g"))
       :desc "Weekly review"      "w" #'(lambda () (interactive) (org-agenda nil "w"))
       :desc "Clock in goal"      "i" #'org-clock-in
       :desc "Clock out"          "o" #'org-clock-out
       :desc "New objectif"       "n" #'(lambda () (interactive) (org-capture nil "o"))
       :desc "New milestone"      "m" #'(lambda () (interactive) (org-capture nil "m"))
       :desc "Review"             "r" #'(lambda () (interactive) (org-capture nil "r"))))

;; Auto-save quand si je clock
(add-hook 'org-clock-in-hook 'org-save-all-org-buffers)
