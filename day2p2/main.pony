use "files"
use mut = "collections"
use "collections/persistent"
use "promises"

primitive Rock
primitive Paper
primitive Scissors

primitive Win
primitive Lose
primitive Draw

type Result is (Win | Draw | Lose)
type Throw is (Rock | Paper | Scissors)

actor Main
  new create(env: Env) =>
    let path = FilePath(FileAuth(env.root), "../input/day2.txt")
    let orch = Orchestrator(env)
    match OpenFile(path)
    | let file: File =>
      env.out.print("opened file")
      for line in FileLines(file) do
        orch.take_input(consume line)
      end
      orch.done()
    end

actor Orchestrator
  let _translator: Translator
  let _judge: Judge
  let _tally: Tally
  let _env: Env

  new create(env: Env) =>
    // I'm not super happy about this but but it is replacing functions so meh
    _env = env
    _tally = Tally(env)
    _judge = Judge(_tally)
    _translator = Translator(_judge)

  be take_input(s: String) =>
    _translator.grok(s, _env)

  be done() =>
    _translator.done()

actor Translator
  let _judge: Judge
  new create(judge: Judge) =>
    _judge = judge

  be grok(s: String, env: Env) =>
    (let opp: String, let me: String) = s.clone().chop(1)
    match (parse_opponent(opp), parse_me(me.trim(1)))
    | (let op: Throw, let m: Result) =>
      _judge.report(op, to_throw(op,m))
    end

  be done() =>
    _judge.done()


  fun parse_opponent(s: String): (Throw | None) =>
    match s
    | "A" => Rock
    | "B" => Paper
    | "C" => Scissors
    end

  fun parse_me(s: String): (Result | None) =>
    match s
    | "X" => Lose
    | "Y" => Draw
    | "Z" => Win
    end

  fun to_throw(opp: Throw, desired: Result): Throw =>
    match desired
    | Win => win_hand(opp)
    | Lose => lose_hand(opp)
    | Draw => draw_hand(opp)
    end

  fun win_hand(opp: Throw): Throw =>
    match opp
    | Rock => Paper
    | Paper => Scissors
    | Scissors => Rock
    end

  fun lose_hand(opp: Throw): Throw =>
    match opp
    | Rock => Scissors
    | Paper => Rock
    | Scissors => Paper
    end

  fun draw_hand(opp: Throw): Throw => opp

actor Judge
  let _tally: Tally
  new create(tally: Tally) =>
    _tally = tally

  // kinda wanna create a ring to test but tired
  be report(opp: Throw, me: Throw) =>
    let res: Result =
    match opp
    | Rock =>
      match me
      | Rock => Draw
      | Paper => Win
      | Scissors => Lose
      end
    | Paper =>
      match me
      | Rock => Lose
      | Paper => Draw
      | Scissors => Win
      end
    | Scissors =>
      match me
      | Rock => Win
      | Paper => Lose
      | Scissors => Draw
      end
    end
    _tally.report_match(res, me)

  be done() =>
    _tally.score_progress()

actor Tally
  var _score: U16 = 0
  let _env: Env
  new create(env: Env) =>
    _env = env

  be report_match(res: Result, throw: Throw) =>
    _score = _score + result_score(res) + throw_score(throw)

  be score_progress() =>
    _env.out.print(_score.string())

  fun result_score(res: Result): U16 =>
    match res
    | Win => 6
    | Draw => 3
    | Lose => 0
    end

  fun throw_score(thrown: Throw): U16 =>
    match thrown
    | Rock => 1
    | Paper => 2
    | Scissors => 3
    end
