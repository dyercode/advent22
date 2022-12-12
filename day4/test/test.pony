use "pony_test"
use "pony_check"

use m = "../main"

actor Main is TestList
  new create(env:Env) =>
    PonyTest(env, this)

  new make() =>
    None

  fun tag tests(test: PonyTest) =>
    test(_TestParse)
    test(_TestIsFullyContained)

class iso _TestParse is UnitTest
    fun name(): String => "split comma separated ranges into tuple"

    fun apply(h: TestHelper) ? =>
      let gen: Generator[U32] val  = recover Generators.u32() end
      PonyCheck.for_all4[U32, U32, U32, U32](gen, gen, gen, gen, h)({
        (arg1: U32, arg2: U32, arg3: U32, arg4: U32, ph: PropertyHelper) =>
          let input = arg1.string() + "-" + arg2.string() + "," + arg3.string() + "-" + arg4.string()
          let subject: m.Ranges = m.Parser.parse(consume input)
          match subject
          |(let a: U32, let b: U32, let c: U32, let d: U32) =>
            ph.assert_eq[U32](a, arg1, "a was " + a.string())
            ph.assert_eq[U32](b, arg2, "b was " + b.string())
            ph.assert_eq[U32](c, arg3, "c was " + c.string())
            ph.assert_eq[U32](d, arg4, "d was " + d.string())
          end
      })?

class iso _TestIsFullyContained is UnitTest
    fun name(): String => "test fully contained detector"

    fun apply(h: TestHelper) =>
      h.assert_true(m.Contained.has_contained((2,7,3,6)))
      h.assert_true(m.Contained.has_contained((3,6,2,7)))
      h.assert_true(m.Contained.has_contained((1,3,1,1)))
      h.assert_true(m.Contained.has_contained((1,3,3,3)))
      h.assert_true(m.Contained.has_contained((1,1,1,3)))
      h.assert_true(m.Contained.has_contained((3,3,1,3)))
      h.assert_true(m.Contained.has_contained((3,3,1,3)))
      h.assert_false(m.Contained.has_contained((1,1,2,2)))
      h.assert_false(m.Contained.has_contained((2,2,1,1)))
      h.assert_false(m.Contained.has_contained((1,3,2,4)))
      h.assert_false(m.Contained.has_contained((2,4,1,3)))
      h.assert_true(m.Contained.has_contained((25,49,25,48)))
      h.assert_true(m.Contained.has_contained((13,82,13,83)))
      h.assert_true(m.Contained.has_contained((5,30,2,30)))
      h.assert_true(m.Contained.has_contained((6,30,7,30)))
