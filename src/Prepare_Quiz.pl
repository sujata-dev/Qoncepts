#!/usr/bin/env perl

# To enter quiz questions

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
my $branch = $cgi -> param('CS');
my $year = $cgi -> param('First');
my $batch = $cgi -> param('batch');
my $semester = $cgi -> param('semester');
my $subject = $cgi -> param('subject');
my $maxmarks = $cgi -> param('maxmarks');
our $noq = $cgi -> param('noq');
my $subdate = $cgi -> param('subdate');
my $timelimit = $cgi -> param('timelimit');

print $cgi -> header('text/html');

my ($marks, $question);

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
            input
            {
                text-align: center;
            }
        </style>
        </head>";
}


sub body_section
{
    info_insertion();
    print "
        <body>
        <div class='container'><br>
            <h3><center><b>
                Enter questions for the Quiz
            </b></center></h3><br><br>
            <form action='Create_Quiz.pl' method='POST'>
            <center>";
    for (1..$noq)
    {
        print "
            <input type='hidden' name='testno' value='$testno'>
            <input type='hidden' name='noq' value='$noq'>
            <h4><b> Question #$_<br><br>
            <input id='marks$_' type='text' class='form-control'
                    name='marks$_' placeholder='Marks'
                    style='width:70px;'> <br>

            <textarea name='question$_' rows='6' cols='60'
                        placeholder='Enter your question here'></textarea><br><br><br>
            </b></h4>";
    }
    print "
        <button type='submit' class='btn' name='DoneQuiz' value='Submit'><b>
            Create Quiz
        </center></b></button>
        </form>
        </div>
        </body>
        </html>";
}

sub info_insertion
{
    my $sth = $dbh -> prepare("insert into QuizDB
                                values(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
    $sth -> execute($testno, $branch, $year, $batch, $semester, $subject,
                    $maxmarks, $noq, $subdate, $timelimit) or die;
    $sth -> finish();
}
