#!/bin/env python
import socket
import sys

host = ''
port = int(sys.argv[1])

try:
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
except socket.error as msg:
  print 'Failed to create socket.  Error code: ' + str(msg[0]) + ', Error message: ' + msg[1]
  sys.exit()

print 'Socket created'

try:
    s.bind((host, port))
except socket.error as msg:
    print 'Bind failed.  Error code: ' + str(msg[0]) + ', Error message: ' + msg[1]
    sys.exit()
print 'Socket bind complete'

s.listen(10)
print 'SOcket now listening'

while 1:
    conn, addr = s.accept()
    print 'Connected with ' + addr[0] + ':' + str(addr[1])


s.close()
