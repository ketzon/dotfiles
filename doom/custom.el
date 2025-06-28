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
      nil)))
 '(package-selected-packages '(vterm)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(setq org-todo-repeat-to-state "LOOP")
