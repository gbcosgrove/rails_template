gem 'pg', group: :production
gem 'rails_12factor', group: :production
gem 'bootstrap-sass', '~> 3.3.1'
gem 'autoprefixer-rails'
gem 'haml-rails'
gem "puma"
gem 'jquery-turbolinks'
gem "ransack"
gem 'figaro'
gem 'whenever'
gem 'authenticatable', git: 'https://github.com/vmcilwain/authenticatable'
gem 'paperclip'
gem 'aws-sdk', '< 2.0'
gem 'httparty'
gem 'remotipart', '~> 1.2'
gem 'will_paginate', '~> 3.0.6'

gem 'letter_opener', group: [:development]

gem_group :test do
  gem 'rspec-rails'
  gem "rails-erd"
  gem 'simplecov'
  gem 'shoulda-matchers'
  gem 'fabrication'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem "chromedriver-helper"
end

gem_group :development, :test do
  gem 'faker'
  gem 'pry'
  gem 'pry-nav'
  gem 'better_errors'
  gem 'yard'
end

run 'bundle install'

generate 'rspec:install'

run "rm README.rdoc"
# run "rm -rf test"
run 'mkdir spec/fabricators'
run 'mkdir spec/features'
run 'mkdir spec/models'
run 'mkdir spec/controllers'

file 'README.md', <<-CODE
###Details
> This application doesn't have any details yet.

###Development Phases
* Design..In Progress
* Coding..Not Started
* Release..Not Started

###Processes
> TBD

###Data Model
> HTML tables will be listed here soon as it is built. Also attached pdf will be in the repository once it all has been decided.

###Technical Stuff
* Ruby Version | TBD
* Rails Version | TBD
* Dependencies | TBD
* DB Configuration | TBD
* Testing | TBD
* Services | TBD
CODE

file 'app/controllers/home_controller.rb', <<-CODE
class HomeController < ApplicationController
end
CODE

file 'app/views/home/index.html.haml', <<-CODE
<h2>You are home!</h2>
CODE

route "root to: 'home#index'"

file 'app/controllers/ui_controller.rb', <<-CODE
class UiController < ApplicationController
   before_action do
    redirect_to :root if Rails.env.production?
  end
end
CODE

route "get 'ui(/:action)', controller: 'ui'"

file 'app/views/ui/index.html.haml', <<-CODE
%section.ui-index
  %ul
    - Dir.glob('app/views/ui/*.html.haml').sort.each do |file|
      - wireframe = File.basename(file,'.html.haml')
      -  unless wireframe == 'index' || wireframe.match(/^_/)
        %li= link_to wireframe.titleize, action: wireframe unless wireframe == 'index'
CODE

file '.rspec', <<-CODE
--color
CODE

file 'spec/support/database_cleaner.rb', <<-CODE
#clear the test database out completely
config.before(:suite) do
  DatabaseCleaner.clean_with(:truncation)
end

#This part sets the default database cleaning strategy to be transactions
config.before(:each) do
  DatabaseCleaner.strategy = :transaction
end

#This line only runs before examples which have been flagged :js => true.
config.before(:each, :js => true) do
  DatabaseCleaner.strategy = :truncation
end

#These lines hook up database_cleaner around the beginning and end of each test
config.before(:each) do
  DatabaseCleaner.start
end

config.after(:each) do
  DatabaseCleaner.clean
end
CODE

file 'spec/support/chrome_web_driver.rb', <<-CODE
if ENV['CHROME']
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
end
CODE

file 'config/initializers/twitter.rb', <<-CODE
$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = ENV['CONSUMER_KEY']
  config.consumer_secret     = ENV['CONSUMER_SECRET']
  config.access_token        = ENV['ACCESS_TOKEN']
  config.access_token_secret = ENV['ACCESS_SECRET']
end

#Then you can call $twitter.update("whats up world!")
CODE

file 'SETUP.txt', <<-CODE
Paperclip Setup For S3:
=======================
Development | Production Env File:
config.paperclip_defaults = {
  :storage => :s3,
  :s3_credentials => {
    :bucket => ENV['S3_BUCKET_NAME'],
    :access_key_id => ENV['S3_KEY'],
    :secret_access_key => ENV['S3_SECRET']
  }

Test Env File
config.paperclip_defaults = {
  :storage => :Filesystem,
}
  
Migration:
def self.up
  change_table :photos do |t|
    t.attachment :document
  end
end

def self.down
  remove_attachment :photos, :document
end

Model:
has_attached_file :document, path: "#{Rails.env}/photos/:id/:basename.:extension", :styles => { :medium => "300x300>", :thumb => "100x100>" }

Add an rspec macro for deleting test files once test has run

def delete_files
  `rm -rf #{Rails.root}/tmp/uploads`
end
---------------------------------------------------------------------------------
Letter Opener
=============
Development Env
# config.action_view.raise_on_missing_translations = true
config.action_mailer.delivery_method = :letter_opener
config.action_mailer.default_url_options = { host: 'localhost:3000' }
Test Env
config.action_mailer.delivery_method = :test
config.action_mailer.default_url_options = { host: 'localhost:3000' }
---------------------------------------------------------------------------------
Bootstrap Saas - Instructions taken from http://www.gotealeaf.com/blog/integrating-rails-and-bootstrap-part-1
==============
Rename app/assets/stylesheets/application.css to app/assets/stylesheets/application.css.sass. Then import the Bootstrap assets in your newly-renamed application.css.sass file.

// app/assets/stylesheets/application.css.sass

...

@import "bootstrap-sprockets"
@import "bootstrap"

In the app/assets/javascripts/application.js add
//= require bootstrap-sprockets
It must be added after //= require jquery
--------------------------------------------------------------------------------

Rspec
======
require 'database_cleaner'
require 'pry'
require 'simplecov'
SimpleCov.start

CODE