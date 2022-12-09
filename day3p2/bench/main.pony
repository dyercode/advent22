use "pony_bench"
use "time"
use m = "../main"

actor Main is BenchmarkList
  new create(env: Env) =>
    PonyBench(env, this)

  fun tag benchmarks(bench: PonyBench) =>
    bench(_ByLine(("ab", "bb", "cb")))
    bench(_ByLine(("abcd", "defg", "hijd")))
    bench(_Parser("a"))
    bench(_Parser("abcddefghijd"))
    bench(_Parser("abZcdXdeafGghRiRfjd"))
    bench(_DupeFinder(("ab", "bb", "cb")))
    bench(_DupeFinder(("abcd", "defg", "hijd")))
    bench(_DupeFinder(("BabjDcXd", "djeRfg", "hSiQjd")))

class NullPrinter is m.Printer
  new create() =>
    None

  fun print(s: String) =>
    None

class _Parser is MicroBenchmark
  let _s: String

  new iso create(s: String) =>
    _s = s

  fun name(): String =>
    "_DupeFinder.unique(" + _s + ")"

  fun apply() =>
    DoNotOptimise[String](_unique())
    DoNotOptimise.observe()

  fun _unique(): String =>
    m.DupeFinder.unique(_s)

class _DupeFinder is MicroBenchmark
  let _s: (String, String, String)

  new iso create(s: (String, String, String)) =>
    _s = s

  fun name(): String =>
    "_DupeFinder.triple(" + _s._1 + "," + _s._2 + "," + _s._3 + ")"

  fun apply() =>
    DoNotOptimise[String](_find())
    DoNotOptimise.observe()

  fun _find(): String =>
    m.DupeFinder.find(_s._1, _s._2, _s._3)


class _ByLine is MicroBenchmark
  let _s: (String, String, String)
  new iso create(s: (String, String, String)) =>
    _s = s

  fun name(): String =>
    "_ByLine(" + _s._1 + "," + _s._2 + "," + _s._3 + ")"

  fun apply() =>
    DoNotOptimise[None](_doit())
    DoNotOptimise.observe()

  fun _doit() =>
    let df: m.ByLine = m.ByLine(m.Summer(NullPrinter))
    df.split_pack(_s._1)
    df.split_pack(_s._2)
    df.split_pack(_s._3)

