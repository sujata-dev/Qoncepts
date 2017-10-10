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

my $prn = $cgi -> param('prn');
my $name = $cgi -> param('name');
my $branch = $cgi -> param('CS');
my $year = $cgi -> param('First');
my $email = $cgi -> param('email');
my $pass = $cgi -> param('password');
my $cpass = $cgi -> param('cpassword');
my $pos = 'student';

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
    if(($email =~ /^[a-z0-9.]+\@[a-z0-9.-]+$/) && ($pass eq $cpass) &&
        ($pass =~ /^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d]{5,10}$/))
    {
        db_insertion();
        print "
            Congratulations $name! <br>
            Your account as '$pos' has been created successfully. <br>
            Branch: $branch <br>
            Year: $year <br>
            You can Log In now. <br>";
    }
    else
    {
        print "
            Sorry, your account has not been created. <br>
            Please register again. <br>";
    }
    print "
        </b>
        <a href='Qoncepts.htm' target='_top'>
            <button class='button'><b> Click Here </b></button>
        </a>
        </center>
        </div>
        </body>
        </html>";
}


sub db_insertion
{
    my $sth = $dbh -> prepare("insert into Student values(?, ?, ?, ?, ?, ?)");
    $sth -> execute($prn, $name, $branch, $year, $email, $pass) or die;
    $sth -> finish();
}
