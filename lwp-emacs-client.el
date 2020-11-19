;; Get the auth token from Local
(require 'json)

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
  :headers '(
	     ("Content-Type" . "application/json")
	     ("Authorization" . "Bearer kTe4tOu8J9glqG8bDklYey7nx623qXO+yh54duXUExJ1XeJGxvFOo6MAdOWdP5CBepTekj7p6if06hsyF4Zwcr0BcseoWratYlH39aoShtrJElJetMsPVX8+S3N9WToE")
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
	       (message "Done: %s" (request-response-data response)))))

