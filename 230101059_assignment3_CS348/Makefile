ROLL    = 230101059
LEX_SRC = a3_$(ROLL).l
C_SRC   = lex.yy.c
TARGET  = a3_$(ROLL)
TEST    = a3_$(ROLL)_test.nc
TOK_OUT = a3_$(ROLL)_token.txt
SYM_OUT = a3_$(ROLL)_st.txt

.PHONY: all run clean

all: $(TARGET)

$(TARGET): $(C_SRC)
	gcc -o $(TARGET) $(C_SRC) -lfl

$(C_SRC): $(LEX_SRC)
	flex $(LEX_SRC)

run: $(TARGET)
	./$(TARGET) $(TEST)

clean:
	rm -f $(C_SRC) $(TARGET) $(TOK_OUT) $(SYM_OUT)
