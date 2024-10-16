#include <stdio.h>
#include <conio.h>

#include <iostream>
#include <iomanip>
#include <stdlib.h>
#include <time.h>
#include <windows.h>
#include "globals.h"

extern "C" {
// Difinició de Subrutines en ASM
void showCursor();
void showPlayer();
void showBoard();
void moveCursor();
void moveCursorContinuous();
void putPiece();


void printChar_C(char c);
int clearscreen_C();
int printMenu_C();
int gotoxy_C(int row_num, int col_num);
char getch_C();
int printBoard_C(int tries);
}


/**
 * Definición de variables globales
 */

char carac, tecla;
int rowScreenIni = 6; //Fila inicial del taulell
int colScreenIni = 8; //Columna inicial del taulell
int row;
char col, colCursor;
int pos;
int player = 1;
int rowScreen;
int colScreen;


int opc;


//Mostrar un caràcter
//Quan cridem aquesta funció des d'assemblador el paràmetre s'ha de passar a traves de la pila.
void printChar_C(char c)
{
	putchar(c);
}

//Esborrar la pantalla
int clearscreen_C()
{
	system("CLS");
	return 0;
}

int migotoxy(int x, int y)
{
	//USHORT x,USHORT y) {
	COORD cp = {y, x};
	SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), cp);
	return 0;
}

//Situar el cursor en una fila i columna de la pantalla
//Quan cridem aquesta funció des d'assemblador els paràmetres (row_num) i (col_num) s'ha de passar a través de la pila
int gotoxy_C(int row_num, int col_num)
{
	migotoxy(row_num, col_num);
	return 0;
}


//Imprimir el menú del joc
int printMenu_C()
{
	clearscreen_C();
	gotoxy_C(1, 1);
	printf("                                 \n");
	printf("                                 \n");
	printf("                                 \n");
	printf(" _______________________________ \n");
	printf("|                               |\n");
	printf("|           MAIN MENU           |\n");
	printf("|_______________________________|\n");
	printf("|                               |\n");
	printf("|       1. Show Cursor          |\n");
	printf("|       2. Show Player          |\n");
	printf("|       3. Show Board           |\n");
	printf("|       4. Move Cursor          |\n");
	printf("|       5. Move Continuous      |\n");
	printf("|       6. Put Piece            |\n");
	printf("|                               |\n");
	printf("|                               |\n");
	printf("|        0. Exit                |\n");
	printf("|_______________________________|\n");
	printf("|                               |\n");
	printf("|           OPTION:             |\n");
	printf("|_______________________________|\n");
	return 0;
}


//Llegir una tecla sense espera i sense mostrar-la per pantalla
char getch_C()
{
	DWORD mode, old_mode, cc;
	HANDLE h = GetStdHandle(STD_INPUT_HANDLE);
	if (h == NULL)
	{
		return 0; // console not found
	}
	GetConsoleMode(h, &old_mode);
	mode = old_mode;
	SetConsoleMode(h, mode & ~(ENABLE_ECHO_INPUT | ENABLE_LINE_INPUT));
	TCHAR c = 0;
	ReadConsole(h, &c, 1, &cc, NULL);
	SetConsoleMode(h, old_mode);

	return c;
}


/**
 * Mostrar el tauler de joc a la pantalla. Les li­nies del tauler.
 *
 * Aquesta funcio es crida des de C i des d'assemblador,
 * i no hi ha definida una subrutina d'assemblador equivalent.
 * No hi ha pas de parametres.
 */
void printBoard_C()
{
	gotoxy_C(1, 1); //Files
	//Taulell                                 
	printf("_____________________________________ \n"); //01
	printf("|                                     |\n"); //02
	printf("|             4 in a ROW              |\n"); //03
	printf("|                                     |\n"); //04
	printf("|    +---+---+---+---+---+---+---+    |\n"); //05
	printf("|  M |   |   |   |   |   |   |   |    |\n"); //06
	printf("|    +---+---+---+---+---+---+---+    |\n"); //07
	//Columnas Tabl. 08   12  16  20  24   28         
	printf("|      A   B   C   D   E   F   G      |\n"); //08
	printf("|    +---+---+---+---+---+---+---+    |\n"); //09
	printf("|  0 |   |   |   |   |   |   |   |    |\n"); //10
	printf("|    +---+---+---+---+---+---+---+    |\n"); //11
	printf("|  1 |   |   |   |   |   |   |   |    |\n"); //12
	printf("|    +---+---+---+---+---+---+---+    |\n"); //13
	printf("|  2 |   |   |   |   |   |   |   |    |\n"); //14
	printf("|    +---+---+---+---+---+---+---+    |\n"); //15
	printf("|  3 |   |   |   |   |   |   |   |    |\n"); //16
	printf("|    +---+---+---+---+---+---+---+    |\n"); //17
	printf("|  4 |   |   |   |   |   |   |   |    |\n"); //18
	printf("|    +---+---+---+---+---+---+---+    |\n"); //19
	printf("|  5 |   |   |   |   |   |   |   |    |\n"); //20
	printf("|    +---+---+---+---+---+---+---+    |\n"); //21  

	//Columnas dígitos      15       24                 
	printf("|               +-----+               |\n"); //22
	printf("|       Player  |     |               |\n"); //23
	printf("|               +-----+               |\n"); //24 
	printf("|    (ESC)Exit     (Space)Put Piece   |\n"); //25
	printf("|     (j)Left          (l)Right       |\n"); //26
	printf("|                                     |\n"); //27
	printf("|                                     |\n"); //28
	printf("|_____________________________________|\n"); //29
}

int main(void)
{
	opc = 1;

	while (opc != '0')
	{
		printMenu_C(); //Mostrar menú
		gotoxy_C(20, 20); //Situar el cursor
		opc = getch_C(); //Llegir una opció
		switch (opc)
		{
		case '1': //Primera Opció del Menú --> 1. Show Cursor
			clearscreen_C(); //Esborra la pantalla
			printBoard_C(); //Mostrar el tauler
			gotoxy_C(30, 12); //Situar el cursor a sota del tauler
			printf("Press any key ");

			colCursor = 'D'; //Columna inicial on volem que aparegui el cursor  'D'
			showCursor(); //Posicionar el cursor a la columna indicada per la variable colCursor

			getch_C(); //Esperar que es premi una tecla
			break;

		case '2': //Segona Opció del Menú --> 2. Show Player
			clearscreen_C(); //Esborra la pantalla
			printBoard_C(); //Mostrar el tauler.

			player = 1;
			showPlayer(); //Presenta el número de jugador a la casella Player

			gotoxy_C(30, 12); //Situar el cursor a sota del tauler
			printf("Press any key ");
			getch_C();
			break;

		case '3': //Tercera Opció del Menú --> 3. Show Board
			clearscreen_C(); //Esborra la pantalla
			printBoard_C(); //Mostrar el tauler.

			player = 1;
			showPlayer(); //Presenta el número de jugador a la casella Player
			showBoard();
		//Escriu el valor de cada casella, enmagatzemat a mBoard, en la posició corresponent de pantalla

			gotoxy_C(30, 12); //Situar el cursor a sota del tauler
			printf("Press any key ");
			getch_C();
			break;

		case '4': //Quarta Opció del Menú --> 4. Move Cursor
			clearscreen_C(); //Esborra la pantalla
			printBoard_C(); //Mostrar el tauler.

			colCursor = 'D'; //Columna inicial on volem que aparegui el cursor 'D'
			showCursor(); //Posicionar el cursor a la columna indicada per la variable colCursor

			moveCursor(); //Subrutina que implementa el moviment del cursor a dreta ‘k’ i esquerra ‘j’.

			gotoxy_C(30, 12); //Situar el cursor a sota del tauler
			printf("Press any key ");

			showCursor(); //Posicionar el cursor a la columna indicada per la variable colCursor

			getch_C();
			break;

		case '5': //Quinta Opció del Menú --> 5. Move Continuous
			clearscreen_C(); //Esborra la pantalla
			printBoard_C(); //Mostrar el tauler.

			player = 1;
			gotoxy_C(30, 5);
			printf(" Press j, k, <space> or <Quit> ");
			colCursor = 'D'; //Columna inicial on volem que aparegui el cursor 'D'

			showCursor(); // Se han olvidado posicionar el cursor donde toca antes de hacer nada...
			moveCursorContinuous(); //Subrutina que implementa el moviment continu

			gotoxy_C(30, 2); //Situar el cursor a sota del tauler
			printf("          Press any key          ");

			getch_C();
			break;
		case '6': //Sexta Opció del Menú --> 5. Put Piece
			row = 3;
			col = 'B';
			clearscreen_C(); //Esborra la pantalla
			printBoard_C(); //Mostrar el tauler.

			player = 1;
			gotoxy_C(30, 5);
			printf(" Press j, k, <space> or <Quit> ");
			colCursor = 'D'; //Columna inicial on volem que aparegui el cursor 'D'

			putPiece(); //Situa una fitxa en una posició lliure del tauler de joc

			gotoxy_C(30, 2);
			if (tecla != 'q')
				printf("  Piece inserted - Press any key ");
			else
				printf("           Press any key          ");
			getch_C();

			break;
		}
	}
	gotoxy_C(19, 1); //Situar el cursor a la fila 19
	return 0;
}
