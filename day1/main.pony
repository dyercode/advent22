use "files"
use "collections"

actor Main
  new create(env: Env) =>
    let path = FilePath(FileAuth(env.root), "../input/day1pt1.txt")
    match OpenFile(path)
    | let file: File =>
      for line in FileLines(file) do
        env.out.print(consume line)
    end
  end

actor Accumulator
  let _groups: List[U32]
  let _current: List[U32]

  new create() =>
    _groups = List[U32]()
    _current = List[U32]()

  be next(s: String) =>
    match s
    | "" => _groups.push(U32.min_value())
    | s => try
      _current.push(s.u32()?)
      end
    end
