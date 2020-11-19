;; Get the auth token from Local
(require 'json)

(setq lwp-sites-buffer-name "*Local Sites*")
(setq lwp-sites-buffer (get-buffer-create lwp-sites-buffer-name))

(message "\nReading Local GraphQL config.")

;; Where Local stores the graphql config. This is the macOS default which is different than Win or Linux.
(setq lwp-graphql-config
     (json-read-file "~/Library/Application Support/Local/graphql-connection-info.json"))


(message "Setting Local GraphQL variables.")

(setq lwp-graphql-authToken		(cdr (assoc 'authToken lwp-graphql-config)))
(setq lwp-graphql-port			(cdr (assoc 'port lwp-graphql-config)))
(setq lwp-graphql-url			(cdr (assoc 'url lwp-graphql-config)))
(setq lwp-graphql-subscriptionUrl	(cdr (assoc 'subscriptionUrl lwp-graphql-config)))

(message (format "lwp-graphql-authToken: %s\nlwp-graphql-port: %s\nlwp-graphql-url: %s\nlwp-graphql-subscriptionUrl: %s\n"
		 lwp-graphql-authToken
		 lwp-graphql-port
		 lwp-graphql-url
		 lwp-graphql-subscriptionUrl))


;; See: https://tkf.github.io/emacs-request/
;;   refactorz meee!
;;
;; This gets the job done, but I need to refactor to:
;; 1. use the authToken var above
;; 2. Open response in new, dedicated buffer
;; 3. Use dedicated functions for making the specific requests
;; 4. Guard against users not having the request package installed
(request
  lwp-graphql-url
  :type "POST"
  :headers `(
	     ("Content-Type" . "application/json")
	     ("Authorization" . ,(format "Bearer %s" lwp-graphql-authToken))
	     )
  :data (json-encode '(("query" . "{
    sites {
	id
	host
	status
    }
  }")))
  :parser 'json-read
  :complete (cl-function
	     (lambda (&key response &allow-other-keys)
	       (set-buffer lwp-sites-buffer)
	       (insert (format "%s" (request-response-data response)))
	    )))

