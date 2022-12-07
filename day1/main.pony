use "files"
use "collections/persistent"

actor Main
  new create(env: Env) =>
    let path = FilePath(FileAuth(env.root), "../input/day1pt1.txt")
    let mp = MaxPowers
    let acc = Accumulator(mp)
    match OpenFile(path)
    | let file: File =>
      for line in FileLines(file) do
        acc.next(consume line)
      end
    end
    acc.group_over()
    mp.spit(env)

actor Accumulator
  var _current: Vec[U32] = Vec[U32]
  var _mp: MaxPowers = MaxPowers

  new create(mp: MaxPowers) =>
    _current = Vec[U32]
    _mp = mp

  be next(s: String) =>
    match s
    | "" => group_over()
    | s => try
        _current = _current.push(s.u32()?)
      end
    end

  be group_over() =>
    _mp.next(_current)
    _current = Vec[U32]


actor MaxPowers
  var _max: U32 = 0

  new create() =>
    _max = 0

  be next(us: Vec[U32]) =>
    var next_sum: U32 = 0
    for i in us.values() do
      next_sum = next_sum + i
    end

    if next_sum > _max then
      _max = next_sum
    end

  be spit(env: Env) =>
    env.out.print(_max.string())
