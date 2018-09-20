compilar: 	
	clear
	lex lexica.l
	yacc -d sintatica.y
	g++ -o glf y.tab.c -ll

	./glf < exemplo.foca

compilatorion:
	clear
	cd ~/Documentos/compilatorion/
	make compilar

criar:
	clear
	mkdir ~/Documentos/compilatorion

mover:
	clear
	cp Makefile ~/Documentos/compilatorion
	cp exemplo.foca ~/Documentos/compilatorion
	cp lexica.l ~/Documentos/compilatorion
	cp sintatica.y ~/Documentos/compilatorion
	cp y.tab.c ~/Documentos/compilatorion
	cp y.tab.h ~/Documentos/compilatorion
	cp lex.yy.c ~/Documentos/compilatorion
	cp glf ~/Documentos/compilatorion

	sublime-text.subl ~/Documentos/compilatorion/exemplo.foca
	sublime-text.subl ~/Documentos/compilatorion/lexica.l
	sublime-text.subl ~/Documentos/compilatorion/sintatica.y

novo:
	clear
	mkdir novo

remover:
	clear
	mv ~/Documentos/compilatorion/exemplo.foca novo/
	mv ~/Documentos/compilatorion/lexica.l novo/
	mv ~/Documentos/compilatorion/sintatica.y novo/
	mv ~/Documentos/compilatorion/tabelin.h novo/
	mv ~/Documentos/compilatorion/y.tab.c novo/
	mv ~/Documentos/compilatorion/y.tab.h novo/
	mv ~/Documentos/compilatorion/lex.yy.c novo/
	mv ~/Documentos/compilatorion/glf novo/
	rm -r ~/Documentos/compilatorion

