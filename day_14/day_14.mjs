#!/usr/bin/env node

import fs from "fs";

function getBlocks(input) {
  const blocks = new Set();
  let max_y = 0;

  for (const line of input.split("\n").filter((line) => line.length)) {
    const points = line.split(" -> ");
    for (let i = 0; i < points.length - 1; i++) {
      let [start_x, start_y] = points[i].split(",");
      let [end_x, end_y] = points[i + 1].split(",");

      [start_x, start_y] = [parseInt(start_x), parseInt(start_y)];
      [end_x, end_y] = [parseInt(end_x), parseInt(end_y)];

      while (start_x != end_x || start_y != end_y) {
        blocks.add(`${start_x},${start_y}`);
        max_y = Math.max(max_y, start_y);

        start_x += normalize(end_x - start_x);
        start_y += normalize(end_y - start_y);
      }
      blocks.add(`${start_x},${start_y}`);
      max_y = Math.max(max_y, start_y);
    }
  }

  return [blocks, max_y];
}

function normalize(n) {
  if (n < 0) return -1;
  if (n == 0) return 0;
  return 1;
}

function partOne(input) {
  let [blocks, max_y] = getBlocks(input);

  for (let i = 0; ; i++) {
    let [sand_x, sand_y] = [500, 0];
    while (true) {
      if (sand_y > max_y) {
        return i;
      }

      if (!blocks.has(`${sand_x},${sand_y + 1}`)) {
        sand_y += 1;
      } else if (!blocks.has(`${sand_x - 1},${sand_y + 1}`)) {
        sand_x -= 1;
        sand_y += 1;
      } else if (!blocks.has(`${sand_x + 1},${sand_y + 1}`)) {
        sand_x += 1;
        sand_y += 1;
      } else {
        blocks.add(`${sand_x},${sand_y}`);
        break;
      }
    }
  }
}

function partTwo(input) {
  let [blocks, max_y] = getBlocks(input);
  let floor = max_y + 2;

  for (let i = 0; ; i++) {
    let [sand_x, sand_y] = [500, 0];
    while (true) {
      if (sand_y + 1 == floor) {
        blocks.add(`${sand_x},${sand_y}`);
        break;
      } else if (!blocks.has(`${sand_x},${sand_y + 1}`)) {
        sand_y += 1;
      } else if (!blocks.has(`${sand_x - 1},${sand_y + 1}`)) {
        sand_x -= 1;
        sand_y += 1;
      } else if (!blocks.has(`${sand_x + 1},${sand_y + 1}`)) {
        sand_x += 1;
        sand_y += 1;
      } else {
        blocks.add(`${sand_x},${sand_y}`);
        break;
      }
    }

    if (blocks.has("500,0")) {
      return i + 1;
    }
  }
}

const file = "input.txt";
const input = fs.readFileSync(file, "utf-8");

console.log("part one: " + partOne(input));
console.log("part two: " + partTwo(input));
