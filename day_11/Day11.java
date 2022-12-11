import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;
import java.util.function.Function;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

class Monkey  {
    private List<Long> items;
    private Function<Long, Long> operation;
    private long divisibleBy;
    private int monkeyTrue;
    private int monkeyFalse;
    private long nbInspectedItems = 0;

    public long getNbInspectedItems() {
        return nbInspectedItems;
    }

    public long getDivisibleBy() {
        return divisibleBy;
    }

    Monkey (List<Long> items, Function<Long, Long> operation,
            long divisibleBy, int monkeyTrue, int monkeyFalse) {
        this.items = items;
        this.operation = operation;
        this.divisibleBy = divisibleBy;
        this.monkeyTrue = monkeyTrue;
        this.monkeyFalse = monkeyFalse;
    }

    void addItem(long item) {
        items.add(item);
    }

    void turn(List<Monkey> monkeys, Function<Long, Long> post) {
        while (!items.isEmpty()) {
            long item = items.remove(0);

            long worryLevel = operation.apply(item);
            worryLevel = post.apply(worryLevel);

            if (worryLevel % divisibleBy == 0) {
                monkeys.get(monkeyTrue).addItem(worryLevel);
            } else {
                monkeys.get(monkeyFalse).addItem(worryLevel);
            }

            nbInspectedItems += 1;
        }
    }
}

public class Day11 {
    static long partOne(List<Monkey> monkeys) {
        for (int i = 0; i < 20; i++) {
            monkeys.forEach(monkey -> monkey.turn(monkeys, (n) -> n / 3));
        }

        return monkeys.stream()
                      .map(Monkey::getNbInspectedItems)
                      .sorted(Comparator.reverseOrder())
                      .limit(2)
                      .reduce(1l, (a, b) -> a * b);
    }

    static long partTwo(List<Monkey> monkeys) {
        long common_multiplier = monkeys.stream()
                                        .map(Monkey::getDivisibleBy)
                                        .reduce(1l, (acc, div) -> acc * div);

        for (int i = 0; i < 10000; i++) {
            monkeys.forEach(monkey -> monkey.turn(monkeys, (n) -> n % common_multiplier));
        }

        return monkeys.stream()
                      .map(Monkey::getNbInspectedItems)
                      .sorted(Comparator.reverseOrder())
                      .limit(2)
                      .reduce(1l, (a, b) -> a * b);
    }

    static List<Monkey> getMonkeys(String file) throws IOException {
        BufferedReader input = new BufferedReader(new FileReader(file));

        List<Monkey> monkeys = new ArrayList<>();
        while (input.readLine() != null) {
            String startingItems = input.readLine()
                                        .substring("  Starting items: ".length());
            List<Long> items = Pattern.compile(", ")
                                      .splitAsStream(startingItems)
                                      .map(item -> Long.parseLong(item))
                                      .collect(Collectors.toList());

            String operation = input.readLine().substring("  Operation: new = old ".length());
            Function<Long, Long> operation2;
            if (operation.substring(2).equals("old")) {
                if (operation.charAt(0) == '+') {
                    operation2 = (n) -> n + n;
                }
                else {
                    operation2 = (n) -> n * n;
                }
            } else {
                long rhs = Long.parseLong(operation.substring(2));
                if (operation.charAt(0) == '+') {
                    operation2 = (n) -> n + rhs;
                }
                else {
                    operation2 = (n) -> n * rhs;
                }
            }

            long divisibleBy = Long.parseLong(input.readLine()
                                                   .substring("  Test: divisible by ".length()));

            int monkeyTrue = Integer.parseInt(input.readLine()
                                                   .substring("    If true: throw to monkey ".length()));
            int monkeyFalse = Integer.parseInt(input.readLine()
                                                    .substring("    If false: throw to monkey ".length()));

            Monkey monkey = new Monkey(items, operation2, divisibleBy, monkeyTrue, monkeyFalse);
            monkeys.add(monkey);

            input.readLine();
        }

        input.close();

        return monkeys;
    }

    public static void main(String[] args) throws IOException {
        String file = "input.txt";

        System.out.println("part one: " + partOne(getMonkeys(file)));
        System.out.println("part two: " + partTwo(getMonkeys(file)));
    }
}
