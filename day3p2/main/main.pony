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
    let summer: Summer = Summer(recover EnvPrinter(env) end)
    let pars: ByLine = ByLine(summer)
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

class Priority
  fun calc(s: String): U8 =>
    let lookup = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    try
      lookup.find(s)?.u8() + 1
    else
      0
    end

class DupeFinder
  fun find(one: String, two: String, three: String): String =>
    let o: String = unique(one)
    let tw: String= unique(two)
    let th: String = unique(three)
    let concat: String iso = recover String(o.size()
      + tw.size()
      + th.size()) end

    concat.append(consume o)
    concat.append(consume tw)
    concat.append(consume th)
    triple(consume concat)

  fun unique(cs: String): String =>
    let sorted = Sort[Array[U8], U8](cs.array().clone())
    let res: String iso = recover String.create(sorted.size()) end
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

  fun triple(cs: String): String =>
    let sorted = Sort[Array[U8], U8](cs.array().clone())
    let res: String iso = recover String.create(1) end
    try
      var next_last: U8 = sorted.shift()?
      var last: U8 = sorted.shift()?
      for s in sorted.values() do
        if (s == last) and (s == next_last) then
          res.push(consume s)
          break
        else
          next_last = last
          last = consume s
        end
      end
    end
    res

interface box Printer
  fun print(s: String iso): None

class EnvPrinter
  let _env: Env

  new create(env: Env) =>
    _env = env

  fun print(s: String) =>
    _env.out.print(consume s)

