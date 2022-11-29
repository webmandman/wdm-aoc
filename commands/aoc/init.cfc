/**
* Advent of Code Automation Runner by Daniel Mejia 
* 
* Requirements: Your adventofcode.com session information, specifically 
* the value of the session cookie. 
*
* Go to adventofcode.com and login. Then open the dev tools for the 
* browser and search for the session cookie. Copy the value of that cookie.
*
* Run `aoc` command and when promoted for the session paste the value.
*/
component {
  function run(){
    print.line("Welcome to Advent of Code Automation Runner by Daniel Mejia").line();

    var s = ask(message="What's your adventofcode.com browser session cookie value?");

    var currentyear = year(now());

    // validate session cookie
    var req = new http();
    req.setUrl("https://adventofcode.com/#currentyear#/events");
    req.setMethod("GET");
    req.addParam(type="cookie", name="session", value=trim(s));

    var res = req.send().getPrefix();

    if( !find("star-count",res.filecontent) ){
      print.line().line("That's not a valid session cookie value.");
      return;
    }

    var c1 = command('config set modules.wdm-aoc.cookieSession=#s#').run(returnOutput=true);

    print.line();

    var y = ask(message="Event year?");

    if( !isNumeric(y) || y > currentyear || y < 2015 ){
      print.line().line("That's not a valid year.").line();
      return;
    }

    var c2 = command('config set modules.wdm-aoc.eventYear=#y#').run(returnOutput=true);

    print.line();

    var g = multiselect("Initialize a git repo?")
      .options('Y,N')
      .required()
      .ask();

    if( g == 'Y' ){
      var c3 = command('!git init').run(returnOutput=true);
    }

    print.line().greenline("All set!").line();
    print.line("Your session value will persist until you update it or clear it manually.").line();
    print.line("Run `aoc init help` to learn how to update your session or event year.");
    print.line("Run `aoc input help` to learn how to get your daily input.");
    print.line("Run `aoc submit help` to learn how to submit your daily answers.").line();
  }
  
}
