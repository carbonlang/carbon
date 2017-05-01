FILES	= carbon.tab.c lex.yy.c
CC	= clang
CFLAGS	= -g -ansi
LFLAGS	= -lfl

carbon:		$(FILES)
			$(CC) $(CFLAGS) $(FILES) $(LFLAGS) -o carbon

lex.yy.c:	carbon.l
			flex carbon.l

carbon.tab.c:	carbon.y
			bison -d carbon.y

clean:
			rm -f *.o *~ carbon carbon.c lex.yy.c carbon.tab.h carbon.tab.c
