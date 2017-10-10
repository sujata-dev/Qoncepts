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

my $newtid = $cgi -> param('tid');
my $newpass = $cgi -> param('password');
my ($name, $pass);

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
                font-size: 30px;
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
        <br><br><br><br><br>
        <center><b>";

    my $flag = db_checking();

    if($flag == 1)
    {
        my $sth = $dbh -> prepare("select Name from Teacher
                                    where TID = \'$newtid\'");
        $sth -> execute() or die;

        while (my $row = $sth -> fetchrow_array())
        {
            $name = $row;
        }
        $sth -> finish();

        print "
            Welcome $name! <br><br>
            <a href='Add_Quiz.htm' target='_top'>
                <button class='button'><b> Add a Quiz </b></button>
            </a>
            <a href='Check_Quiz.htm' target='_top'>
                <button class='button'><b>
                    Check Quiz Sheets
                </b></button>
            </a>
            <a href='Stats.htm' target='_top'>
                <button class='button'><b>
                    Check Result Statistics
                </b></button>
            </a>";

    }
    else
    {
        print "
            Wrong ID or Password. <br>
            Please Login again <br><br>
            <a href='Qoncepts.htm' target='_top'>
                <button class='button'><b> Click Here </b></button>
            </a>";
    }
    print "
        </b></center>
        </div>
        </body>
        </html>";
}


sub db_checking
{
    my $sth = $dbh -> prepare("select Password from Teacher
                                where TID = \'$newtid\'");
    $sth -> execute() or die;

    while (my $row = $sth -> fetchrow_array())
    {
        $pass = $row;
    }
    $sth -> finish();

    if($pass eq $newpass)
    {
        return 1;
    }
    else
    {
        return 0;
    }
}
