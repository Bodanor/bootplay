.intel_syntax noprefix
.code16

halt:

mov ah,0x53        #this is an APM command
mov al, 0x0         #installation check command
xor bx,bx          #device id (0 = APM BIOS)
int 0x15             #call the BIOS function through interrupt 15h
jc APM_error          #if the carry flag is set there was an error
                      #the function was successful
                      #AX = APM version number
                          #AH = Major revision number (in BCD format)
                          #AL = Minor revision number (also BCD format)
                      #BX = ASCII characters "P" (in BH) and "M" (in BL)
                      #CX = APM flags (see the official documentation for more details)

#disconnect from any APM interface
mov ah, 0x53           #this is an APM command
mov al, 0x4           #interface disconnect command
xor bx,bx             #device id (0 = APM BIOS)
int 0x15                #call the BIOS function through interrupt 15h
jc .disconnect_error            #if the carry flag is set see what the fuss is about. 
jmp .no_error

.disconnect_error:        #the error code is in ah.
cmp ah, 0x3            #if the error code is anything but 03h there was an error.
jne APM_error            #the error code 03h means that no interface was connected in the first place.

.no_error:
                         #the function was successful
                         #Nothing is returned.

#connect to an APM interface
mov ah, 0x53           #this is an APM command
mov al, 0x01           #see above description
xor bx,bx             #device id (0 = APM BIOS)
int 0x15                #call the BIOS function through interrupt 15h
jc APM_error             #if the carry flag is set there was an error
                         #the function was successful
                         #The return values are different for each interface.
                         #The Real Mode Interface returns nothing.
                         #See the official documentation for the 
                         #return values for the protected mode interfaces.

#Enable power management for all devices
mov ah, 0x53          #this is an APM command
mov al, 0x8           #Change the state of power management...
mov bx, 0x001         #...on all devices to...
mov cx, 0x001         #...power management on.
int 0x15               #call the BIOS function through interrupt 15h
jc APM_error            #if the carry flag is set there was an error

#Set the power state for all devices
mov ah, 0x53          #this is an APM command
mov al, 0x07          #Set the power state...
mov bx, 0x0001       #...on all devices to...
mov cx, 0x003        #see above
int 0x15               #call the BIOS function through interrupt 15h
jc APM_error            #if the carry flag is set there was an error

APM_error:
hlt

reboot:
    ljmp 0xFFFF:0x0000