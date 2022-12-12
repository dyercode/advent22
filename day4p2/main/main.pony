use "files"
use mut = "collections"
use "collections/persistent"
use "promises"

primitive Rock
primitive Paper
primitive Scissors

primitive Win
primitive Lose
primitive Draw

type Result is (Win | Draw | Lose)
type Throw is (Rock | Paper | Scissors)

actor Main
  new create(env: Env) =>
    let path = FilePath(FileAuth(env.root), "../input/day4.txt")
    let summer: Summer = Summer(EnvPrinter(env))
    let by_line: ByLine tag = ByLine(summer)
    match OpenFile(path)
    | let file: File =>
      env.out.print("opened file")
      for line in FileLines(file) do
        by_line.check(consume line)
      end
    end

interface box Printer
  fun print(s: String iso): None

type Ranges is (U32, U32, U32, U32)

class EnvPrinter
  let _env: Env

  new create(env: Env) =>
    _env = env

  fun print(s: String) =>
    _env.out.print(consume s)

actor Summer
  let _p: Printer
  var _tot: U32 = 0

  new create(p: Printer val) =>
    _p = p

  be inc() =>
    _tot = _tot + 1
    _p.print(_tot.string())


actor ByLine
  let _summer: Summer

  new create(summer: Summer) =>
    _summer = summer

  be check(line: String) =>
    let ranges: Ranges = Parser.parse(line)
    if Contained.overlap(ranges) then
      _summer.inc()
    end


class Parser
  fun parse(s: String): Ranges =>
    try
      let first_dash: USize = s.find("-")?.usize()
      let comma: USize = s.find(",")?.usize()
      let second_dash: USize = s.find("-", comma.isize())?.usize()
      let first_digit = s.trim(0, first_dash).u32()?
      let second_digit = s.trim(first_dash + 1, comma).u32()?
      let third_digit = s.trim(comma + 1, second_dash).u32()?
      let fourth_digit = s.trim(second_dash + 1).u32()?
      (first_digit, second_digit, third_digit, fourth_digit)
    else (0,1,2,3)
    end

class Priority
  fun calc(s: String): U8 =>
    let lookup = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    try
      lookup.find(s)?.u8() + 1
    else
      0
    end


class Contained
  fun overlap(rs: Ranges): Bool =>
    let a = rs._1
    let b = rs._2
    let c = rs._3
    let d = rs._4
    (not (a > d)) and (not (b < c))
