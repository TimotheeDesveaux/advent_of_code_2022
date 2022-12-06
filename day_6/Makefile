SRC=day_6.zig
BIN=day_6

all: $(BIN)

$(BIN): $(SRC)
	zig build-exe $(SRC)

clean:
	$(RM) -r $(BIN) zig-cache/

.PHONY: clean
