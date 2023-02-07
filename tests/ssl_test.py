import socket
import ssl

context = ssl.create_default_context()
context.check_hostname = False # Debian and Ubuntu containers ship with no certs
context.verify_mode = ssl.CERT_NONE

hostname = 'www.google.com'

print(ssl.get_default_verify_paths())

with socket.create_connection((hostname, 443)) as sock:
    with context.wrap_socket(sock, server_hostname=hostname) as ssock:
		        print(ssock.version())
