#!/usr/bin/env perl

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

my ($question, $marks, $i);

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
        <br><br>
        <div class='container'>
        <h3><b><center> Test $testno </center></b></h3><br><br>
        <form action='Finish_Quiz.pl' method='POST'>
        <h4><b><center>";
    my $sth = $dbh -> prepare("select Question, Marks from QuizQuestionsDB
                                where TestNo=\'$testno\'");
    $sth -> execute() or die;
    $i=1;
    while(my ($q, $m) = $sth -> fetchrow_array())
    {
        ($question, $marks) = ($q, $m);
        print "
            Q$i. $question ($marks marks)<br><br>
            <input type='hidden' name='question$i' value='$question'>
            <input type='hidden' name='marks$i' value='$marks'>
            <textarea name='ans$i' rows='6' cols='60'
                    placeholder='Type your answer here'></textarea>
            <br><br><br>";
        $i++;
    }
    $sth -> finish();

    my $noq=$i-1;
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
