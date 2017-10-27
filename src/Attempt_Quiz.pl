#!/usr/bin/env perl

# To attempt the test

use strict;
use warnings;
use CGI::Carp;
use CGI;
use DBI;

my $driver = "mysql";
my $database = "Qoncepts";
my $dsn = "DBI:mysql:Qoncepts";
my $userid = "root";
my $pwd = "root";
my $dbh = DBI -> connect($dsn, $userid, $pwd) or die;


my $cgi = CGI -> new();

my $testno = $cgi -> param('testno');
my $prn = $cgi -> param('prn');

my ($question, $marks, $i, $status);
my $noq = 0;

print $cgi -> header('text/html');

# For timer
my @months = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
my @days = qw(Sun Mon Tue Wed Thu Fri Sat Sun);

my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) =
localtime();

my $time_in_min = db_time();
my $h = int($time_in_min / 60);
$hour = ($hour + $h) % 24;
$min = ($min + $time_in_min % 60);
if($min > 60)
{
    $min = $min % 60;
    $hour++;
}
$year += 1900;
my $time = $months[$mon]." ".$mday.", ".$year." ".$hour.":".$min.":".$sec;


check_attempt();
head_section();
body_section();


sub head_section
{
    print "
        <html>
        <head>
        <meta charset='utf-8'>
        <meta name='viewport' content='width=device-width, initial-scale=1'>
        <link rel='stylesheet' href=
            'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css'>
        <script
            src='https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js'>
        </script>
        <script src=
            'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js'>
        </script>
        <script src='https://code.jquery.com/jquery-1.10.2.js'></script>
        <style>
            body
            {
                background-image: url('quizbackground.jpeg');
                color: white;
            }
            textarea,textarea.placeholder
            {
                color: black;
                text-align: center;
            }
            h3
            {
                text-align: right;
            }
            .button,.btn
            {
                background-color: goldenrod;
                border: 10px;
                padding: 15px 20px;
                text-align: center;
                text-decoration: none;
                display: inline-block;
                color: black;
                font-size: 16px;
                margin: 20px;
                box-shadow: 0 12px 16px 0 rgba(0,0,0,0.24), 0 17px 50px 0
                            rgba(0,0,0,0.19);
            }
        </style>
        <script>

            // To set the date to count down to
            var countDownDate = new Date('$time').getTime();

            // To update the count down every 1 second
            var x = setInterval(function()
            {

                // To get todays date and time
                var now = new Date().getTime();

                var distance = countDownDate - now;

                // Time calculations for days, hours, minutes and seconds
                var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) /
                                        (1000 * 60 * 60));
                var minutes = Math.floor((distance % (1000 * 60 * 60)) /
                                        (1000 * 60));
                var seconds = Math.floor((distance % (1000 * 60)) / 1000);

                // To output the result
                document.getElementById('demo').innerHTML = hours + 'h '
                + minutes + 'm ' + seconds + 's ';

                // Redirect to the next site if the count down is over
                if (distance < 0) {
                    clearInterval(x);
                    alert('Time ends');
                    window.location = 'Finish_Quiz.pl';
                }
            }, 1000);

        </script>
        </head>";
}


sub body_section
{
    print "
        <body>
        <br><br>
        <div class='container'>
        <h3>Time Left: <p id='demo' align='right'></p></h3>
        <h2><b><center> Test $testno </center></b></h2><br><br>
        <form action='Finish_Quiz.pl' method='POST'>
        <h4><b><center>";
    my $sth = $dbh -> prepare("select Question, Marks from QuizQuestionsDB
                                where TestNo=?");
    $sth -> execute($testno) or die;
    while(my ($q, $m) = $sth -> fetchrow_array())
    {
        ($question, $marks) = ($q, $m);
        ++$noq;
        print "
            Q$noq. $question ($marks marks)<br><br>
            <input type='hidden' name='question$noq' value='$question'>
            <input type='hidden' name='marks$noq' value='$marks'>
            <textarea name='ans$noq' rows='6' cols='60'
                    placeholder='Type your answer here'></textarea>
            <br><br><br>";
    }
    $sth -> finish();

    print "
        <input type='hidden' name='testno' value='$testno'>
        <input type='hidden' name='prn' value='$prn'>
        <input type='hidden' name='noq' value='$noq'>
        <button type='submit' class='btn'><b>
            Submit Test
        </b></button>
        </center></b></h4>
        </form>
        </div>
        </body>
        </html>";
}


sub db_time
{
    my $time;
    my $sth = $dbh -> prepare("select TimeLimit from QuizDB where TestNo=?");
    $sth -> execute($testno) or die;

    while (my $row = $sth -> fetchrow_array())
    {
        $time = $row;
    }
    $sth -> finish();

    return $time;
}


sub check_attempt
{
    my $sth = $dbh -> prepare("select distinct status from QuizAnswersDB
                                where TestNo=? and PRN=?;");
    $sth -> execute($testno, $prn) or die;
    while (my $row = $sth -> fetchrow_array())
    {
        $status = $row;
    }
    $sth -> finish();

    if($status eq "Done")
    {
        print "
            <script>
                window.location = 'Already_Done_Test.pl';
            </script>";
    }
}
