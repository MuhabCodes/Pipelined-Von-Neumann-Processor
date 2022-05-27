# all numbers in hex format
# we always start by reset signal
# this is a commented line
.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
10
#you should ignore empty lines

.ORG 1  #this hw interrupt handler
100

.ORG 2  #this is int 0
200

.ORG 3  #this is int 1
250

.ORG 10
LDM R1,10     #R1=10 
JZ 20
STD R2, 1000(R1)
INC R2
DEC R1
JMP 11

.ORG 20

LDM R1, 1
LDM R3, 5
LDM R5, 10
JMP 30

.ORG 30
LDD R4, 1000(R1)
SUB R4, R4, R3
JN 35
OUT R4
JMP 36
OUT R3
INC R1
SUB R6, R1, R5
JN 30


# The pseudocode for the above code is
# R1 = 10
# while (R1 != 0){
#   M[1000+R1] = R2
#   R2++
#   R1--
# }
# R1 = 0
# R3 = 5
# R5 = 9
# do {
#   R4 = M[1000 + R1]
#   if ( R4 >= R3 ){
#       OUT R4
#   }
#   else {
#       OUT R4
#   }
#   R1++
# } while(R1 < R5)