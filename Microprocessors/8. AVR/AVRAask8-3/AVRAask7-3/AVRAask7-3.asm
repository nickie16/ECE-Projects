.include "m16def.inc"

    ldi r24,low(RAMEND) ;initialize stack pointer
    out spl,r24
    ldi r24,high(RAMEND)
    out sph,r24
    clr r17            
    out DDRB, r17   ; PORTB as input. 
    ser r26         ; ������������ ��� PORT�
    out DDRA , r26  ; ��� �����
    ldi r17, 0xfc
    out DDRD, r17 ; PD2-7 as output (LCD screen).
    rcall lcd_init ; Initialize LCD screen.

flash:
   rcall wipe_screen ; Perform screen wipe.
   in r17,PINB	    ; input in r17
  ; push r17      ; Save input number on stack. ; xreiazetai ??

   ldi r24,'1'
   sbrs r17,7    ; Skip if bit 7 in r17 is set
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,6
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,5
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,4
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,3
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,2
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,1
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'1'
   sbrs r17,0
   ldi r24,'0'
   rcall lcd_data
   ldi r24,'='
   rcall lcd_data
   ldi r24,'+'	
   sbrc r17,7      ; Skip if bit 7 in r17 cleared
   rcall _complement_
   rcall lcd_data
   ldi r18,0       ; initialize hundrens
   ldi r19,0       ; initialize decades
                    ; BCD



tag1:
    cpi r17,100
	brlo tag2
	subi r17,100
	ldi r18,1
 tag2:
    cpi r17,10
	brlo tag3
	subi r17,10
	inc  r19
	rjmp tag2
tag3:
    ldi r16,48
    add r18,r16
	add r19,r16
	add r17,r16 
    mov r24, r18
	cpi r24, 48       ; if it is zero don't print it
	breq tag4
    rcall lcd_data     
	mov r24 , r19
    rcall lcd_data 
	rjmp tag5
tag4:
    mov r24 , r19
	cpi r24, 48       ; if it is zero don't print it
	breq tag5
    rcall lcd_data
tag5:
    mov r24 , r17
	rcall lcd_data
    rjmp flash

_complement_:       ; two's complement
    com r17
	inc r17
	ldi r24,'-'
	ret

lcd_init:
  ldi r24 ,40 ; ���� � �������� ��� lcd ������������� ��
  ldi r25 ,0 ; ����� ������� ��� ���� ��� ������������.
  rcall wait_msec ; ������� 40 msec ����� ���� �� �����������.
  ldi r24 ,0x30 ; ������ ��������� �� 8 bit mode
  out PORTD ,r24 ; ������ ��� �������� �� ������� �������
  sbi PORTD ,PD3 ; ��� �� ���������� ������� ��� �������
  cbi PORTD ,PD3 ; ��� ������, � ������ ������������ ��� �����
  ldi r24 ,39
  ldi r25 ,0 ; ��� � �������� ��� ������ ��������� �� 8-bit mode
  rcall wait_usec ; ��� �� ������ ������, ���� �� � �������� ���� ����������
                  ; ������� 4 bit �� ������� �� ���������� 8 bit
  ldi r24 ,0x30
  out PORTD ,r24
  sbi PORTD ,PD3
  cbi PORTD ,PD3
  ldi r24 ,39
  ldi r25 ,0
  rcall wait_usec

 ldi r24 ,0x20 ; ������ �� 4-bit mode
 out PORTD ,r24
 sbi PORTD ,PD3
 cbi PORTD ,PD3
 ldi r24 ,39
 ldi r25 ,0
 rcall wait_usec

 ldi r24 ,0x28 ; ������� ���������� �������� 5x8 ��������
 rcall lcd_command ; ��� �������� ��� ������� ���� �����
 ldi r24 ,0x0c ; ������������ ��� ������, �������� ��� �������
 rcall lcd_command
 ldi r24 ,0x01 ; ���������� ��� ������
 rcall lcd_command
 ldi r24 ,low(1530)
 ldi r25 ,high(1530)
 rcall wait_usec

 ldi r24 ,0x06 ; ������������ ��������� ������� ���� 1 ��� ����������
 rcall lcd_command ; ��� ����� ������������ ���� ������� ����������� ���
                   ; �������������� ��� ��������� ��������� ��� ������
 ret
lcd_command:
  cbi PORTD ,PD2 ; ������� ��� ���������� ������� (PD2=0)
  rcall write_2_nibbles ; �������� ��� ������� ��� ������� 39�sec
  ldi r24 ,39 ; ��� ��� ���������� ��� ��������� ��� ��� ��� ������� ��� lcd.
  ldi r25 ,0 ; ���.: �������� ��� �������, �� clear display ��� return home,
  rcall wait_usec ; ��� �������� ��������� ���������� ������� ��������.
  ret

lcd_data:
 sbi PORTD ,PD2 ; ������� ��� ���������� ��������� (PD2=1)
 rcall write_2_nibbles ; �������� ��� byte
 ldi r24 ,43 ; ������� 43�sec ����� �� ����������� � ����
 ldi r25 ,0 ; ��� ��������� ��� ��� ������� ��� lcd
 rcall wait_usec
 ret

write_2_nibbles:
  push r24 ; ������� �� 4 MSB
  in r25 ,PIND ; ����������� �� 4 LSB ��� �� �������������
  andi r25 ,0x0f ; ��� �� ��� ��������� ��� ����� ����������� ���������
  andi r24 ,0xf0 ; ������������� �� 4 MSB ���
  add r24 ,r25 ; ������������ �� �� ������������ 4 LSB
  out PORTD ,r24 ; ��� �������� ���� �����
  sbi PORTD ,PD3 ; ������������� ������ �nable ���� ��������� PD3
  cbi PORTD ,PD3 ; PD3=1 ��� ���� PD3=0
  pop r24 ; ������� �� 4 LSB. ��������� �� byte.
  swap r24 ; ������������� �� 4 MSB �� �� 4 LSB
  andi r24 ,0xf0 ; ��� �� ��� ����� ���� �������������
  add r24 ,r25
  out PORTD ,r24
  sbi PORTD ,PD3 ; ���� ������ �nable
  cbi PORTD ,PD3
  ret

; == wipe_screen ==
; Wipes the LCD screen. Assumes screen controller has initialized correctly.
; Note: Approx. 1.5sec delay caused as a result of command processing.
; MODIFIES: r24, r25
wipe_screen:
  ldi r24, 0x01 ; Issue a screen-wipe command.
  rcall lcd_command ;
  ldi r24, low(1530) ; Delay for 1.5msec until command is processed.
  ldi r25, high(1530)
  rcall wait_usec
  ret ; Return to caller.

wait_usec:
 sbiw r24 ,1 ; 2 ������ (0.250 �sec)
 nop ; 1 ������ (0.125 �sec)
 nop ; 1 ������ (0.125 �sec)
 nop ; 1 ������ (0.125 �sec)
 nop ; 1 ������ (0.125 �sec)
 brne wait_usec ; 1 � 2 ������ (0.125 � 0.250 �sec)
 ret ; 4 ������ (0.500 �sec)

wait_msec:
 push r24 ; 2 ������ (0.250 �sec)
 push r25 ; 2 ������
 ldi r24 , low(998) ; ������� ��� �����. r25:r24 �� 998 (1 ������ - 0.125 �sec)
 ldi r25 , high(998) ; 1 ������ (0.125 �sec)
 rcall wait_usec ; 3 ������ (0.375 �sec), �������� �������� ����������� 998.375 �sec
 pop r25 ; 2 ������ (0.250 �sec)
 pop r24 ; 2 ������
 sbiw r24 , 1 ; 2 ������
 brne wait_msec ; 1 � 2 ������ (0.125 � 0.25
 ret ; 4 ������ (0.500 �sec)


