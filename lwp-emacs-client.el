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

