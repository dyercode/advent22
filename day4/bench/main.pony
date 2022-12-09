use "pony_bench"
use "time"
use m = "../main"

actor Main is BenchmarkList
  new create(env: Env) =>
    PonyBench(env, this)

  fun tag benchmarks(bench: PonyBench) =>
    bench(_ByLine("aa"))
    bench(_ByLine("abcb"))
    bench(_ByLine("abcdefghijklmnopqrstuvwxym"))
    bench(_ByLine("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYz"))

class NullPrinter is m.Printer
  new create() =>
    None

  fun print(s: String) =>
    None

class _ByLine is MicroBenchmark
  let _s: String
  new iso create(s: String) =>
    _s = s

  fun name(): String =>
    "_ByLine(" + _s + ")"

  fun apply() =>
    DoNotOptimise[None](_doit())
    DoNotOptimise.observe()

  fun _doit() =>
    let df: m.ByLine = m.ByLine(m.Summer(NullPrinter))
    df.split_pack(_s)

