#!/usr/bin/env perl

# To add questions of a quiz to database

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
my $noq = $cgi -> param('noq');
my ($marks, $question);

extract();

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
        <div class='container'>
        <br><br><br><br><br><br><br><br><br><br><br>
        <h3><center><b>
            Quiz Created! <br><br>
        <a href='LoginTeacher.pl'>
            <button class='btn'><b> Return To Menu </b></button>
        </a></center></h3>
        </div>
        </body>
        </html>";
}


sub extract
{
    for (1..$noq)
    {
        $marks = $cgi -> param("marks$_");
        $question = $cgi -> param("question$_");
        q_insertion($testno, $_, $question, $marks);
    }
}


sub q_insertion
{
    my $sth = $dbh -> prepare("insert into QuizQuestionsDB
                                values(?, ?, ?, ?)");
    $sth -> execute($_[0], $_[1], $_[2], $_[3]) or die;
    $sth -> finish();
}
