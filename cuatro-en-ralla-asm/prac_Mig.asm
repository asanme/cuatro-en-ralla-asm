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
; Les subrutines que heu de modificar per la pràctica nivell bàsic son:
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
; en funció de la fila i columna indicats per les variables colScreen i rowScreen
; cridant a la funció gotoxy_C.
;
; Variables utilitzades: 
; Cap
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
gotoxy proc
   push ebp
   mov  ebp, esp
   Push_all

   ; Quan cridem la funció gotoxy_C(int row_num, int col_num) des d'assemblador 
   ; els paràmetres s'han de passar per la pila
      
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
; Mostrar un caràcter, guardat a la variable carac
; en la pantalla en la posició on està  el cursor,  
; cridant a la funció printChar_C.
; 
; Variables utilitzades: 
; carac : variable on està emmagatzemat el caracter a treure per pantalla
; 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printch proc
   push ebp
   mov  ebp, esp
   ;guardem l'estat dels registres del processador perqué
   ;les funcions de C no mantenen l'estat dels registres.
   
   
   Push_all
   

   ; Quan cridem la funció  printch_C(char c) des d'assemblador, 
   ; el paràmetre (carac) s'ha de passar per la pila.
 
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
; Llegir un caràcter de teclat   
; cridant a la funció getch_C
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
; Aquesta subrutina posiciona el cursor a la posició indicada per les
; variables rowScreen i colScreen.
; Per calcular la posició del cursor a pantalla (rowScreen) i (colScreen)
; cal utilitzar aquestes fórmules:
;
;            rowScreen=rowScreenIni-2
;            colScreen=colScreenIni+(colCursor*4)
;
; Tenir en compte que colCursor és un caràcter (ascii) que s’ha de
; convertir a un valor numèric per a realitzar l’operació.
;
; Variables utilitzades:
; colCursor : columna per a accedir a la matriu
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; rowScreenIni : fila de la primera posició de la matriu a la pantalla.
; colScreenIni : columna de la primera posició de la matriu a la pantalla.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
showCursor proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi

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

	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret

showCursor endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Presenta el número de jugador a la casella Player
; Convertir el valor int de 32 bits de la variable Player
; a un caràcter ascii i mostrar-lo a la posició indicada per 
; rowScreen i colScreen de la pantalla, [23,19]
; Cal cridar a la subrutina gotoxy per a posicionar el cursor 
; i a la subrutina printch per a mostrar el caràcter.
; La subrutina printch mostra per pantalla el caràcter emmagatzemat
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
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi

	mov [rowScreen], 23
	mov [colScreen], 19
	call gotoxy
	
	mov eax, [player] 
	add eax, '0'
	mov carac, al
	call printch

	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


showPlayer endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Escriu el valor de cada casella, emmagatzemat a mBoard, en la posició corresponent de pantalla
; Anar posicionant el cursor a cada posició del tauler cridant la gotoxy
; i mostrar el valor corresponent de la matriu mBoard en pantalla cridant
; a la subrutina printch
;
; Per calcular la posició del cursor a pantalla cal calcular rowScreen i colScreen
; Per fer aquest càlcul utilitzarem les formules
;          rowScreen=RowScreenIni+(fila*2)+4
;          colScreen=ColScreenIni+(col*4)-1
;
; Variables utilitzades:
; rowScreen : fila on volem posicionar el cursor a la pantalla.
; colScreen : columna on volem posicionar el cursor a la pantalla.
; rowScreenIni : fila de la primera posició de la matriu a la pantalla.
; colScreenIni : columna de la primera posició de la matriu a la pantalla.
; mBoard: Matriu que conté el valor de les diferents posicions del tauler.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

showBoard proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi

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

	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


showBoard endp



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment del cursor a dreta ‘k’ i esquerra ‘j’.
; Cridar a la subrutina getch per a llegir una tecla
; fins que pitgem una de les tecles vàlides (‘j’, ‘k’, ‘ ‘ o 'q'<Quit>).
; La tecla ‘j’ mou el cursor a l’esquerra,
; la tecla ‘k’ mou el cursor a la dreta.
; S’ha de controlar que no surti de límits.
; Si pitgem una tecla no vàlida, ha d’esperar a una tecla vàlida.
;
; Variables utilitzades:
; tecla: variable on s’emmagatzema el caràcter llegit
; colCursor: Variable que indica l columna en la que es troba el cursor
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursor proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi
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
		
		; Con esto conseguimos el numero de columna
		mov al, [colCursor]
		sub al, 'A'
		shl eax, 2
		add eax, [colScreenIni]

		; Con esto encontramos la proxima columna a la que deberemos movernos
		shl ebx, 2
		add eax, ebx		
		sub eax, 1		
	
		; Hay que comprobar que el valor actual este dentro del rango de valores validos
		; En este caso, tiene que ser un valor entre 7 y 31, incluidos (es 7 y 31 por el offset de 1)
		cmp eax, 7
		jl finishMoving
		cmp eax, 31
		jg finishMoving

		; Solo almacenamos el valor si esta dentro del rango [8, 32]
		mov [colScreen], eax

		; Calculamos la siguiente columna
		add [colCursor], cl

		call gotoxy
		add [col], cl
	finishMoving:
		





	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


moveCursor endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Subrutina que implementa el moviment continu
; S’ha d’anar cridant a la subrutina moveCursor 
; fins que pitgem ‘ ‘ o 'q'<Quit>.
; La tecla ‘j’ mou el cursor a l’esquerra,
; la tecla ‘k’ mou el cursor a la dreta.
; Si pitgem una tecla no vàlida, ha d’esperar a una tecla vàlida.
;
; Variables utilitzades:
; tecla: variable on s’emmagatzema el caràcter llegit
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveCursorContinuous proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi
	call showCursor
	checkForExit:
		call moveCursor

		cmp tecla, 'q'
		je exit
		
		cmp tecla, ' '
		je exit

		jmp checkForExit

	exit:


	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


moveCursorContinuous endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Aquesta subrutina serveix per a poder accedir a les components de la matriu.
; Calcula l’índex per a accedir a la matriu mBoard en assemblador.
; mBoard[row][col] en C, és [mBoard+pos] en assemblador.
; on pos = (row*7 + col (convertida a número)).
;
; Variables utilitzades:
; row: fila per a accedir a la matriu mBoard
; col: columna per a accedir a la matriu mBoard
; pos: índex per a accedir a la matriu mBoard
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
calcIndex proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi

	mov eax, [row]
	imul eax, 7
	mov ebx, 0
	mov bl, [col]
	sub bl, 'A'
	add eax, ebx
	mov [pos], eax

	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


calcIndex endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; A partir de la posició en la que ha quedat la fitxa introduïda comprovar si les fitxes 
; que hi ha per sota en vertical coincideixen amb la que acabem d’introduir.
; Si coincideix incrementar el comptador i comprovar si hem arribat a 4.
; Si no hem arribat a 4, seguim baixant.
; Si hem arribat a 4, posem l’indicador row4Complete a 1.
;
; Variables utilitzades:
; mBoard : matriu del taulell on anem inserint les fitxes
; inaRow : comptador per a saber el nombre de fitxes en ratlla
; row4Complete : indicador de si hem arribat a 4 fitxes en ratlla o no
; pos : posició de la matriu mBoard que estem mirant
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

checkRow proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi
	mov [row4Complete], 0
	mov eax, [pos]
	mov [inaRow], 1
	mov bl, [mBoard + eax]
	bucleBusqueda:	
		add eax, 7
		cmp eax, 42
		jge final
		mov cl, [mBoard + eax]
		cmp cl, bl
		jne final
		inc [inaRow]
		cmp [inaRow], 4
		jne bucleBusqueda
		mov [row4Complete], 1
	final:

	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


checkRow endp

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Situa una fitxa en una posició lliure del tauler de joc
; S’ha de cridar a movCursorContinuous per a triar la columna de la casella desitjada.
; Un cop som a la columna de casella desitjada premem al tecla ‘ ‘ (espai "tirar" la fitxa)
; Calcular la posició de la matriu corresponent a la posició més baixa de la columna que 
; ocupa el cursor, cridant a la subrutina calcIndex.
; Anar pujant per al columna fins a trobar una posició buida i posar la fitxa en aquella posició de mBoard. 
; Cridar a la subrutina showBoard per a mostrar com queda el tauler.
; Si hem pitjat 'q'<Quit>, no hem d’introduir fitxa.
;
; Variables utilitzades:
; row : fila per a accedir a la matriu mBoard
; col : columna per a accedir a la matriu mBoard
; colCursor: Columna en la que tenim el cursor
; pos : índex per a accedir a la matriu mBoard 
; mBoard : matriu 6x7 on tenim el tauler
; carac : caràcter per a escriure a pantalla
; tecla: codi ascii de la tecla pitjada
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
putPiece proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi

	call showBoard
	call showPlayer

	mov al, 'D' 
	mov [col], al
	mov [colCursor], al

	call showCursor

	startGame:
		call moveCursorContinuous 
		cmp [tecla], 'q'
		je final
		cmp [tecla], ' '
		je putPieceBranch

		jmp startGame

	putPieceBranch:
		; Empezamos a mirar desde la ultima fila
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
		
	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


putPiece endp


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; S’han de permetre dues tirades, cridant a putPiece, 
; una de cada jugador,
; actualitzant a la casella corresponent de la pantalla
; l’identificador del jugador cridant a showPlayer.
; Si es pitja 'q'<Quit> o s’aconsegueix la ratlla de 4 fitxes
;el procés ha de finalitzar.
;
; Variables utilitzades:
; tecla: codi ascii de la tecla pitjada
; player: Variable que indica quin jugador fa la tirada
; row4Complete: variable que ha actualitzat la subrutina checkRow 
; per a indicar si s’ha aconseguit una ratlla de 4 fitxes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

put2Players proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi
	mov [player], 1
	call putPiece
	call checkRow
	cmp [row4Complete], 1
	je final
	mov [player], 2
	call putPiece
	call checkRow
	
	final:
	;Fi Codi de la pràctica
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
; per a indicar si s’ha aconseguit una ratlla de 4 fitxes.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Play proc
	push ebp
	mov  ebp, esp
	;Inici Codi de la pràctica: aquí heu d'escriure el vostre codi

	bucleJuego:
		cmp [tecla], 'q'
		je final
		call put2Players
		cmp [row4Complete], 1
		jne bucleJuego 

	final:

	;Fi Codi de la pràctica
	mov esp, ebp
	pop ebp
	ret


Play endp


END