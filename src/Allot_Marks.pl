#!/usr/bin/env perl

# To allot marks to answers of a quiz for a student

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
my $noq = $cgi -> param('noq');
extract();


my ($question, $marks);

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
        </style>
        </head>";
}


sub body_section
{
    print "
        <body>
        <br><br><br><br><br><br><br><br><br><br>
        <div class='container'>
            <center><h4><b>
                You have checked the test for this student. <br><br>

                <a href='Check_Quiz_Sheets_List.pl' target='_top'>
                    <button class='button'><b>
                        Return to Quiz Sheet List
                    </b></button>
                </a>
            </center></b></h4>
        </div>
        </body>
        </html>";
}



sub extract
{
    for (1..$noq)
    {
        $question = $cgi -> param("question$_");
        $marks = $cgi -> param("marks$_");
        q_insertion($marks, $question, $prn, $testno);
    }
}


sub q_insertion
{
    my $sth = $dbh -> prepare("update QuizAnswersDB
                                set AllotedMarks=?
                                where Question=? and PRN=? and TestNo=?");
    $sth -> execute($_[0], $_[1], $_[2], $_[3]) or die;
    $sth -> finish();
}
