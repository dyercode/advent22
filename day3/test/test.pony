use "pony_test"

use m = "../main"

actor Main is TestList
  new create(env:Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestSplit)
    test(_TestFindDuplicate)

class iso _TestSplit is UnitTest
    fun name(): String => "split an even-charchount string in half"

    fun apply(h: TestHelper) =>
      let input = "aaaa"
      let subject = m.Parser.halves(consume input)
      h.assert_eq[String](subject._1, subject._2)

class iso _TestFindDuplicate is UnitTest
    fun name(): String => "find the duplicate 'package'"

    fun apply(h: TestHelper) =>
      let left =  "abcdefghijklm"
      let right = "nopqrstuvwxya"
      let p: m.DupeFinder = m.DupeFinder(recover TestNotifier(h, "a") end, left, right)
      h.long_test(2_000_000_000)

    fun timed_out(h:TestHelper) =>
      h.complete(false)

class TestNotifier is m.Notified
  let _h: TestHelper
  let _expected: String

  new iso create(h: TestHelper, expected: String) =>
    _h = h
    _expected = expected

  fun ref received(rec: m.DupeFinder ref, msg: String) =>
   _h.assert_eq[String](_expected, msg)
   _h.complete(true)
