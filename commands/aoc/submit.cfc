/**
* Advent of Code starts December 1st and goes until Christmas Eve.
* Each day provides two puzzles/challenges, part 1 and part 2. 
* Part 1 must be solved before part 2. 
* .
* The input command automates the retrieval of the puzzle's input.
* The "input" is the data that you will need to test your code against.
* Get an edge on your friends, colleagues or the world with this command.
* .
* By default, `aoc input` will retrieve input data and save it to the year folder.
* For example: ./2022/day1-part1.txt
* The year is the value saved when you run `aoc init`.
* The day is the current day of the month.
* The part value starts with 1. Once you answer part 1, it will retrieve part 2.
* .
* ## Retrieve input data for any day 
* For example: `aoc input day=8 part=2`
* You can also override the year value for a one time request.
* For example: `aoc input year=2016 day=1`
* .
* ## Overwrite File Save 
* By default, input data is saved to the year folder.
* You can however save it to any folder, relative to current working directory.
* For example: `aoc input file=~/my-input.txt` 
*/
component {
  property name="moduleSettings" inject="commandbox:moduleSettings:wdm-aoc";
  property name="systemSettings" inject="commandbox:moduleSettings:wdm-aoc";
  /**
  * @day Numeric. Day of the month. Default is current day of the month.
  * @part Numeric. 1 or 2. Default is 1.
  */ 
  function run(
    any answer,
    numeric part=1,
    numeric day=day(now()), 
    numeric year){

    systemSettings["AOC"] = {"2021"={"day1"={"part1"=true,"part2"=false}}};
    print.line(systemSettings);
    return;
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
