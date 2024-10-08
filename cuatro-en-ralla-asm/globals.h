

//Matriu 6x7 que conté l'estat del tauler de 4inaRow
extern "C" char mBoard[6][7] = {
				   {'.','.','.','.','.','.','.'},
				   {'.','.','.','.','.','.','.'},
				   {'.','.','.','.','.','.','.'},
				   {'.','.','.','.','.','.','.'},
				   {'.','.','.','.','.','.','.'},
				   {'.','.','.','.','.','.','.'} };
				   
extern "C" char tecla;			// Codi ascii corresponent a la tecla pitjada

extern "C" int row;				//fila per a accedir a la matriu gameCards [1..5]
extern "C" char col;			//columna per a accedir a la matriu gameCards [A..D]
extern "C" char colCursor;		//columna per a accedir a la matriu gameCards [A..D]
extern "C" int player;			//indica el numero de judador

extern "C" int rowScreen;		//fila on volem posicionar el cursor a la pantalla.
extern "C" int colScreen;		//columna on volem posicionar el cursor a la pantalla.

extern "C" int rowScreenIni;	//fila inicial del taulell en coordenades de pantalla
extern "C" int colScreenIni;	//columna inicial del taulell en coordenades de pantalla


extern "C" int pos;				//índex per a accedir a la matriu mBoard
extern "C" char carac;			//codi ascii del caràcter que es vol treure per pantalla.



