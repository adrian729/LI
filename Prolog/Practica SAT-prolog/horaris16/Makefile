file = horaris

$(file): $(file).pl entradaHoraris.pl displaySol.pl
	swipl -quiet -O -g main --stand_alone=true -o $(file) -c $(file).pl

sudoku: sudoku.pl
	swipl -quiet -O -g main --stand_alone=true -o sudoku -c sudoku.pl