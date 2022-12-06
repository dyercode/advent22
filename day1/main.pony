use "files"

actor Main
  new create(env: Env) =>
      let path = FilePath(FileAuth(env.root), "../input/day1pt1.txt")
      match OpenFile(path)
      | let file: File =>
        for line in FileLines(file) do
          env.out.print(consume line)
      end
    end
