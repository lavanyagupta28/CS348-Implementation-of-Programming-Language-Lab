# Makefile for nanoC Parser

CC = gcc
LEX = flex
YACC = yacc

all: a.out

a.out: lex.yy.c y.tab.c
	$(CC) lex.yy.c y.tab.c -o a.out -lfl

lex.yy.c: a4_230101059.l y.tab.h
	$(LEX) a4_230101059.l

y.tab.c y.tab.h: a4_230101059.y
	$(YACC) -d a4_230101059.y

clean:
	rm -f lex.yy.c y.tab.c y.tab.h a.out