use "files"
use mut = "collections"
use "collections/persistent"

actor Main
  new create(env: Env) =>
    let path = FilePath(FileAuth(env.root), "../input/day1pt1.txt")
    let mh = MedalHolders
    let acc = Accumulator(mh)
    match OpenFile(path)
    | let file: File =>
      for line in FileLines(file) do
        acc.next(consume line)
      end
    end
    acc.group_over()
    mh.spit(env)
    mh.spit_sum(env)

actor Accumulator
  var _current: Vec[U32] = Vec[U32]
  var _mh: MedalHolders = MedalHolders

  new create(mh: MedalHolders) =>
    _current = Vec[U32]
    _mh = mh

  be next(s: String) =>
    match s
    | "" =>
      _mh.next(_current)
      _current = Vec[U32]
    | s => try
        _current = _current.push(s.u32()?)
      end
    end

  be group_over() =>
    _mh.next(_current)
    _current = Vec[U32]


actor MedalHolders
  var _max: mut.List[U32]

  new create() =>
    _max = mut.List[U32]

  be next(us: Vec[U32]) =>
    var next_sum: U32 = 0
    for i in us.values() do
      next_sum = next_sum + i
    end
    _max.push(next_sum)
    let sorted_array = mut.Sort[mut.List[U32], U32](_max).reverse()
    _max = sorted_array.take(3)

  be spit_sum(env: Env) =>
    env.out.print("sum")
    env.out.print(_max.fold[U32]({(a: U32, b:U32) => a + b}, 0).string())

  be spit(env: Env) =>
    env.out.print("Medal Holders")
    for i in _max.values() do
      env.out.print(i.string())
    end
