CC?=gcc
CPPFLAGS=
CFLAGS=-Wall -Wextra -Wvla -Werror -pedantic -std=c99
LDFLAGS=

SRC=day_1.c
OBJS=$(SRC:.c=.o)
BIN=day_1

all: $(BIN)

$(BIN): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $^

debug: CPPFLAGS+=
debug: CFLAGS+=-fsanitize=address -g
debug: LDFLAGS+=-fsanitize=address
debug: $(BIN)

clean:
	$(RM) $(BIN) $(OBJS)

.PHONY: clean
