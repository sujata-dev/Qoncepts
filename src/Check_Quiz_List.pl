#!/usr/bin/env perl

# To check the quiz list

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
my ($testno, $subject, $subdate);

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
        <br><br>
        <div class='container'>
        <h3><b><center> Quiz List </center></b></h3>";
    my $sth = $dbh -> prepare("call QuizQuestionList(?)");
    $sth -> execute($prn) or die;
    while($testno = $sth -> fetchrow_array())
    {
        question_info($testno);
        print "
            <br><div class='col-md-15'>
            <div class='thumbnail'>
            <div class='caption'>
                <h4><b><center> Test $testno </b></center></h4>
                <center><br>
                    <b> Subject: $subject <br>
                        To be completed by: $subdate <br>
                    </b>

                    <a href='Attempt_Quiz.pl' target='_top'>
                        <form action='Attempt_Quiz.pl' method='GET'>
                            <input type='hidden' name='testno'
                                    value='$testno'>
                            <input type='hidden' name='prn' value='$prn'>
                            <button type='submit' class='btn'><b>
                                Attempt this Test
                            </b></button>
                        </form>
                    </a>
                </center>
            </div>
            </div>
            </div>";
    }

    $sth -> finish();
    print "
        </div>
        </body>
        </html>";
}


sub question_info
{
    my $sth = $dbh -> prepare("select Subject, SubmissionDate
                                from QuizDB
                                where TestNo=?");
    $sth -> execute($_[0]) or die;
    while(my ($subj, $subd) = $sth -> fetchrow_array())
    {
        ($subject, $subdate) = ($subj, $subd);
    }
    $sth -> finish();
}
