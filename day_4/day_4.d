import std.stdio;
import std.format;

int part_one(const string file)
{
    auto input = File(file);
    auto lines = input.byLine();

    int res = 0;

    foreach(line; lines)
    {
        int first_begin;
        int first_end;
        int second_begin;
        int second_end;

        formattedRead(line, "%d-%d,%d-%d", first_begin, first_end, second_begin,
                      second_end);

        if (first_begin >= second_begin && first_end <= second_end
            || second_begin >= first_begin && second_end <= first_end)
        {
            res++;
        }
    }

    return res;
}

int part_two(const string file)
{
    auto input = File(file);
    auto lines = input.byLine();

    int res = 0;

    foreach(line; lines)
    {
        int first_begin;
        int first_end;
        int second_begin;
        int second_end;

        formattedRead(line, "%d-%d,%d-%d", first_begin, first_end, second_begin,
                      second_end);

        if (first_begin < second_begin && first_end >= second_begin
            || second_begin <= first_begin && second_end >= first_begin)
        {
            res++;
        }
    }

    return res;
}

void main()
{
    const string file = "input.txt";

    writeln("part one: ", part_one(file));
    writeln("part two: ", part_two(file));
}
