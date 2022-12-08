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
  let _left: Array[String] = Array[String](24) // longest line in input is 48
  let _right: Array[String] = Array[String](24)
  var _done: Bool = false
  let _notify: Notified

  new create(notify: Notified iso) =>
    _notify = consume notify

  be find_duplicate(l: String, r: String) =>
    _notify.received(this, "b")

  be left(s: String) =>
    if _right.contains(s) then
      _notify.received(this, s)
    elseif (not _left.contains(s)) then
      _left.push(s)
    end

  fun _find_duplicate(a: String, b: String): String =>
    "b"

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
