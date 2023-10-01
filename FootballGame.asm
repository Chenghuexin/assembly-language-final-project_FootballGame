INCLUDE Irvine32.inc					
.data									                                      
boundary BYTE "----------------------------------------------------------",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
	     BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
	     BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "-                                                       --",0dh,0ah
		 BYTE "----------------------------------------------------------",0							
											;55*16�̭��i�]���d��
		 
player_0 BYTE "��         ��",0				;player1
player_1 BYTE "=============",0
player_2 BYTE "����  �� ���",0
player_3 BYTE "=============",0
player_4 BYTE "�| �X�X�q �X�X�{",0
player_5 BYTE "�U",0
player_6 BYTE "    �� �w ��  ",0


player_8 BYTE "����������������",0			;player2
player_9 BYTE "����  ��  ���",0
player_10 BYTE "�X�X�X�X�X�X�X",0
player_11 BYTE "�v�X�X�ϡX�X�u",0
player_12 BYTE "�U",0
player_13 BYTE "�� �X��  ",0
																					
ball BYTE '��',0							;�y
Goal BYTE "����������������������",0		;�y��
ClearGoalMark BYTE "           ",0			;�M���y��
ClearBallMark BYTE "  ",0					;�M���y

soccer BYTE "SoccerGame",0					;�C���W��
xGoal BYTE 22								;�y���@�}�l���䪺x��l��m
yGoal BYTE 1								;�y���@�}�l��y��l��m
xBall BYTE 1								;�y���@�}�l����x��l��m
yBall BYTE 16								;�y���@�}�ly��l��m
clearGoal BYTE 32							;�y�����@�}�l�̥k�䪺x�b�A�]���ڭ̦V���ΦV�k���ʤ@��A���O�n��L�л\��1��

GoalColor BYTE black(3*16)					;�y���C��
palyerColor BYTE white(black*16);			;�����H�C��
ballColor BYTE white(3*16)					;�y���C��
Color BYTE white(black*16)					;�����ɭn���C���ܦ^��
GoalClearColor BYTE 3(3*16)					;��y�̲��ʮɡA�n�л\�����@�ӻݭn�л\���C��
leftFlag BYTE 1								;�ΨӧP�_�{�b�y���n�V���٬O�V�k�A����1�ɦV���A����0�ɦV�k
quitFlag BYTE 0								
stopFlag BYTE 0								;����U�ť���StopFlag�|�Q�]��1�A����N�}�l���e�g�X�y
checkFlag1 BYTE 0
checkFlag2 BYTE 0
boundaryColor BYTE white(3*16)				;���a�C��
speed_R_rate DWORD 200						;�y���@�}�l�V�k�����t��(�C�g�i1�y�t��+10)
speed_L_rate DWORD 200						;�y���@�}�l�V�������t��(�C�g�i1�y�t��+10)

clearBall BYTE 1
stopBall BYTE 16

lifeMsg BYTE "Life : " , 0
lifePoint BYTE 3

getMsg BYTE "Goal : ",0
getPoint BYTE 0


First BYTE "start",0						;�}�l(�r)
FirstColor BYTE black(red*16)				;�}�l(�r)�C��
ii BYTE ?									;start�A���ť���i�J�W�h����
jj BYTE ?									;�W�h�����A���ť���i�J�C��
kk BYTE ?									;�O�_�n�A���@���A�O(y)�A�_(n)

Count BYTE 0


Direction_1 BYTE "�� Direction : ",0
Direction_2 BYTE "In this soccer game,the football goal will move right and left.",0
Direction_3 BYTE "Once you shoot the ball into the football goal,the football goal will move more quickly !!",0
Direction_4 BYTE "You have three lives,once you miss the ball three times,the game is over.",0

Control_1 BYTE "�� Control : ",0
Control_2 BYTE "shoot : space",0
Control_3 BYTE "left : a",0
Control_4 BYTE "right : d",0

YourScore BYTE "�� Total score : ",0
RestartChoose_1 BYTE "�� Do you want to try again ? ",0
RestartChoose_2	BYTE "�� YES (y) / NO (n)",0

.code									                                                                       
main proc	
	call GameName										;�L�C���W��
	call Firstplayer1									;�L����1
	call Firstplayer2									;�L����2
	call BallMove										;�ʭ��y������
	call FirstSet										;�Lstart(�r)
									
	whileLoop_1:
		call ReadChar									;��J�r��al(1BYTE)
		mov ii,al
		cmp ii,' '										
		je remove_1										;���p�O���ť���A�N����remove_1�M��������  

		jmp whileLoop_1									;���O�ť���N�@����J
		remove_1:
			call Clrscr									;�M���䭱
				
	call SecondSet										;�L�X�C���W�h

	whileLoop_2:
		call ReadChar									;�r��al(1BYTE)
		mov jj,al
		cmp jj,' '  
		je remove_2										;���p�O���ť���A�N����remove_2�M��������  
		
		jmp whileLoop_2									;���O�ť���N�@����J
		remove_2:
			call Clrscr
	
	call BoundarySet									;�L�X���a
	call Ballset										;�L�X�y
	call GoalSet										;�L�X�y
	call LifeSet										;�L�X�ͩR
	call GoalPointSet									;�L�X�o��

	whileLoop:
		cmp quitFlag , 1								;��quitFlag����1�ɡA�A����Exit_1
		je Exit_1
		cmp stopFlag , 1					
		je  StopMove									;��StopFlag�Q�]��1�A�N����StopMove
		cmp leftFlag , 1								;leftFlag��l��1�A�@�}�l�y���V������
		je MoveLeft
		cmp leftFlag , 0								;leftFlag��0�ɡA�y���V�k����
		je MoveRight

		Exit_1:
			call Clrscr
			mov dl , 43
			mov dh , 10
			call Gotoxy
			mov edx , OFFSET YourScore
			call WriteString
			mov al , getPoint
			call WriteDec

			mov dl , 43
			mov dh , 12
			call Gotoxy
			mov edx , OFFSET RestartChoose_1
			call WriteString

			mov dl , 43
			mov dh , 14
			call Gotoxy
			mov edx , OFFSET RestartChoose_2
			call WriteString
			jmp whileLoop_4										;����whileLoop_4�A�T�{�O�_�A���@���A�O(y)�A�_(n)

		StopMove:												;�}�l�g��
			mov ecx , 7											;�y���y��O7��
			L1:
				call GoToGoal									;�L�X���e�g�����y��
			loop L1

			call Check											;�P�_�O�_���g�i�y��
			call SubLife										;��ͩR
			call AddPoint										;�[����
			call CheckEnd										;��ͩR��0�ɵ����C��
			call accelerate										;����Ʀ��[1�ɡA�t�ץ[��
			mov stopFlag , 0

			call GoalMarkClear
			mov ecx , 8
			L2:
				call BallMarkClear
			loop L2

			
			;mov eax , 20
			;call Delay

			mov xBall , 1										;�g���y����n��l�^��
			mov yBall , 16
			mov clearBall , 1
			call BallSet
			jmp whileLoop

		MoveLeft:
			call LeftGoal
			mov eax, speed_L_rate
			call Delay
			call KeyInput
			jmp whileLoop


		MoveRight:
			call RightGoal
			mov eax, speed_R_rate
			call Delay
			call KeyInput
			jmp whileLoop

	whileLoop_4:
		call ReadChar									;�r��al(1BYTE)
		mov kk,al
		cmp kk,'n'
		je ExitGame
		cmp kk , 'y'
		je RestartGame
		jmp whileLoop_4

		ExitGame:										;(n)�����C��
			mov dl , 0
			mov dh , 27
			call Gotoxy
			exit

		RestartGame:									;(y)�A���@��
			call Clrscr
														;�]���n�����ҥH�n����ƩM�t�ת�l��
			mov lifePoint , 3
			mov getPoint , 0
			mov speed_R_rate , 200					
			mov speed_L_rate , 200
														;���e�C��
			call BoundarySet							
			call Ballset							
			call LifeSet							
			call GoalPointSet						
			mov quitFlag , 0
			jmp whileLoop
main endp

GameName PROC USES eax edx
	mov dl,53											;���Ъ�x			
	mov dh,8											;���Ъ�y
	call Gotoxy											;���ʨ�(x,y)
	mov edx,OFFSET soccer									
	call WriteString									;�L�X�C���W��
	ret
GameName endp


Firstplayer1 PROC USES eax edx							;�}�l�������k��H��
	mov dl,100											;���Ъ�x
	mov dh,19											;���Ъ�y
	call Gotoxy											;���ʨ�(x,y)
	mov edx,OFFSET player_0
	call WriteString									;�L�X
	mov dl,100
	mov dh,20
	call Gotoxy
	mov edx,OFFSET player_1
	call WriteString
	mov dl,100
	mov dh,21
	call Gotoxy
	mov edx,OFFSET player_2
	call WriteString
	mov dl,100
	mov dh,22
	call Gotoxy
	mov edx,OFFSET player_3
	call WriteString
	mov dl,100
	mov dh,23
	call Gotoxy
	mov edx,OFFSET player_4
	call WriteString
	mov dl,106
	mov dh,24
	call Gotoxy
	mov edx,OFFSET player_5
	call WriteString
	mov dl,99
	mov dh,25
	call Gotoxy
	mov edx,OFFSET player_6
	call WriteString
	mov dl,105
	mov dh,26
	call Gotoxy
	ret
Firstplayer1 endp



Firstplayer2 PROC USES eax edx					;�}�l����������H��
	mov dl,6									;���Ъ�x
	mov dh,20									;���Ъ�y
	call Gotoxy									;���ʨ�(x,y)
	mov edx,OFFSET player_8						
	call WriteString							;�L�X
	mov dl,6
	mov dh,21
	call Gotoxy
	mov edx,OFFSET player_9
	call WriteString
	mov dl,6
	mov dh,22
	call Gotoxy
	mov edx,OFFSET player_10
	call WriteString
	mov dl,6
	mov dh,23
	call Gotoxy
	mov edx,OFFSET player_11
	call WriteString
	mov dl,12
	mov dh,24
	call Gotoxy
	mov edx,OFFSET player_12
	call WriteString
	mov dl,11
	mov dh,25
	call Gotoxy
	mov edx,OFFSET player_13
	call WriteString
	ret
Firstplayer2 endp


BallMove PROC USES eax edx						;�Ĥ@�Ӥ����y������

	mov dl,18									;�Ĥ@���y
	mov dh,24
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;�L�X�y
	mov eax,580
	call Delay
	mov dl,18
	mov dh,24
	call Gotoxy
	mov edx,OFFSET ClearBallMark						
	call WriteString							;�M���y

	mov dl,27									;�ĤG���y
	mov dh,22
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;�L�X�y
	mov eax,580
	call Delay
	mov dl,27
	mov dh,22
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;�M���y

	mov dl,40									;�ĤT���y
	mov dh,19
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;�L�X�y
	mov eax,580
	call Delay
	mov dl,40
	mov dh,19
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;�M���y

	mov dl,56									;�ĥ|���y
	mov dh,17
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;�L�X�y
	mov eax,580
	call Delay
	mov dl,56
	mov dh,17
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;�M���y
		
	mov dl,72                                   ;�Ĥ����y
	mov dh,19
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;�L�X�y
	mov eax,580
	call Delay
	mov dl,72
	mov dh,19
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;�M���y

	mov dl,85									;�Ĥ����y
	mov dh,22
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;�L�X�y
	mov eax,580
	call Delay
	mov dl,85
	mov dh,22
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;�M���y

	mov dl,94									;�ĤC���y
	mov dh,24
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;�L�X�y
	mov eax,580
	call Delay
	mov dl,94
	mov dh,24
	call Gotoxy
	mov edx,OFFSET ClearBallMark	
	call WriteString							;�M���y
		
	mov dl,101									;�ĤK���y
	mov dh,25
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;�L�X�y
	mov eax,580
	call Delay
	mov dl,101
	mov dh,25
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;�M���y
	ret

BallMove endp


FirstSet PROC USES eax edx						;��start(�r)���C��Φn�A����L�X��
	mov eax,0									;�n��eax��l��
	mov al,FirstColor							;�]�wstart(�r)�C��
	call setTextColor
	mov dl,55											
	mov dh,12											
	call Gotoxy	
	mov edx,OFFSET First						
	call WriteString							;�L�X��
	mov al,Color								;�C��n�]�^�©��զr
	call setTextColor
	ret
FirstSet endp


SecondSet PROC USES eax edx						;�L�X�W�h
	mov dl,0													
	mov dh,0
	call Gotoxy
	mov edx,OFFSET Direction_1
	call WriteString									

	mov eax,0
	mov dl,12											
	mov dh,2
	call Gotoxy
	mov edx,OFFSET Direction_2
	call WriteString

	mov eax,0
	mov dl,12												
	mov dh,4
	call Gotoxy
	mov edx,OFFSET Direction_3
	call WriteString

	mov dl,12												
	mov dh,6
	call Gotoxy
	mov edx,OFFSET Direction_4
	call WriteString

	
	mov dl,0												
	mov dh,10
	call Gotoxy
	mov edx,OFFSET Control_1
	call WriteString

	mov dl,12											
	mov dh,12
	call Gotoxy
	mov edx,OFFSET Control_2
	call WriteString

	mov dl,12											
	mov dh,14
	call Gotoxy
	mov edx,OFFSET Control_3
	call WriteString

	mov dl,12											
	mov dh,16
	call Gotoxy
	mov edx,OFFSET Control_4
	call WriteString

	ret
SecondSet endp


BoundarySet PROC USES eax edx						;�L�X�a��
	mov eax,0										;�n��eax��l��
	mov al,boundaryColor							;�]�w���a�C��
	call setTextColor
	mov edx,OFFSET boundary
	call WriteString								
	ret
BoundarySet endp


BallSet proc USES eax edx                           ;�L�X�y
	mov eax,0										;�n��eax��l��
	mov al,ballColor								;��y���C��Φn
	call setTextColor
	mov dl,xBall									;�]�w�y��x��l��m
	mov dh,yBall									;�]�w�y��y��l��m
	call Gotoxy										;�N��Ц�m����dl,dh
	mov edx,OFFSET Ball
	call WriteString								
	ret
BallSet endp


GoalSet proc USES eax edx							;�L�X�y��
	mov al,GoalColor								;�]�w�y���C��
	call setTextColor
	mov dl,xGoal									;�]�w�y����x��l��m
	mov dh,yGoal									;�]�w�y����y��l��m
	call Gotoxy										;�N��Ц�m����dl,dh
	mov edx,OFFSET Goal
	call WriteString								;�L�X��
	ret
GoalSet endp


LifeSet proc USES eax edx							;�L�X�ثe�ͩR
	mov eax , 0
	mov dl , 62
	mov dh , 6
	call Gotoxy
	mov edx , OFFSET lifeMsg
	call WriteString
	mov al , lifePoint								;�L�X�ثe�ͩR���X��
	call WriteDec
	ret
LifeSet endp


GoalPointSet proc USES eax edx
	mov eax , 0
	mov dl , 62
	mov dh , 10
	call Gotoxy
	mov edx , OFFSET getMSG							;�L�X�ثe�o�X��
	call WriteString
	mov al , getPoint
	call WriteDec
	ret
GoalPointSet endp


LeftGoal proc USES eax edx							;�y���V������
	dec xGoal										;�V�����A�ҥH�NxGoal��1
	cmp xGoal , 1									;��xGoal������1�ɥN��i�H�V�����ʡA�N����Skip
	jne Move_L

	mov leftFlag , 0								;leftFlag����0�V�k

	Move_L:
		call GoalSet								;�ϥ�GoalSet�ӥ��L�X�y��
		mov dl , clearGoal							;���N���в���ڭ̭n�л\����m
		mov dh , yGoal
		call Gotoxy
		mov al , GoalClearColor						;�л\�����C��
		call setTextColor
		mov al , " "								;�л\�Ŧr��
		call WriteChar
		dec clearGoal								;�]���V�����@��A�ҥH����n��1
		ret
LeftGoal endp

RightGoal proc USES eax edx							;�y���V�k����
	inc clearGoal									;�V�k���[1
	cmp clearGoal , 55								;��clearGoal����55�ɶ}�l�V��
	jne Skip

	mov leftFlag , 1								;leftFlag����1�V��

	Skip:
		inc xGoal									;�y�̪�x�y�Х[1
		call GoalSet								;�L�X�y��
		dec xGoal
		mov dl , xGoal
		mov dh , yGoal
		call Gotoxy
		mov al , GoalClearColor						;�л\�����C��
		call setTextColor
		mov al , " "
		call WriteChar
		inc xGoal
		ret
RightGoal endp


KeyInput proc						;��J�y�����k����
	pushad							;push��stack
	mov eax,10
	call Delay
	call ReadKey
	jz PopR							;���p�S��J���ܴN����PopR
	cmp al,'a'						;��Ja�h����TurnLeft
	je TurnLeft
	cmp al,'d'						;��Jd�h����TurnRight
	je TurnRight
	cmp al,' '						;��J�ťիh����TurnSpace
	je TurnSpace

	TurnLeft:
		call LeftMove
		jmp PopR

	TurnRight:
		call RightMove
		jmp PopR
	
	TurnSpace:
		call SpaceMove
		jmp PopR

	PopR:
		popad							;pop�Xstack
		ret
KeyInput endp



LeftMove proc USES eax edx				;�y������
	cmp xBall , 1						;���p�y��x�y�е���1�A�N���쥪��خءA�N����Stay�A���A����
	je Stay

	mov al , 2							;�y��x�j�p��2
	sub xBall , al						;�V�����ʪ��ܡAxBall�N��2
	call BallSet						;����L�X�y
	mov dl , clearBall					
	mov dh , yBall
	call Gotoxy
	mov al , " "
	call WriteChar
	mov al , " "
	call WriteChar
	mov al , 2
	sub clearBall , al
	ret

	Stay:
		ret
LeftMove endp


RightMove proc USES eax						;�y���k��
	 cmp xBall , 53							;���p�y��x�y�е���53�A�N����k��خ�
	 je Stay

	 mov al , 2								;�y��x�j�p��2
	 add xBall , al							;�V�k���ʪ��ܡAxBall�N�[2
	 call BallSet							;����L�X�y
	 mov dl , clearBall
	 mov dh , yBall
	 call Gotoxy
	 mov al , " "
	 call WriteChar
	 mov al , " "
	 call WriteChar
	 mov al , 2
	 add clearBall , al
	 ret 

	Stay:
		ret
RightMove endp


SpaceMove proc							;�ť���
	mov stopFlag , 1
	ret
SpaceMove endp


GoToGoal proc USES eax edx				;�g��
	mov al , 2							;�y���W�@�檺�Z���M���k���ʤ��@�ˡA�V�W���ʤ@��Z���O1�C�ڭ̨C2�Ӳy�L�X�@�ӡC
	sub yBall , al						;�V�W����yBall��2
	mov dl , xBall						;���ʹ���
	mov dh , yBall
	call Gotoxy
	call BallSet						;�L�X�y
	mov eax , 150						;�y�g�����e���t��
	call Delay		
	ret
GoToGoal endp


Check proc USES eax  edx				;��checkFlag1�McheckFlag2�h�P�_�y�O�_���g�i�y���A���ӳ�����1�ɥN���g�i�y���C
	mov checkFlag1 , 0
	mov checkFlag2 , 0
	mov al , xGoal
	cmp xBall , al
	ja L1								;�y������x�y�ЩM�y������x�y�Ьۤ�A�j�󪺸ܴN�����L1
	ret

	L1:
		mov checkFlag1 , 1
		mov al , clearGoal
		cmp clearBall , al				;�y���k��x�y�ЩM�y���k��x�y�Ьۤ�A�p��h����L2
		jb L2
		ret
	L2:
		mov checkFlag2 , 1
		ret
	
Check endp


SubLife proc USES eax					;���ͩR				
	mov eax , 0
	mov al , checkFlag1						
	and al , checkFlag2
	cmp al , 0
	je renew
	ret
	renew:
		dec lifePoint
		call LifeSet
		ret
Sublife endp



AddPoint proc USES eax					;�[����
	mov eax , 0
	mov al , checkFlag1
	and al , checkFlag2
	cmp al , 1
	je renew
	ret
	renew:
		inc getPoint
		call GoalPointSet
		ret
AddPoint endp


GoalMarkClear proc USES edx
	mov dl , xGoal
	mov dh , yGoal
	call Gotoxy
	mov edx , OFFSET ClearGoalMark
	call WriteString
	ret
GoalMarkClear endp


BallMarkClear proc USES eax edx
	mov dl , xBall
	mov dh , yBall
	call Gotoxy
	mov al , " "
	call WriteChar
	mov al , " "
	call WriteChar
	mov al , 2
	add yBall , al
	ret
BallMarkClear endp

CheckEnd proc USES eax edx
	cmp lifePoint , 0
	je gg

	ret

	gg:
		mov quitFlag , 1
		mov dl,0
		mov dh,19
		call Gotoxy
		mov al,Color				;�n�ܦ^��Ӫ��C��
		call setTextColor
		ret
CheckEnd endp


accelerate proc USES eax edx		;�y�����ʥ[��
	mov eax , 0
	mov al , checkFlag1
	and al , checkFlag2
	cmp al , 1						;���g�i�y�� al����1
	je speed_up
	
	ret

	speed_up:
		cmp speed_R_rate,0
		je no_accelerate			;���p�t�פw�g����0�A�N����F�A���� no_accelerate

		sub speed_R_rate,10			;�@����10
		sub speed_L_rate,10

		no_accelerate:
		ret
accelerate endp

end main
