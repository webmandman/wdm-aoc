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
  /**
  * @day Numeric. Day of the month. Default is current day of the month.
  * @part Numeric. 1 or 2. Default is 1.
  */ 
  function run(
    numeric day=day(now()), 
    numeric part=1, 
    numeric year,
    string file){

    if( day > 25 ){
      print.redline("The last day of Advent of Code is the 25th").line();
      print.line("Use `aoc input day=15` to specify a specific day. (1-25)").line();
      return;
    }

    var year = (arguments.year)?: moduleSettings.eventYear;


    var day = numberformat(arguments.day,"00");

    var file = (arguments.file)?: '#year#/day#day#-part#part#.txt';
    
    var fullyQualifiedFilePath = fileSystemUtil.resolvePath(file);

    // retrieve input data from aoc server 
    var req = new http();
    req.setUrl("#moduleSettings.aoc_url#/#year#/day/#arguments.day#/input");
    req.setMethod("GET");
    req.addParam(type="cookie", name="session", value=trim(moduleSettings.cookieSession));

    var res = req.send().getPrefix();

    if( res.status_code neq 200 ){
      print.redline("An error occurred while attempting to retrieve the input from Advent of Code.");
      print.redline("status code: " & res.status_code);
      print.redline("error: " & res.errorDetail);
      return;
    }

    // does folder exist? only warn user if user wants custom file 
    if( arguments.keyExists("file") && !directoryExists(getDirectoryFromPath(fullyQualifiedFilePath)) ){
      print.redline("#getDirectoryFromPath(fullyQualifiedFilePath)# does not exist.");
      return;
    }

    // only create folder if default file is being used
    if( !arguments.keyExists("file") && !directoryExists(getDirectoryFromPath(fullyQualifiedFilePath)) ){
      directoryCreate(getDirectoryFromPath(fullyQualifiedFilePath));
    }

    // save input data to file
    fileWrite(fullyQualifiedFilePath, res.filecontent);

    print.greenline("Input data has been successfully retrieved!");
    print.line(fullyQualifiedFilePath);

    
  }

  function postRun(){
    print.line("postRun...")
  }
}
