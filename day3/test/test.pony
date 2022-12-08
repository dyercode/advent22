use "pony_test"

use m = "../main"

actor Main is TestList
  new create(env:Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestSplort)

class iso _TestSplort is UnitTest
    fun name(): String => "splort"

    fun apply(h: TestHelper) =>
      let input = "aaaa"
      let subject = m.Parser.halves(consume input)
      h.assert_eq[String](subject._1, subject._2)
