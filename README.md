# README

# Software Pre-reqs
* Ruby 2.2.5 x64
  * Ddownload from http://rubyinstaller.org/downloads/ 
  * NOTE: I have not yet tested with the latest 2.2.6
  * Install Ruby 2.2.5
* DevKit-mingw64 4.7.2
  * Download from https://bintray.com/oneclick/rubyinstaller/DevKit/mingw64-4.7.2
  * Install DevKit-mingw64
  * Add path to your Ruby installation in config.yml. Remember to start with a hyphen

# Setup Instructions
```
ruby --version
gem source -a http://rubygems.org/
gem source -r https://rubygems.org/
gem update --system

ruby dk.rb init
ruby dk.rb install

gem install rails
rails -v
bundle install
```
# Schema initialization
* Create a new project
* Define new models and generate scaffold model, controller and standard views
```
rails new program

rails generate scaffold Member name:string title:string stream:string manager:string is_lead:boolean
rails generate scaffold Team name:string member_id:integer purpose:string
rails generate scaffold Teammember team_id:integer member_id:integer
rails generate scaffold NamedList list_name:string entry_name:string (team purpose, member stream, subscription status, url url_type, course course_type, course difficulty)
rails generate scaffold Category name:string
rails generate scaffold Classification name:string
rails generate scaffold Topic name:string category_id:integer classification_id:integer team_id:integer details:text
rails generate scaffold Interest topic_id:integer member_id:integer
rails generate scaffold Course title:string details:text topic_id:integer course_type:string time_estimate:string difficulty:string cost_course:string cost_certification:string member_id:integer credits:integer university:string url:string
rails generate scaffold Url entity:string url:string url_type:string
rails generate scaffold Subscription course_id:integer member_id:integer status:string rating:integer comment:text

rails generate scaffold CourseLink parent_id:integer child_id:integer link_type:string
```
# Configuration
  TODO: Instructions pending
```
\config\database.yml
\Gemfile -> therubyracer
\config\application.rb ->     config.log_level = :debug # In any environment initializer, or
\config\initializers\assets.rb
\public\stylesheets\style.css
\app\views\layouts\application.html.erb
\app\assets\javascripts\application.js
```
# Deployment instructions
Define the port number, whether externa access is allowed, and which mode to start in
```
rails server -p 80 -b 0.0.0.0 -e production
```

# Additional Database Configuration
* How to add a new field to an existing model
 ```
rails g migration AddActiveToCourses active:boolean
rake db:migrate RAILS_ENV=development
```
