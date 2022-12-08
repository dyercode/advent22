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
    let pars = ByLine(env)
    match OpenFile(path)
    | let file: File =>
      env.out.print("opened file")
      for line in FileLines(file) do
        pars.split_pack(consume line)
      end
    end

actor ByLine
  let _pack_inspector: PackInspector
  let _env: Env

  new create(env: Env) =>
    _pack_inspector = PackInspector
    _env = env

  be split_pack(s: String) =>
    _pack_inspector.inspect(s, _env)

  fun halves(s: String): (String, String) =>
    s.clone().chop(s.size() / 2)


class Parser
  fun halves(s: String): (String, String) =>
    s.clone().chop(s.size() / 2)

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

actor PackInspector
  new create() =>
    None

  be inspect(s: String, env: Env) =>
    None
    /*
    let len = s.
    (let opp: String, let me: String) = s.clone().chop(1)
    match (parse_opponent(opp), parse_me(me.trim(1)))
    | (let op: Throw, let m: Throw) =>
      _judge.report(op, m)
    end
    */
