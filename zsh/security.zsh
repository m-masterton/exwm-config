# SECURITY

# av aliases
alias checkrootkits="sudo rkhunter --update; sudo rkhunter --propupd; sudo rkhunter --sk --check"
alias checkvirus="clamscan --recursive=yes --infected /home"
alias updateantivirus="sudo freshclam"
