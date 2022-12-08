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
    let summer = Summer(env)
    let pars = ByLine(env, summer)
    match OpenFile(path)
    | let file: File =>
      env.out.print("opened file")
      for line in FileLines(file) do
        pars.split_pack(consume line)
      end
    end

actor Summer
  let _env: Env
  var _tot: U32 = 0

  new create(env: Env) =>
    _env = env

  be add(p: U8) =>
    _tot = _tot + p.u32()
    _env.out.print(_tot.string())


actor ByLine
  let _env: Env
  let _summer: Summer

  new create(env: Env, summer: Summer) =>
    _env = env
    _summer = summer

  be split_pack(s: String) =>
    (let left, let right) = Parser.halves(s)
    let df = DupeFinder(Notifier(_summer), left, right)


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
      let answer: String iso = String.create(1)
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



