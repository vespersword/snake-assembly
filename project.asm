org 100h

.data
size equ 5
body dw size dup(0)
tail dw ?             
up equ 48h
left equ 4bh
down equ 50h
right equ 4dh
direction db right
wait_time dw 0  

.code

start:
mov ah, 00h
int 16h

game:          
;printing head
mov dx,body[0]

;cursor
mov ah,02h
int 10h

;printing '#'
mov al,'#'                      
mov ah,09h
mov bl,0bh
mov cx,1
int 10h
                   
mov ax,body[size*2 - 2]
mov tail,ax

call move_snake:
;removing tail
mov dx,tail
mov ah,02h
int 10h                   

mov al, ' '
mov ah,09h
mov bl,0eh
mov cx,1
int 10h


check_for_key:
mov ah,01h
int 16h
jz no_key

mov ah,00h
int 16h

mov direction, ah

no_key:
mov ah, 00h
int 1ah
cmp dx, wait_time
jb check_for_key
add dx, 4
mov wait_time, dx

jmp game

move_snake proc 
mov ax, 40h
mov es, ax

; point di to tail
mov di, size * 2 - 2
mov cx, size-1
move_array:
mov ax, body[di-2]
mov body[di], ax
sub di, 2
loop move_array
         
cmp direction,up
je move_up
cmp direction,left
je move_left        
cmp direction,down
je move_down
cmp direction,right
je move_right

jmp return

move_up:
mov al, b.body[1]
dec al
mov b.body[1], al
cmp al, -1
jne return
mov al, es:[84h]
mov b.body[1], al
jmp return

move_left:
mov al,b.body[0]
dec al
mov b.body[0], al
cmp al, -1
jne return       
mov al, es:[4ah]
dec al
mov b.body[0], al
jmp return

move_down:    
mov al, b.body[1]
inc al
mov b.body[1], al
cmp al, es:[84h]
jbe return
mov b.body[1], 0
jmp return

move_right: 
mov al, b.body[0]
inc al
mov b.body[0], al
cmp al, es:[4ah]   
jb return
mov b.body[0], 0
jmp return


return:
ret
move_snake endp       
