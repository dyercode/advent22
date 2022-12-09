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
    let path = FilePath(FileAuth(env.root), "../input/day3.txt")
    let summer: Summer = Summer(recover EnvPrinter(env) end)
    let pars = ByLine(summer)
    match OpenFile(path)
    | let file: File =>
      env.out.print("opened file")
      for line in FileLines(file) do
        pars.split_pack(consume line)
      end
    end

interface box Printer
  fun print(s: String iso): None

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

  be add(p: U8) =>
    _tot = _tot + p.u32()
    _p.print(_tot.string())


actor ByLine
  let _summer: Summer

  new create(summer: Summer) =>
    _summer = summer

  be split_pack(s: String) =>
    (let left, let right) = Parser.halves(s)
    let df = DupeFinder(recover Notifier(_summer) end, left, right)


class Parser
  fun halves(s: String): (String, String) =>
    s.clone().chop(s.size() / 2)

class Priority
  fun calc(s: String): U8 =>
    let lookup = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    try
      lookup.find(s)?.u8() + 1
    else
      0
    end


actor DupeFinder
  var _done: Bool = false
  let _left: Array[U8]
  let _notify: Notified

  new create(notify: Notified iso, l: String, r: String) =>
    _notify = consume notify
    _left = l.array().clone()
    check_right(r)

  fun check_right(rs: String) =>
    for r in rs.values() do
      this.right(r)
    end

  be right(s: U8) =>
    if not _done and _left.contains(s) then
      _done = true
      let answer: String iso = recover String.create(1) end
      answer.push(s)
      _notify.received(this, consume answer)
    end

interface Notified
  fun ref received(rec: DupeFinder ref, msg: String)

class Notifier is Notified
  let _summer: Summer

  new create(summer: Summer) =>
    _summer = summer

  fun ref received(rec: DupeFinder ref, msg: String) =>
    _summer.add(Priority.calc(msg))



