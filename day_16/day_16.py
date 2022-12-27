#!/usr/bin/env python3

import re
import functools


class Valve:
    counter = 0

    def __init__(self, name, flow_rate, available_dest):
        self.id = Valve.counter
        Valve.counter += 1
        self.name = name
        self.flow_rate = flow_rate
        self.available_dest = available_dest
        self.open = False


def part_one(valves):
    N = len(valves)

    dist = [[N] * N for _ in range(N)]

    for valve in valves.values():
        for adj in valve.available_dest:
            dist[valve.id][valves[adj].id] = 1

    for v in range(N):
        dist[v][v] = 0

    for k in range(N):
        for i in range(N):
            for j in range(N):
                if dist[i][j] > dist[i][k] + dist[k][j]:
                    dist[i][j] = dist[i][k] + dist[k][j]

    interest = []
    for valve in valves.values():
        if valve.flow_rate > 0:
            interest.append(valve)

    @functools.cache
    def solve(valve, time_left, pressure_released=0):
        if time_left <= 0:
            return pressure_released

        v = valves[valve]
        stay = 0

        if not v.open:
            pressure_released += (time_left - 1) * v.flow_rate
            v.open = True
            stay = max(
                solve(dest.name, time_left - 1 - dist[v.id][dest.id], pressure_released)
                for dest in interest
                if dest != v
            )
            pressure_released -= (time_left - 1) * v.flow_rate
            v.open = False

        return max(
            stay,
            max(
                solve(dest.name, time_left - dist[v.id][dest.id], pressure_released)
                for dest in interest
                if dest != v
            ),
        )

    return solve("AA", 30)


if __name__ == "__main__":
    file = "input.txt"

    valves = {}

    with open(file) as input:
        for line in input:
            m = re.match(
                r"Valve (..) has flow rate=(\d+); tunnels? leads? to valves? (.*)", line
            )
            assert m is not None
            valve = Valve(m.group(1), int(m.group(2)), m.group(3).split(", "))
            valves[m.group(1)] = valve

    print(f"part one: {part_one(valves)}")
