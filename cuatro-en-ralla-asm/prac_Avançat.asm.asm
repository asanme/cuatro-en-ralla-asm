.586
.MODEL FLAT, C


; Funcions definides en C
printChar_C PROTO C, value:SDWORD
gotoxy_C PROTO C, value:SDWORD, value1: SDWORD
getch_C PROTO C


;Subrutines cridades des de C
public C showCursor, showPlayer, showBoard, moveCursor, moveCursorContinuous, putPiece, put2Players, Play
                         
;Variables utilitzades - declarades en C
extern C row: DWORD, col: BYTE, rowScreen: DWORD, colScreen: DWORD, rowScreenIni: DWORD, colScreenIni: DWORD 
extern C carac: BYTE, tecla: BYTE, colCursor: BYTE, player: DWORD, mBoard: BYTE, pos: DWORD
extern C inaRow: DWORD, row4Complete: DWORD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Les subrutines que heu de modificar per la pr�ctica nivell b�sic son:
; showCursor, showPlayer, showBoard, moveCursor, moveCursorContinuous, calcIndex, putPiece
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

.code   
   
;;Macros que guardan y recuperan de la pila los registros de proposito general de la arquitectura de 32 bits de Intel    
Push_all macro
	
	push eax
   	push ebx
    push ecx
    push edx
    push esi
    push edi
endm


Pop_all macro

	pop edi
   	pop esi
   	pop edx
   	pop ecx
   	pop ebx
   	pop eax
endm
   
   


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NO LA PODEU MODIFICAR AQUESTA RUTINA.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Situar el cursor en una fila i una columna de la pantalla
; en funci� de la fila i columna indicats per les variables colScreen i rowScreen
; cridant a la funci� gotoxy_C.
;
; Variables utilitzades: 
; Cap
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxy proc
   push ebp
   mov  ebp, esp
   Push_all

   ; Quan cridem la funci� gotoxy_C(int row_num, int col_num) des d'assemblador 
   ; els par�metres s'han de passar per la pila
      
   mov eax, [colScreen]
   push eax
   mov eax, [rowScreen]
   push eax
   call gotoxy_C
   pop eax
   pop eax 
   
   Pop_all

   mov esp, ebp
   pop ebp
   ret
gotoxy endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NO LA PODEU MODIFICAR AQUESTA RUTINA.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Mostrar un car�cter, guardat a la variable carac
; en la pantalla en la posici� on est� el cursor,  
; cridant a la funci� printChar_C.
; 
; Variables utilitzades: 
; carac : variable on est� emmagatzemat el caracter a treure per pantalla
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printch proc
   push ebp
   mov  ebp, esp
   ;guardem l'estat dels registres del processador perqu�
   ;les funcions de C no mantenen l'estat dels registres.
   
   
   Push_all
   

   ; Quan cridem la funci�  printch_C(char c) des d'assemblador, 
   ; el par�metre (carac) s'ha de passar per la pila.
 
   xor eax,eax
   mov  al, [carac]
   push eax 
   call printChar_C
 
   pop eax
   Pop_all

   mov esp, ebp
   pop ebp
   ret
printch endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; NO LA PODEU MODIFICAR AQUESTA RUTINA.   
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Llegir un car�cter de teclat   
; cridant a la funci� getch_C
; i deixar-lo a la variable tecla.
;
; Variables utilitzades: 
; tecla: Variable on s'emmagatzema el caracter llegit

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
getch proc
   push ebp
   mov  ebp, esp
    
   Push_all

   call getch_C
   mov [tecla],al
 
   Pop_all

   mov esp, ebp
   pop ebp
   ret
getch endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Posicionar el cursor a la columna indicada per la variable colCursor, 
; dins la fila M que hi ha per sobre del tauler.
; Per a posicionar el cursor cridar a la subrutina gotoxy que es dona feta.
; Aquesta subrutina posiciona el cursor a la posici� indicada per les
; variables rowScreen i colScreen.
; Per calcular la posici� del cursor a pantalla (rowScreen) i (colScreen)
; cal utilitzar aquestes f�rmules:
;
;            rowScreen=rowScreenIni-2
;            colScreen=colScreenIni+(colCursor*4)
;
; Tenir en compte que colCursor �s un car�cter (ascii) que s�ha de
; convertir a un valor num�ric per a realitzar l�operaci�.
;
; Variables utilitzades:
; colCursor : columna per a accedir a la matriu
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; rowScreenIni : fila de la primera posici� de la matriu a la pantalla.
; colScreenIni : columna de la primera posici� de la matriu a la pantalla.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showCursor proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi
	
	mov eax, [rowScreenIni]
	mov [rowScreen], eax

	mov eax, 0
	mov al, [colCursor]
	sub al, 'A'
	shl eax, 2
	add eax, [colScreenIni]
	sub eax, 1
	mov [colScreen], eax
	call gotoxy

	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

showCursor endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Presenta el n�mero de jugador a la casella Player
; Convertir el valor int de 32 bits de la variable Player
; a un car�cter ascii i mostrar-lo a la posici� indicada per 
; rowScreen i colScreen de la pantalla, [23,19]
; Cal cridar a la subrutina gotoxy per a posicionar el cursor 
; i a la subrutina printch per a mostrar el car�cter.
; La subrutina printch mostra per pantalla el car�cter emmagatzemat
; al registre dil.
;
; Variables utilitzades:
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; player: variable que indica el jugador al que correspon tirar

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showPlayer proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi


	mov [rowScreen], 23
	mov [colScreen], 19

	call gotoxy

	mov eax, [player]
	add eax, '0'
	mov carac, al
	call printch


	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

showPlayer endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Escriu el valor de cada casella, emmagatzemat a mBoard, en la posici� corresponent de pantalla
; Anar posicionant el cursor a cada posici� del tauler cridant la gotoxy
; i mostrar el valor corresponent de la matriu mBoard en pantalla cridant
; a la subrutina printch
;
; Per calcular la posici� del cursor a pantalla cal calcular rowScreen i colScreen
; Per fer aquest c�lcul utilitzarem les formules
;          rowScreen=RowScreenIni+(fila*2)+4
;          colScreen=ColScreenIni+(col*4)-1
;
; Variables utilitzades:
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; rowScreenIni : fila de la primera posici� de la matriu a la pantalla.
; colScreenIni : columna de la primera posici� de la matriu a la pantalla.
; mBoard: Matriu que cont� el valor de les diferents posicions del tauler.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

showBoard proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi


		mov esi, 0
	mov edi, 0
	rowIterator:
		cmp esi, 5
		jg endRowIterator
		colIterator:
			cmp edi, 6
			jg endColIterator
			push esi
			push edi
			
			shl esi, 1
			mov eax, [rowScreenIni]
			add eax, 4
			add eax, esi
			mov [rowScreen], eax
			mov eax, [colScreenIni]
			shl edi, 2
			add eax, edi
			sub eax, 1
			mov [colScreen], eax
			call gotoxy


			pop edi
			pop esi
			mov eax, edi
			add al, 'A'
			mov [col], al
			mov [row], esi
			call calcIndex
			mov eax, [pos]
			
			mov al, [mBoard + eax]
			mov [carac], al
			call printch

			inc edi
			jmp colIterator

		endColIterator:
		mov edi, 0
		inc esi
		jmp rowIterator

	endRowIterator:


	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

showBoard endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment del cursor a dreta �k� i esquerra �j�.
; Cridar a la subrutina getch per a llegir una tecla
; fins que pitgem una de les tecles v�lides (�j�, �k�, � � o 'q'<Quit>).
; La tecla �j� mou el cursor a l�esquerra,
; la tecla �k� mou el cursor a la dreta.
; S�ha de controlar que no surti de l�mits.
; Si pitgem una tecla no v�lida, ha d�esperar a una tecla v�lida.
;
; Variables utilitzades:
; tecla: variable on s�emmagatzema el car�cter llegit
; colCursor: Variable que indica l columna en la que es troba el cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursor proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi


	checkForValidKey:
		call getch

		cmp tecla, 'q'
		je finishMoving
		cmp tecla, ' '
		je finishMoving

		mov ebx, -1
		cmp tecla, 'j'
		je validKeyWasPressed 

		mov ebx, 1
		cmp tecla, 'k'
		je validKeyWasPressed 

		jmp checkForValidKey
	
	validKeyWasPressed:	
		mov eax, 0
		mov ecx, 0
		mov ecx, ebx
		
		;numero de columna
		mov al, [colCursor]
		sub al, 'A'
		shl eax, 2
		add eax, [colScreenIni]

		;proxima columna a la que nos moveremos
		shl ebx, 2
		add eax, ebx		
		sub eax, 1		
	
		;comprobar rango de valores validos, entre 7 y 31 incluidos
		cmp eax, 7
		jl finishMoving
		cmp eax, 31
		jg finishMoving

		mov [colScreen], eax

		add [colCursor], cl

		call gotoxy
		add [col], cl
	finishMoving:



	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

moveCursor endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment continu
; S�ha d�anar cridant a la subrutina moveCursor 
; fins que pitgem � � o 'q'<Quit>.
; La tecla �j� mou el cursor a l�esquerra,
; la tecla �k� mou el cursor a la dreta.
; Si pitgem una tecla no v�lida, ha d�esperar a una tecla v�lida.
;
; Variables utilitzades:
; tecla: variable on s�emmagatzema el car�cter llegit
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursorContinuous proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi


	checkForExit:
		call moveCursor

		cmp tecla, 'q'
		je exit
		
		cmp tecla, ' '
		je exit

		jmp checkForExit

	exit:


	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

moveCursorContinuous endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina serveix per a poder accedir a les components de la matriu.
; Calcula l��ndex per a accedir a la matriu mBoard en assemblador.
; mBoard[row][col] en C, �s [mBoard+pos] en assemblador.
; on pos = (row*7 + col (convertida a n�mero)).
;
; Variables utilitzades:
; row: fila per a accedir a la matriu mBoard
; col: columna per a accedir a la matriu mBoard
; pos: �ndex per a accedir a la matriu mBoard
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calcIndex proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi


	mov eax, [row]
	imul eax, 7
	mov ebx, 0
	mov bl, [col]
	sub bl, 'A'
	add eax, ebx
	mov [pos], eax


	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

calcIndex endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; A partir de la posici� en la que ha quedat la fitxa introdu�da comprovar si les fitxes 
; que hi ha per sota en vertical coincideixen amb la que acabem d�introduir.
; Si coincideix incrementar el comptador i comprovar si hem arribat a 4.
; Si no hem arribat a 4, seguim baixant.
; Si hem arribat a 4, posem l�indicador row4Complete a 1.
;
; Variables utilitzades:
; mBoard : matriu del taulell on anem inserint les fitxes
; inaRow : comptador per a saber el nombre de fitxes en ratlla
; row4Complete : indicador de si hem arribat a 4 fitxes en ratlla o no
; pos : posici� de la matriu mBoard que estem mirant
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

checkRow proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi


	mov [row4Complete], 0   ;0 a que nadie ha ganado
	mov eax, [pos]			;Colocamos la posicion a eax
	mov [inaRow], 1			;1 de que hay 1 pieza seguida
	mov bl, [mBoard + eax]	;bl una X o O

	;Vertical
	bucleVertical:	
		add eax, 7
		cmp eax, 42
		jge HoritzontalDreta
		mov cl, [mBoard + eax]
		cmp cl, bl
		jne HoritzontalDreta
		inc [inaRow]
		cmp [inaRow], 4
		jne bucleVertical
		mov [row4Complete], 1
		jmp final

	HoritzontalDreta:
		;Reiniciar valores
		mov eax, [pos]			;Como no se ha completado en Vertical, toca volver a poner los valores
		mov [inaRow], 1
	bucleHoritzontalDreta:
		add eax, 1
		mov ecx, 7
		push eax
		cdq
		idiv ecx
		cmp edx, 0     ;Hasta aqui hemos dividido por 7 para ver que no nos vayamos a la sigueinte fila
		pop eax
		je HoritzontalEsquerra

		mov cl, [mBoard + eax]
		cmp cl, bl
		jne HoritzontalEsquerra
		inc [inaRow]
		cmp [inaRow], 4
		jne bucleHoritzontalDreta
		mov [row4Complete], 1
		jmp final
	
	HoritzontalEsquerra:
		mov eax, [pos]

	bucleHoritzontalEsquerra:
		sub eax, 1
		mov ecx, 7
		push eax
		cdq
		idiv ecx
		cmp edx, 6
		pop eax
		je DiagonalDescendent1

		mov cl, [mBoard + eax]
		cmp cl, bl
		jne DiagonalDescendent1
		inc [inaRow]
		cmp [inaRow], 4
		jne bucleHoritzontalEsquerra
		mov [row4Complete], 1
		jmp final

	;Diagonal_1\
	DiagonalDescendent1:
		mov eax, [pos]			
		mov [inaRow], 1

	;Abajo derecha
	bucleDiagonalDescendent1: 
		add eax, 8
		cmp eax, 42
		jge DiagonalDescendent2

		mov cl, [mBoard + eax]
		cmp cl, bl
		jne DiagonalDescendent2
		inc [inaRow]
		cmp [inaRow], 4
		jne bucleDiagonalDescendent1
		mov [row4Complete], 1
		jmp final

	DiagonalDescendent2: 
		mov eax, [pos]	

	;Arriba izquierda
	bucleDiagonalDescendent2:
		sub eax, 8
		cmp eax, 0
		jl DiagonalAscendent1

		mov cl, [mBoard + eax]
		cmp cl, bl
		jne DiagonalAscendent1
		inc [inaRow]
		cmp [inaRow], 4
		jne bucleDiagonalDescendent2
		mov [row4Complete], 1
		jmp final

	;Diagonal_2/
	DiagonalAscendent1:
		mov eax, [pos]			
		mov [inaRow], 1

	;Arriba derecha
	bucleDiagonalAscendent1:
		sub eax, 6
		cmp eax, 0
		jl DiagonalAscendent2

		mov cl, [mBoard + eax]
		cmp cl, bl
		jne DiagonalAscendent2
		inc [inaRow]
		cmp [inaRow], 4
		jne bucleDiagonalAscendent1
		mov [row4Complete], 1
		jmp final

	DiagonalAscendent2:
		mov eax, [pos]		

	;Abajo izquierda
	bucleDiagonalAscendent2:
		add eax, 6
		cmp eax, 42
		jge final

		mov cl, [mBoard + eax]
		cmp cl, bl
		jne final
		inc [inaRow]
		cmp [inaRow], 4
		jne bucleDiagonalAscendent2
		mov [row4Complete], 1
		jmp final

	final:


	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

checkRow endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Situa una fitxa en una posici� lliure del tauler de joc
; S�ha de cridar a movCursorContinuous per a triar la columna de la casella desitjada.
; Un cop som a la columna de casella desitjada premem al tecla � � (espai "tirar" la fitxa)
; Calcular la posici� de la matriu corresponent a la posici� m�s baixa de la columna que 
; ocupa el cursor, cridant a la subrutina calcIndex.
; Anar pujant per al columna fins a trobar una posici� buida i posar la fitxa en aquella posici� de mBoard. 
; Cridar a la subrutina showBoard per a mostrar com queda el tauler.
; Si hem pitjat 'q'<Quit>, no hem d�introduir fitxa.
;
; Variables utilitzades:
; row : fila per a accedir a la matriu mBoard
; col : columna per a accedir a la matriu mBoard
; colCursor: Columna en la que tenim el cursor
; pos : �ndex per a accedir a la matriu mBoard 
; mBoard : matriu 6x7 on tenim el tauler
; carac : car�cter per a escriure a pantalla
; tecla: codi ascii de la tecla pitjada
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
putPiece proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi


	
	call showBoard
	call showPlayer

	mov al, [colCursor]
	mov [col], al

	call showCursor

	startGame:
		call moveCursorContinuous 
		cmp tecla, 'q'
		je final
		cmp tecla, ' '
		je putPieceBranch

		jmp startGame

	putPieceBranch:
		mov [row], 5


	putPieceBucle:
		call calcIndex
		mov eax, [pos]
		cmp [mBoard + eax], '.'
		je  putPieceValid
		sub [row], 1
		cmp [row], 0
		jl startGame
		jmp putPieceBucle

	putPieceValid:
		cmp [player], 2
		je jugador2
		mov [mBoard + eax], 'O'
		jmp final
	jugador2:
		mov [mBoard + eax], 'X'
		
	final:
		push eax
		call showBoard
		pop eax
		mov [pos], eax


	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

putPiece endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; S�han de permetre dues tirades, cridant a putPiece, 
; una de cada jugador,
; actualitzant a la casella corresponent de la pantalla
; l�identificador del jugador cridant a showPlayer.
; Si es pitja 'q'<Quit> o s�aconsegueix la ratlla de 4 fitxes
;el proc�s ha de finalitzar.
;
; Variables utilitzades:
; tecla: codi ascii de la tecla pitjada
; player: Variable que indica quin jugador fa la tirada
; row4Complete: variable que ha actualitzat la subrutina checkRow 
; per a indicar si s�ha aconseguit una ratlla de 4 fitxes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

put2Players proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi


	mov [player], 1
	call putPiece
	call checkRow
	cmp [row4Complete], 1
	je final
	mov [player], 2
	call putPiece
	call checkRow
	
	final:


	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret
	
put2Players endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Es va cridant a put2Players mentre no es pitgi 'q'<Quit>
; o un jugador aconsegueixi una ratlla de 4 fitxes.
;
; Variables utilitzades:
; tecla: codi ascii de la tecla pitjada
; row4Complete: variable que ha actualitzat la subrutina checkRow 
; per a indicar si s�ha aconseguit una ratlla de 4 fitxes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Play proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pr�ctica: aqu� heu d'escriure el vostre codi


	mov [tecla], ' '
	bucleJuego:
		cmp [tecla], 'q'
		je final
		call put2Players
		cmp [row4Complete], 1
		jne bucleJuego 

	final:


	;Fi Codi de la pr�ctica
	mov esp, ebp
	pop ebp
	ret

Play endp


END