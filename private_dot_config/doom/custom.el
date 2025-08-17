(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-custom-commands
   '(("m" "ALL active TODOs"
      ((agenda "" nil)
       (todo "TODO|STRT|PROJ" nil))
      nil nil)
     ("n" "ALL TODOs"
      ((agenda "" nil)
       (alltodo "" nil))
      nil)
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
      ((agenda ""
               ((org-agenda-span 7)
                (org-agenda-start-on-weekday 1)))
       (todo "ACHIEVED"
             ((org-agenda-overriding-header "✅ ACHIEVEMENTS CETTE SEMAINE")))
       (todo "OBJECTIF|MILESTONE"
             ((org-agenda-overriding-header "📊 ÉTAT DES OBJECTIFS")
              (org-agenda-prefix-format " %i %-12:c [%e] %s")))))
     ("p" "Par priorité"
      ((tags "@priority_high"
             ((org-agenda-overriding-header "🔴 PRIORITÉ HAUTE")))
       (tags "@priority_med"
             ((org-agenda-overriding-header "🟡 PRIORITÉ MOYENNE")))
       (tags "@priority_low"
             ((org-agenda-overriding-header "🟢 PRIORITÉ BASSE")))))))
 '(package-selected-packages '(vterm)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
