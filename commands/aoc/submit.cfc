/**
* Advent of Code starts December 1st and goes until Christmas Eve.
* Each day provides two puzzles/challenges, part 1 and part 2. 
* Part 1 must be solved before part 2. 
* .
* The submit command automates the submission of the puzzle's answer.
* Get an edge on your friends, colleagues or the world with this command.
* .
* By default, `aoc submit <your-numeric-answer>` will submit your answer 
* for the current day and the saved event year(year set in `aoc init`) and part 1.
* The year is the value saved when you run `aoc init`.
* The day is the current day of the month.
* The part value starts with 1.
* .
* ## Submit your answer for any day 
* For example: `aoc submit <your-answer> day=8 part=2`
* You can also override the year value for a one time request.
* For example: `aoc submit <your-answer> year=2016 day=1`
* .
*/
component {
  property name="moduleSettings" inject="commandbox:moduleSettings:wdm-aoc";
  property name="systemSettings" inject="commandbox:moduleSettings:wdm-aoc";
  /**
  * @day Numeric. Day of the month. Default is current day of the month.
  * @part Numeric. 1 or 2. Default is 1.
  */ 
  function run(
    required any answer,
    numeric part=1,
    numeric day=day(now()), 
    numeric year){

    if( day > 25 ){
      print.redline("The last day of Advent of Code is the 25th").line();
      print.line("Use `aoc input day=15` to specify a specific day. (1-25)").line();
      return;
    }

    var year = (arguments.year)?: moduleSettings.eventYear;

    var answer = arguments.answer; // piped in? param? persisted in settings? 
    
    // level == part of the daily puzzle
    var level = arguments.part; // after submitting level 1 set this to 2

    // retrieve input data from aoc server 
    var req = new http(url="#moduleSettings.aoc_url#/#year#/day/#arguments.day#/answer", method="POST");
    req.addParam(type="cookie", name="session", value=trim(moduleSettings.cookieSession));
    req.addParam(type="formfield", name="level", value=level);
    req.addParam(type="formfield", name="answer", value=answer);
    req.addParam(type="header", name="content-type", value="application/x-www-form-urlencoded");

    var res = req.send().getPrefix();

    if( res.status_code neq 200 ){
      print.redline("An error occurred while attempting to retrieve the input from Advent of Code.");
      print.redline("status code: " & res.status_code);
      print.redline("error: " & res.errorDetail);
      return;
    }

    if( find("not the right answer", res.filecontent) ){
      print.redline("That's not the right answer!");
      return;
    }

    print.greenline("Correct!");

  }
}
