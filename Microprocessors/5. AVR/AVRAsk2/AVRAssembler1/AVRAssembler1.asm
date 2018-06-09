.include "m16def.inc"
ldi r24,low(RAMEND) ;initialize stack pointer
out spl,r24
ldi r24,high(RAMEND)
out sph,r24
clr r17            ; ������������ ��� PORTB   
out DDRB , r17     ; ��� ������
ser r26            ; ������������ ��� PORTA
out DDRA , r26     ; ��� �����
flash: 
  in r17,PINB
  mov r16,r17
  andi r16,0x0f ; mask for 4 LSB
  andi r17,0xf0 ;mask for 4 MSB
  mov r15,r17
  lsr r15       ;or swap r15
  lsr r15
  lsr r15
  lsr r15
  add r15,r15
  inc r15
  add r16,r16
  inc r16

  rcall on         ; ����� �� LEDs
  rcall off          ; ����� �� LEDs
  rjmp flash         ; ���������
                   ; ���������� ��� �� ������� �� LEDs
on: 
 ldi r20,50
 mul r15,r20
 mov r24 ,r0
 mov r25 ,r1
 ser r26        ; ���� �� ���� ������ ��� LED
 out PORTA , r26
 rcall wait_msec
 ret                ; ������ ��� ����� ���������
                   ; ���������� ��� �� ������� �� LEDs
off: 
 mul r16,r20
 mov r24 ,r0
 mov r25 ,r1
 clr r26       ; �������� �� ���� ������ ��� LED
 out PORTA , r26
 rcall wait_msec
 ret                ; ������ ��� ����� ���������

wait_usec:
sbiw r24 ,1 ; 2 ������ (0.250 �sec)
nop ; 1 ������ (0.125 �sec)
nop ; 1 ������ (0.125 �sec)
nop ; 1 ������ (0.125 �sec)
nop ; 1 ������ (0.125 �sec)
brne wait_usec ; 1 � 2 ������ (0.125 � 0.250 �sec)
ret 

wait_msec:
 push r24 ; 2 ������ (0.250 �sec)
 push r25 ; 2 ������
 ldi r24 , low(998) ; ������� ��� �����. r25:r24 �� 998 (1 ������ - 0.125 �sec)
 ldi r25 , high(998) ; 1 ������ (0.125 �sec)
 rcall wait_usec ; 3 ������ (0.375 �sec), �������� �������� ����������� 998.375 �sec
 pop r25 ; 2 ������ (0.250 �sec)
 pop r24 ; 2 ������
 sbiw r24 , 1 ; 2 ������
 brne wait_msec ; 1 � 2 ������ (0.125 � 0.250 �sec)
 ret ; 4 ������ (0.500 �sec)

