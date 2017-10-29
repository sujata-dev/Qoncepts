#!/usr/bin/env perl

# To check quiz marks

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

my $prn = $cgi -> param('prn');

my ($testno, $marks, $flag);

print $cgi -> header('text/html');

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
            #tab
            {
                -moz-tab-size: 4; /* Code for Firefox */
                -o-tab-size: 4; /* Code for Opera 10.6-12.1 */
                tab-size: 4;
            }

        </style>
        </head>";
}


sub body_section
{
    print "
    <body>
        <br><br><br><br><br><br><br><br><br><br>
        <div class='container'>
        <center><h4><b>";

    my $sth = $dbh -> prepare("select distinct TestNo from QuizAnswersDB where status='Done' and PRN=?");
    $sth -> execute($prn) or die;
    $flag = 0;
    while (my $row = $sth -> fetchrow_array())
    {
        $testno = $row;
        my $sth1 = $dbh -> prepare("select sum(AllotedMarks) from QuizAnswersDB where AllotedMarks in (select AllotedMarks from QuizAnswersDB where PRN=? and TestNo=?)");
        $sth1 -> execute($prn, $testno) or die;
        while (my $row1 = $sth1 -> fetchrow_array())
        {
            $marks = $row1;
            print "
                <b><br><br>
                TestNo:&ensp;&ensp;$testno<br>
                Marks:&ensp;&ensp;$marks<br><br></b>";

            $flag = 1;
        }
        if($flag == 0)
        {
            print "
                TestNo $testno has not been checked. <br><br>";
        }
        $sth1 -> finish();
    }
    $sth -> finish();

    print "
        <a href='LoginStudent.pl' target='_top'>
            <button class='button'><b>
                Return to Dashboard
            </b></button>
        </a>
        </center></b></h4>
        </div>
        </body>
        </html>";
}
