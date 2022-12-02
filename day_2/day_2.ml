exception Unreachable of unit

let file = "input.txt"

let read_lines filename =
    let input = open_in filename in
    let try_read () =
        try Some (input_line input) with End_of_file -> None in
    let rec loop acc = match try_read () with
        | Some s -> loop (s :: acc)
        | None -> close_in input; List.rev acc in
    loop []

let part_one lines =
    let rec score line acc =
        match line with
        | [] -> acc
        | line :: rest ->
            let opponent = line.[0]  and
                mine = line.[2] in
            let result = match opponent, mine with
            | 'A', 'Y' | 'B', 'Z' | 'C', 'X' -> 6
            | 'A', 'Z' | 'B', 'X' | 'C', 'Y' -> 0
            | _, _ -> 3 in
            score rest (acc + result + Char.code(mine) - Char.code('X') + 1) in
    score lines 0

let part_two lines =
    let rec score line acc =
        match line with
        | [] -> acc
        | line :: rest ->
            let opponent = line.[0]  and
                action = line.[2] in
            let result = match action with
            | 'X' ->
                    (match opponent with
                     | 'A' -> 3
                     | 'B' -> 1
                     | 'C' -> 2
                     | _ -> raise (Unreachable ())) + 0
            | 'Y' -> Char.code(opponent) - Char.code('A') + 1 + 3
            | 'Z' ->
                    (match opponent with
                     | 'A' -> 2
                     | 'B' -> 3
                     | 'C' -> 1
                     | _ -> raise (Unreachable ())) + 6
            | _ -> raise (Unreachable ()) in
            score rest (acc + result) in
    score lines 0

let () =
    let lines = read_lines file in
    Printf.printf "part one: %d\n" (part_one lines);
    Printf.printf "part two: %d\n" (part_two lines);
