# Bash scripting

Previously, tasks involved configuring VMs manually.
This task had us writing bash scripts for this configuration.

## DNS


## DHCP


## Gateway


## File server


## Node apps


## Master script

## Improvements

Our approach has left a great deal to refine; much of the scripts require user input. Entering passwords when prompted, accepting the fingerprint of a new host when connecting via SSH, or exiting out of an interactive shell, are all automatable.

Without the required permissions for a machine, one can't generate SSH keys to avoid connecting with a password. Hard-coding passwords in a script is, obviously, a massive security flaw. Storing passwords in environment variables is also insecure. An alternative would be to encrypt passwords using a tool like [OpenSSL](https://www.openssl.org/) and use the utility [sshpass](https://linux.die.net/man/1/sshpass) to supply the password non-interactively. This method does require an extra password, used in the encryption & decryption with OpenSSL. But, storing this password in a file, hidden, with appropriate permissions, means that it's never accessible to others.

[OpenSSH 7.6](https://www.openssh.com/txt/release-7.6) added a setting for accepting new host keys by default, but this seems inadequate and insecure. SSH key fingerprints are distributable by DNS, which appears to be an optimal solution. It is documented in an RFC here: [Using DNS to Securely Publish Secure Shell (SSH) Key Fingerprints](https://datatracker.ietf.org/doc/html/rfc4255).

Seemingly our applications are run in the background, but the output displays on the terminal. Redirecting output to a log file or similar should spare the requirement for a user to exit the interactive shell prompt. Utilising the line ```http-server > output.txt 2>&1 &``` allows for running the server in the background and redirects output to a text file. The sterr is redirected to stdout.
