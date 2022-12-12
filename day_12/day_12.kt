import java.io.File
import java.util.LinkedList
import java.util.Queue
import kotlin.math.min

fun climbable(heights: List<IntArray>, src: Pair<Int, Int>, dst: Pair<Int, Int>): Boolean {
    if (dst.first < 0 || dst.first >= heights.size
        || dst.second < 0 || dst.second >= heights[0].size
        || heights[dst.first][dst.second] == -1) {
        return false
    }

    return heights[dst.first][dst.second] <= heights[src.first][src.second] + 1
}

fun shortestPath(heights: List<IntArray>, start: Pair<Int, Int>, end: Pair<Int, Int>): Int {
    if (start == end) {
        return 0;
    }

    var visited = Array(heights.size) { Array(heights[0].size) { false }}
    var distance = Array(heights.size) { IntArray(heights[0].size) { Int.MAX_VALUE }}
    var queue: Queue<Pair<Int, Int>> = LinkedList<Pair<Int, Int>>()

    distance[start.first][start.second] = 0
    queue.add(start)

    while (queue.isNotEmpty()) {
        val pos = queue.remove()

        if (pos == end) {
            return distance[pos.first][pos.second]
        }

        if (!visited[pos.first][pos.second]) {
            visited[pos.first][pos.second] = true

            val top = Pair(pos.first - 1, pos.second)
            if (climbable(heights, pos, top) && !visited[top.first][top.second]) {
                distance[top.first][top.second] = distance[pos.first][pos.second] + 1
                queue.add(top)
            }

            val bottom = Pair(pos.first + 1, pos.second)
            if (climbable(heights, pos, bottom) && !visited[bottom.first][bottom.second]) {
                distance[bottom.first][bottom.second] = distance[pos.first][pos.second] + 1
                queue.add(bottom)
            }

            val left = Pair(pos.first, pos.second - 1)
            if (climbable(heights, pos, left) && !visited[left.first][left.second]) {
                distance[left.first][left.second] = distance[pos.first][pos.second] + 1
                queue.add(left)
            }

            val right = Pair(pos.first, pos.second + 1)
            if (climbable(heights, pos, right) && !visited[right.first][right.second]) {
                distance[right.first][right.second] = distance[pos.first][pos.second] + 1
                queue.add(right)
            }
        }
    }

    return Int.MAX_VALUE;
}

fun partOne(heights: List<IntArray>, start: Pair<Int, Int>, end: Pair<Int, Int>): Int {
    return shortestPath(heights, start, end)
}

fun partTwo(heights: List<IntArray>, end: Pair<Int, Int>): Int {
    var shortestHike = Int.MAX_VALUE

    for (y in heights.indices) {
        for (x in heights[y].indices) {
            if (heights[y][x] == 0) {
                shortestHike = min(shortestHike, shortestPath(heights, Pair(y, x), end))
            }
        }
    }

    return shortestHike
}

fun main() {
    val file = "input.txt"
    val input = File(file)

    var heights: List<IntArray> = emptyList()
    var y = 0

    var start = Pair(0, 0)
    var end = Pair(0, 0)

    input.forEachLine { line ->
        var lineHeights = IntArray(line.length)

        for (x in line.indices) {
            val c = line[x]

            if (c == 'S') {
                start = Pair(y, x)
                lineHeights[x] = 0
            } else if (c == 'E') {
                end = Pair(y, x)
                lineHeights[x] = 25
            } else {
                lineHeights[x] = c - 'a'
            }
        }

        heights += lineHeights
        y += 1
    }

    println("part one: " + partOne(heights, start, end))
    println("part two: " + partTwo(heights, end))
}
