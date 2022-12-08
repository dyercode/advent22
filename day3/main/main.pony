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
  let _left: Array[U32]
  let _right: Array[U32]
  var _done: Bool = false
  let _notify: Notified

  new create(notify: Notified iso, l: String, r: String) =>
    _left = Array[U32](l.size())
    _right = Array[U32](r.size())
    _notify = consume notify
    this.split_left(l)
    this.split_right(r)

  be split_left(ls: String) =>
    for l in ls.runes() do
      if not _done then
        this.left(l)
      end
    end

  be split_right(rs: String) =>
    for r in rs.runes() do
      if not _done then
        right(r)
      end
    end

  be left(s: U32) =>
    if _right.contains(s) then
      _notify.received(this, String.from_utf32(s))
    elseif (not _left.contains(s)) then
      _left.push(consume s)
    end

  be right(s: U32) =>
    if _left.contains(s) then
      _notify.received(this, String.from_utf32(s))
    elseif (not _right.contains(s)) then
      _right.push(consume s)
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
