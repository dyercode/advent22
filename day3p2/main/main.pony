use "files"
use "collections"

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
    let path = FilePath(FileAuth(env.root), "../input/day3.txt")
    let summer = Summer(EnvPrinter(env))
    let pars = ByLine(summer)
    match OpenFile(path)
    | let file: File =>
      env.out.print("opened file")
      for line in FileLines(file) do
        pars.split_pack(consume line)
      end
    end

actor Summer
  let _printer: Printer
  var _tot: U32 = 0

  new create(printer: Printer val) =>
    _printer = printer

  be add(p: U8) =>
    _tot = _tot + p.u32()
    _printer.print(_tot.string())


actor ByLine
  let _summer: Summer
  let _elf_group: Array[String] = Array[String](3)

  new create(summer: Summer) =>
    _summer = summer

  be split_pack(s: String) =>
    _elf_group.push(s)
    if _elf_group.size() == 3 then
      try
        let first = _elf_group.pop()?
        let second = _elf_group.pop()?
        let third = _elf_group.pop()?
        let df: String = DupeFinder.find(first, second, third)
        _summer.add(Priority.calc(df))
      end
    end


class Parser
  fun unique(cs: String): String =>
    let sorted = Sort[Array[U8], U8](cs.array().clone()).clone()
    let res: String iso = String.create(sorted.size())
    try
      var last: U8 = sorted.shift()?
      res.push(last)
      for s in sorted.values() do
        if s != last then
          last = s
          res.push(consume s)
        end
      end
    end
    res


class Priority
  fun calc(s: String): U8 =>
    let lookup = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    try
      lookup.find(s)?.u8() + 1
    else
      0
    end

type UniqueChars is HashSet[U8, HashEq[U8]]

class DupeFinder
  fun find(one: String, two: String, three: String): String =>
    let first: UniqueChars = scribe(one)
    let second: UniqueChars = scribe(two)
    let third: UniqueChars = scribe(three)
    var all = first.op_and(consume second)
    all = all.op_and(consume third)
    try
      let badge = all.index(all.next_index()?)?

      let answer: String iso = String.create(1)
      let restring = String.from_array([badge])
      answer.push(consume badge)
      answer
    else
      ""
    end

  fun scribe(pack: String): UniqueChars =>
    let letters = HashSet[U8, HashEq[U8]](pack.size())
    for c in pack.array().values() do
      letters.set(consume c)
    end
    letters

interface box Printer
  fun print(s: String iso): None

class EnvPrinter
  let _env: Env

  new create(env: Env) =>
    _env = env

  fun print(s: String) =>
    _env.out.print(consume s)

