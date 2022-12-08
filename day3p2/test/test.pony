use "pony_test"

use m = "../main"

actor Main is TestList
  new create(env:Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestUniq)
    test(_TestFindDuplicate)
    test(_TestPriority)

class iso _TestUniq is UnitTest
    fun name(): String => "sort and dedupe a 'string'"

    fun apply(h: TestHelper) =>
      let input: String = "qRzaaaa"
      let expected: String = "Raqz"
      let subject: String = m.Parser.unique(input)
      h.assert_eq[String](expected, subject)

class iso _TestFindDuplicate is UnitTest
    fun name(): String => "find the duplicate 'package'"

    fun apply(h: TestHelper) =>
      let first =  "abcdef"
      let second = "ahijkl"
      let third = "mnopqa"
      let res = m.DupeFinder.find(first, second, third)
      h.assert_eq[String]("a", res)


class iso _TestPriority is UnitTest
    fun name(): String => "test priorities"

    fun apply(h: TestHelper) =>
      let lowest =  "a"
      let mid_low =  "z"
      let mid_high =  "A"
      let highest = "Z"
      h.assert_eq[U8](1, m.Priority.calc(consume lowest))
      h.assert_eq[U8](26, m.Priority.calc(consume mid_low))
      h.assert_eq[U8](27, m.Priority.calc(consume mid_high))
      h.assert_eq[U8](52, m.Priority.calc(consume highest))

