import scala.io.Source

object Main extends App {
  def part_one(file: String): Int = {
    val input = Source.fromFile(file)

    var cycle = 0
    var register_x = 1
    var next_checkpoint = 20
    var res = 0

    val next_cycle = () => {
      cycle += 1
      if (cycle == next_checkpoint) {
        res += cycle * register_x
        next_checkpoint += 40
      }
    }

    for (instruction <- input.getLines()) {
      if (instruction == "noop") {
        next_cycle()
      }
      else {
        val value = instruction.substring("addx ".length).toInt

        next_cycle()
        next_cycle()

        register_x += value
      }
    }

    input.close

    res
  }

  def part_two(file: String) = {
    val input = Source.fromFile(file)

    var y = 0
    var x = 0
    var register_x = 1

    val draw_pixel = () => {
      if (x >= register_x - 1 && x <= register_x + 1)
        print('#')
      else
        print('.')

      x = (x + 1) % 40
      if (x == 0) {
        println()
        y += 1
      }
    }

    for (instruction <- input.getLines()) {
      if (instruction == "noop") {
        draw_pixel()
      }
      else {
        val value = instruction.substring("addx ".length).toInt

        draw_pixel()
        draw_pixel()

        register_x += value
      }
    }

    input.close
  }

  val file = "input.txt"

  println(f"part one: ${part_one(file)}")
  println("part two:")
  part_two(file)
}
