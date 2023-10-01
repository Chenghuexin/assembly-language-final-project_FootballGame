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
											;55*16裡面可跑的範圍
		 
player_0 BYTE "◣         ◢",0				;player1
player_1 BYTE "=============",0
player_2 BYTE "∥⊙  ﹎ ⊙∥",0
player_3 BYTE "=============",0
player_4 BYTE "└ ——┼ ——┐",0
player_5 BYTE "｜",0
player_6 BYTE "    ╰ ─ ╲  ",0


player_8 BYTE "””””””””",0			;player2
player_9 BYTE "∥⊕  ＿  ⊕∥",0
player_10 BYTE "———————",0
player_11 BYTE "」——＋——「",0
player_12 BYTE "｜",0
player_13 BYTE "╱ —╯  ",0
																					
ball BYTE '●',0							;球
Goal BYTE "╔═════════╗",0		;球門
ClearGoalMark BYTE "           ",0			;清除球門
ClearBallMark BYTE "  ",0					;清除球

soccer BYTE "SoccerGame",0					;遊戲名稱
xGoal BYTE 22								;球門一開始左邊的x初始位置
yGoal BYTE 1								;球門一開始的y初始位置
xBall BYTE 1								;球的一開始左邊x初始位置
yBall BYTE 16								;球的一開始y初始位置
clearGoal BYTE 32							;球門的一開始最右邊的x軸，因為我們向左或向右移動一格，都是要把他覆蓋掉1格

GoalColor BYTE black(3*16)					;球門顏色
palyerColor BYTE white(black*16);			;機器人顏色
ballColor BYTE white(3*16)					;球的顏色
Color BYTE white(black*16)					;結束時要把顏色變回來
GoalClearColor BYTE 3(3*16)					;當球們移動時，要覆蓋的那一個需要覆蓋的顏色
leftFlag BYTE 1								;用來判斷現在球門要向左還是向右，當等於1時向左，等於0時向右
quitFlag BYTE 0								
stopFlag BYTE 0								;當按下空白鍵StopFlag會被設為1，之後就開始往前射出球
checkFlag1 BYTE 0
checkFlag2 BYTE 0
boundaryColor BYTE white(3*16)				;場地顏色
speed_R_rate DWORD 200						;球門一開始向右移的速度(每射進1球速度+10)
speed_L_rate DWORD 200						;球門一開始向左移的速度(每射進1球速度+10)

clearBall BYTE 1
stopBall BYTE 16

lifeMsg BYTE "Life : " , 0
lifePoint BYTE 3

getMsg BYTE "Goal : ",0
getPoint BYTE 0


First BYTE "start",0						;開始(字)
FirstColor BYTE black(red*16)				;開始(字)顏色
ii BYTE ?									;start，按空白鍵進入規則說明
jj BYTE ?									;規則說明，按空白鍵進入遊戲
kk BYTE ?									;是否要再玩一次，是(y)，否(n)

Count BYTE 0


Direction_1 BYTE "★ Direction : ",0
Direction_2 BYTE "In this soccer game,the football goal will move right and left.",0
Direction_3 BYTE "Once you shoot the ball into the football goal,the football goal will move more quickly !!",0
Direction_4 BYTE "You have three lives,once you miss the ball three times,the game is over.",0

Control_1 BYTE "★ Control : ",0
Control_2 BYTE "shoot : space",0
Control_3 BYTE "left : a",0
Control_4 BYTE "right : d",0

YourScore BYTE "★ Total score : ",0
RestartChoose_1 BYTE "★ Do you want to try again ? ",0
RestartChoose_2	BYTE "★ YES (y) / NO (n)",0

.code									                                                                       
main proc	
	call GameName										;印遊戲名稱
	call Firstplayer1									;印角色1
	call Firstplayer2									;印角色2
	call BallMove										;封面球的移動
	call FirstSet										;印start(字)
									
	whileLoop_1:
		call ReadChar									;輸入字元al(1BYTE)
		mov ii,al
		cmp ii,' '										
		je remove_1										;假如是按空白鍵，就跳到remove_1清除本介面  

		jmp whileLoop_1									;不是空白鍵就一直輸入
		remove_1:
			call Clrscr									;清空鍵面
				
	call SecondSet										;印出遊戲規則

	whileLoop_2:
		call ReadChar									;字元al(1BYTE)
		mov jj,al
		cmp jj,' '  
		je remove_2										;假如是按空白鍵，就跳到remove_2清除本介面  
		
		jmp whileLoop_2									;不是空白鍵就一直輸入
		remove_2:
			call Clrscr
	
	call BoundarySet									;印出場地
	call Ballset										;印出球
	call GoalSet										;印出球
	call LifeSet										;印出生命
	call GoalPointSet									;印出得分

	whileLoop:
		cmp quitFlag , 1								;當quitFlag等於1時，，跳到Exit_1
		je Exit_1
		cmp stopFlag , 1					
		je  StopMove									;當StopFlag被設為1，就跳到StopMove
		cmp leftFlag , 1								;leftFlag初始為1，一開始球門向左移動
		je MoveLeft
		cmp leftFlag , 0								;leftFlag為0時，球門向右移動
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
			jmp whileLoop_4										;跳到whileLoop_4，確認是否再玩一次，是(y)，否(n)

		StopMove:												;開始射門
			mov ecx , 7											;球的軌跡是7顆
			L1:
				call GoToGoal									;印出往前射門的軌跡
			loop L1

			call Check											;判斷是否有射進球門
			call SubLife										;減生命
			call AddPoint										;加分數
			call CheckEnd										;當生命為0時結束遊戲
			call accelerate										;當分數有加1時，速度加快
			mov stopFlag , 0

			call GoalMarkClear
			mov ecx , 8
			L2:
				call BallMarkClear
			loop L2

			
			;mov eax , 20
			;call Delay

			mov xBall , 1										;射完球之後要初始回來
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
		call ReadChar									;字元al(1BYTE)
		mov kk,al
		cmp kk,'n'
		je ExitGame
		cmp kk , 'y'
		je RestartGame
		jmp whileLoop_4

		ExitGame:										;(n)結束遊戲
			mov dl , 0
			mov dh , 27
			call Gotoxy
			exit

		RestartGame:									;(y)再玩一次
			call Clrscr
														;因為要重玩所以要把分數和速度初始化
			mov lifePoint , 3
			mov getPoint , 0
			mov speed_R_rate , 200					
			mov speed_L_rate , 200
														;重畫遊戲
			call BoundarySet							
			call Ballset							
			call LifeSet							
			call GoalPointSet						
			mov quitFlag , 0
			jmp whileLoop
main endp

GameName PROC USES eax edx
	mov dl,53											;鼠標的x			
	mov dh,8											;鼠標的y
	call Gotoxy											;移動到(x,y)
	mov edx,OFFSET soccer									
	call WriteString									;印出遊戲名稱
	ret
GameName endp


Firstplayer1 PROC USES eax edx							;開始介面的右邊人物
	mov dl,100											;鼠標的x
	mov dh,19											;鼠標的y
	call Gotoxy											;移動到(x,y)
	mov edx,OFFSET player_0
	call WriteString									;印出
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



Firstplayer2 PROC USES eax edx					;開始介面的左邊人物
	mov dl,6									;鼠標的x
	mov dh,20									;鼠標的y
	call Gotoxy									;移動到(x,y)
	mov edx,OFFSET player_8						
	call WriteString							;印出
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


BallMove PROC USES eax edx						;第一個介面球的移動

	mov dl,18									;第一顆球
	mov dh,24
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;印出球
	mov eax,580
	call Delay
	mov dl,18
	mov dh,24
	call Gotoxy
	mov edx,OFFSET ClearBallMark						
	call WriteString							;清除球

	mov dl,27									;第二顆球
	mov dh,22
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;印出球
	mov eax,580
	call Delay
	mov dl,27
	mov dh,22
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;清除球

	mov dl,40									;第三顆球
	mov dh,19
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;印出球
	mov eax,580
	call Delay
	mov dl,40
	mov dh,19
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;清除球

	mov dl,56									;第四顆球
	mov dh,17
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;印出球
	mov eax,580
	call Delay
	mov dl,56
	mov dh,17
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;清除球
		
	mov dl,72                                   ;第五顆球
	mov dh,19
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;印出球
	mov eax,580
	call Delay
	mov dl,72
	mov dh,19
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;清除球

	mov dl,85									;第六顆球
	mov dh,22
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;印出球
	mov eax,580
	call Delay
	mov dl,85
	mov dh,22
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;清除球

	mov dl,94									;第七顆球
	mov dh,24
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;印出球
	mov eax,580
	call Delay
	mov dl,94
	mov dh,24
	call Gotoxy
	mov edx,OFFSET ClearBallMark	
	call WriteString							;清除球
		
	mov dl,101									;第八顆球
	mov dh,25
	call Gotoxy
	mov edx,OFFSET ball
	call WriteString							;印出球
	mov eax,580
	call Delay
	mov dl,101
	mov dh,25
	call Gotoxy
	mov edx,OFFSET ClearBallMark
	call WriteString							;清除球
	ret

BallMove endp


FirstSet PROC USES eax edx						;把start(字)的顏色用好，之後印出來
	mov eax,0									;要給eax初始值
	mov al,FirstColor							;設定start(字)顏色
	call setTextColor
	mov dl,55											
	mov dh,12											
	call Gotoxy	
	mov edx,OFFSET First						
	call WriteString							;印出來
	mov al,Color								;顏色要設回黑底白字
	call setTextColor
	ret
FirstSet endp


SecondSet PROC USES eax edx						;印出規則
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


BoundarySet PROC USES eax edx						;印出地圖
	mov eax,0										;要給eax初始值
	mov al,boundaryColor							;設定場地顏色
	call setTextColor
	mov edx,OFFSET boundary
	call WriteString								
	ret
BoundarySet endp


BallSet proc USES eax edx                           ;印出球
	mov eax,0										;要給eax初始值
	mov al,ballColor								;把球的顏色用好
	call setTextColor
	mov dl,xBall									;設定球的x初始位置
	mov dh,yBall									;設定球的y初始位置
	call Gotoxy										;將游標位置移到dl,dh
	mov edx,OFFSET Ball
	call WriteString								
	ret
BallSet endp


GoalSet proc USES eax edx							;印出球門
	mov al,GoalColor								;設定球門顏色
	call setTextColor
	mov dl,xGoal									;設定球門的x初始位置
	mov dh,yGoal									;設定球門的y初始位置
	call Gotoxy										;將游標位置移到dl,dh
	mov edx,OFFSET Goal
	call WriteString								;印出來
	ret
GoalSet endp


LifeSet proc USES eax edx							;印出目前生命
	mov eax , 0
	mov dl , 62
	mov dh , 6
	call Gotoxy
	mov edx , OFFSET lifeMsg
	call WriteString
	mov al , lifePoint								;印出目前生命有幾條
	call WriteDec
	ret
LifeSet endp


GoalPointSet proc USES eax edx
	mov eax , 0
	mov dl , 62
	mov dh , 10
	call Gotoxy
	mov edx , OFFSET getMSG							;印出目前得幾分
	call WriteString
	mov al , getPoint
	call WriteDec
	ret
GoalPointSet endp


LeftGoal proc USES eax edx							;球門向左移動
	dec xGoal										;向左移，所以將xGoal減1
	cmp xGoal , 1									;當xGoal不等於1時代表可以向左移動，就跳到Skip
	jne Move_L

	mov leftFlag , 0								;leftFlag等於0向右

	Move_L:
		call GoalSet								;使用GoalSet來先印出球門
		mov dl , clearGoal							;先將鼠標移到我們要覆蓋的位置
		mov dh , yGoal
		call Gotoxy
		mov al , GoalClearColor						;覆蓋掉的顏色
		call setTextColor
		mov al , " "								;覆蓋空字元
		call WriteChar
		dec clearGoal								;因為向左移一格，所以之後要減1
		ret
LeftGoal endp

RightGoal proc USES eax edx							;球門向右移動
	inc clearGoal									;向右移加1
	cmp clearGoal , 55								;當clearGoal等於55時開始向左
	jne Skip

	mov leftFlag , 1								;leftFlag等於1向左

	Skip:
		inc xGoal									;球們的x座標加1
		call GoalSet								;印出球門
		dec xGoal
		mov dl , xGoal
		mov dh , yGoal
		call Gotoxy
		mov al , GoalClearColor						;覆蓋掉的顏色
		call setTextColor
		mov al , " "
		call WriteChar
		inc xGoal
		ret
RightGoal endp


KeyInput proc						;輸入球的左右移動
	pushad							;push到stack
	mov eax,10
	call Delay
	call ReadKey
	jz PopR							;假如沒輸入的話就跳到PopR
	cmp al,'a'						;輸入a則跳到TurnLeft
	je TurnLeft
	cmp al,'d'						;輸入d則跳到TurnRight
	je TurnRight
	cmp al,' '						;輸入空白則跳到TurnSpace
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
		popad							;pop出stack
		ret
KeyInput endp



LeftMove proc USES eax edx				;球的左移
	cmp xBall , 1						;假如球的x座標等於1，代表撞到左邊框框，就跳到Stay，不再移動
	je Stay

	mov al , 2							;球的x大小為2
	sub xBall , al						;向左移動的話，xBall就減2
	call BallSet						;之後印出球
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


RightMove proc USES eax						;球的右移
	 cmp xBall , 53							;假如球的x座標等於53，代表撞到右邊框框
	 je Stay

	 mov al , 2								;球的x大小為2
	 add xBall , al							;向右移動的話，xBall就加2
	 call BallSet							;之後印出球
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


SpaceMove proc							;空白鍵
	mov stopFlag , 1
	ret
SpaceMove endp


GoToGoal proc USES eax edx				;射門
	mov al , 2							;球往上一格的距離和左右移動不一樣，向上移動一格距離是1。我們每2個球印出一個。
	sub yBall , al						;向上移動yBall減2
	mov dl , xBall						;移動鼠標
	mov dh , yBall
	call Gotoxy
	call BallSet						;印出球
	mov eax , 150						;球射門往前的速度
	call Delay		
	ret
GoToGoal endp


Check proc USES eax  edx				;用checkFlag1和checkFlag2去判斷球是否有射進球門，當兩個都等於1時代表有射進球門。
	mov checkFlag1 , 0
	mov checkFlag2 , 0
	mov al , xGoal
	cmp xBall , al
	ja L1								;球的左邊x座標和球門左邊x座標相比，大於的話就跳轉到L1
	ret

	L1:
		mov checkFlag1 , 1
		mov al , clearGoal
		cmp clearBall , al				;球的右邊x座標和球門右邊x座標相比，小於則跳到L2
		jb L2
		ret
	L2:
		mov checkFlag2 , 1
		ret
	
Check endp


SubLife proc USES eax					;扣生命				
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



AddPoint proc USES eax					;加分數
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
		mov al,Color				;要變回原來的顏色
		call setTextColor
		ret
CheckEnd endp


accelerate proc USES eax edx		;球門移動加快
	mov eax , 0
	mov al , checkFlag1
	and al , checkFlag2
	cmp al , 1						;有射進球門 al等於1
	je speed_up
	
	ret

	speed_up:
		cmp speed_R_rate,0
		je no_accelerate			;假如速度已經等於0，就不減了，跳到 no_accelerate

		sub speed_R_rate,10			;一次扣10
		sub speed_L_rate,10

		no_accelerate:
		ret
accelerate endp

end main
