# ISBN Checker Web

ISBN Checker Web is a web-based application that allows users to determine if ISBN numbers are valid.  It allows login with Facebook and Google or with a custom username and password.  A pay option is also available (which is not live but uses "sandbox" accounts) for Stripe and PayPal.  This was one of the projects in the Mined Minds Bootcamp.      

### Features
* Check 10 or 13 digit ISBN numbers to determine valid or invalid.
* Login is accomplished by one of three methods: Facebook login, Google login, or custom username and password login.
* Numbers are associated with your sign-in information and saved in an S3 Bucket with Amazon Web Services. 
* If a username and password are generated, password is encrypted and stored in Postgres database along with name.   
### Installation:
Open your computer terminal.
Enter in terminal...
```sh
$ https://github.com/aagooden/isbn_web
```
### To Start The App:
Enter in terminal in directory where app was cloned
```sh
$ ruby app.rb
```
Then, open your favorite web browser (Chrome, Safari, or Firefox recommended)
In the browser address bar, enter the following: 
```sh
https://localhost:4567
```

### System Requirements:
Ruby needs to be installed on your system.  Ruby 2.0 or later is recommended.  
* [Ruby](https://www.ruby-lang.org/en/documentation/installation/) - Click here for more information on installing Ruby on your system.
