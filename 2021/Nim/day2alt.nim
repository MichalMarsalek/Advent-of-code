var x,y,aim = 0
proc forward(a=0)= x+=a; y+=aim*a
proc up(a=0)=      aim-=a
proc down(a=0)=    aim+=a
include "inputs\\day2.in"
echo (x*aim, x*y)