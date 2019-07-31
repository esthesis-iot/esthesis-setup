# esthes.is - Development environment setup
To quickly setup all necessary infrastructure for your development
environment you can use the Docker containers specified in this project.

## Starting up the environment
`docker-compose up -d`

## Shutting down the environment
`docker-compose down`

## URL redirecting
Email notifications or other in-app links may contain links to the
production environment. To efficiently handle such links without having
to manually rewrite them you can install the
[Requestly](https://chrome.google.com/webstore/detail/requestly-redirect-url-mo/mdnleldcmiljblolnjhpnblkcekpdkpa?hl=en)
extension in your Chrome browser. Once Requestly is installed, you can
use the `requestly_rules.txt` file in this repo to automatically setup
all necessary rules.
