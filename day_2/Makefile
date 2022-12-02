SRC=day_2.ml
BIN=day_2

all: $(BIN)

$(BIN): $(SRC)
	ocamlopt -o $@ $(SRC)

clean:
	$(RM) $(BIN) day_2.cmi day_2.cmx day_2.o

.PHONY: clean
