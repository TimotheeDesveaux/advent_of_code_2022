SRC=part_one.tig part_two.tig
LLVM_SRC=$(SRC:.tig=.ll)
BIN=$(SRC:.tig=)

all: part_one part_two

part_one: part_one.tig common.tih
	tc --llvm-runtime-display --llvm-display part_one.tig > part_one.ll
	clang -m32 -o $@ part_one.ll

part_two: part_two.tig common.tih
	tc --llvm-runtime-display --llvm-display part_two.tig > part_two.ll
	clang -m32 -o $@ part_two.ll

clean:
	$(RM) $(BIN) $(LLVM_SRC)

.PHONY: clean
