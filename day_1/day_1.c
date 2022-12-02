#define _POSIX_C_SOURCE 200809L
#include <stdio.h>
#include <stdlib.h>

static int part_one(char *filename)
{
    FILE *input = fopen(filename, "r");
    if (!input)
        return 1;

    int max = 0;
    int current = 0;

    char *line = NULL;
    size_t len = 0;
    while (getline(&line, &len, input) != -1)
    {
        if (*line == '\n')
        {
            if (current > max)
                max = current;

            current = 0;
        }
        else
        {
            current += atoi(line);
        }
    }

    fclose(input);
    return max;
}

static void update_top_elves(int *first, int *second, int *third, int new)
{
    if (new > *first)
    {
        *third = *second;
        *second = *first;
        *first = new;
    }
    else if (new > *second)
    {
        *third = *second;
        *second = new;
    }
    else if (new > *third)
    {
        *third = new;
    }
}

static int part_two(char *filename)
{
    FILE *input = fopen(filename, "r");
    if (!input)
        return 1;

    int first = 0;
    int second = 0;
    int third = 0;
    int current = 0;

    char *line = NULL;
    size_t len = 0;
    while (getline(&line, &len, input) != -1)
    {
        if (*line == '\n')
        {
            update_top_elves(&first, &second, &third, current);

            current = 0;
        }
        else
        {
            current += atoi(line);
        }
    }

    fclose(input);
    return first + second + third;
}

int main(void)
{
    printf("part one: %d\n", part_one("input.txt"));
    printf("part two: %d\n", part_two("input.txt"));

    return 0;
}
