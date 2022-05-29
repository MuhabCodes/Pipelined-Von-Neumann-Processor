# all numbers in hex format
# we always start by reset signal
# this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
A0
#you should ignore empty lines

.ORG 1  #this hw interrupt handler
100

.ORG 2  #this is int 0
200

.ORG 3  #this is int 1
250

.ORG A0

IN R1         #R1= 6, C --> 0, N -->0, Z-->0
NOP
NOP
NOP
NOP
NOP
NOP
NOP
INC R1