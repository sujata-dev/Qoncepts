#!/usr/bin/env perl

# To check a quiz sheet of a student

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

my ($name, $branch, $year, $question, $answer, $totalmarks, $i);
already_alloted();

print $cgi -> header('text/html');

studentdb_data();
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
                font-size: 30px;
            }
            input
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
        <div class='container'>
        <br><br>
        <h3><center><b>

        TestNo: $testno <br><br><br>
        Submitted by:<br><br>
        PRN: $prn <br>
        Name: $name <br>
        Branch: $branch <br>
        Year: $year <br><br><br>
        </center></b></h3>";
    my $sth = $dbh -> prepare("select Question, Answer, TotalMarks
    from QuizAnswersDB where PRN=? and TestNo=?;");
    $sth -> execute($prn, $testno) or die;
    $i=0;
    while(($question, $answer, $totalmarks) = $sth -> fetchrow_array())
    {
        $i++;
        print "
            <h4><b><center>
            Q$i. $question ($totalmarks marks)<br><br>
            Ans. $answer <br><br>
            <form action='Allot_Marks.pl' method='GET'>
                <input id='marks$i' type='text' class='form-control'
                name='marks$i' placeholder='Allot Marks' style='width:100px;'><br><br>
                <input type='hidden' name='question$i' value='$question'>";
    }
    print "
            <input type='hidden' name='testno' value='$testno'>
            <input type='hidden' name='prn' value='$prn'>
            <input type='hidden' name='noq' value='$i'>
        <button type='submit' class='btn'><b>
            I am done checking
        </b></button>
        </form>
        </center></b></h4>
        </div>
        </div>
        </div>";

    $sth -> finish();
    print "
        </div>
        </body>
        </html>";
}


sub studentdb_data
{
    my $sth = $dbh -> prepare("select Name, Branch, Year from Student
                                where PRN = ?");
    $sth -> execute($prn) or die;

    while (my ($a, $b, $c) = $sth -> fetchrow_array())
    {
        ($name, $branch, $year)=($a, $b, $c);
    }
    $sth -> finish();
}

sub already_alloted
{
    my $flag=0;
    my $sth = $dbh -> prepare("select distinct AllotedMarks from QuizAnswersDB where PRN=? and TestNo=?");
    $sth -> execute($prn,$testno) or die;

    while (my $row = $sth -> fetchrow_array())
    {
        $flag=1;
    }
    if($flag==1)
    {
            print "
            <script>
                window.location = 'Already_Alloted.pl';
            </script>";
    }
    $sth -> finish();
}
