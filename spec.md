# Specifications for the Sinatra Assessment

Specs:
- [x] Use Sinatra to build the app
      *-App uses Sinatra*
- [X] Use ActiveRecord for storing information in a database
      *-App uses ActiveRecord to interact with db*
- [X] Include more than one model class (list of model class names e.g. User, Post, Category)
      *-7 models (user, course, program, platform, subject and 2 join tables)*
- [X] Include at least one has_many relationship (x has_many y e.g. User has_many Posts)
      *-Several has_many (users to courses, programs to courses, platforms to programs, etc.)*
- [X] Include user accounts
      *-Has secure user accounts*
- [X] Ensure that users can't modify content created by other users
      *-App redirects to index and provides flash message when this occurs*
- [X] Include user input validations
      *-Validations on required fields, and checks to make sure names are unique*
- [X] Display validation failures to user with error message (example form URL e.g. /posts/new)
      *-Flashes provide error messages, and controllers properly redirect*
- [X] Your README.md includes a short description, install instructions, a contributors guide and a link to the license for your code
      *-README.md includes everything required*

Confirm
- [X] You have a large number of small Git commits
- [X] Your commit messages are meaningful
- [X] You made the changes in a commit that relate to the commit message
- [X] You don't include changes in a commit that aren't related to the commit message
