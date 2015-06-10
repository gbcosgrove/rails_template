###
#Gems to install
###
gem 'therubyracer', platforms: :ruby, group: [:development, :test]
gem 'node', group: :production
gem 'bootstrap-sass', '~> 3.3.1'
gem 'autoprefixer-rails'
gem 'haml-rails'
gem "unicorn"
gem 'jquery-turbolinks'
gem "ransack"
gem 'whenever'
gem 'delayed_job_active_record'
gem 'daemons' #needed by delayed_job
gem 'simple_auth_engine', git: 'https://github.com/vmcilwain/simple_auth_engine.git', tag: '0.0.2'
gem 'paperclip'
gem 'aws-sdk', '< 2.0'
gem 'httparty'
gem 'remotipart', '~> 1.2'
gem 'will_paginate', '~> 3.0.6'
gem "font-awesome-rails"
gem 'letter_opener', group: [:development]

gem_group :development do
  gem 'capistrano-rails'
  gem 'capistrano-rvm'
end

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
  gem 'binding_of_caller'
end

run 'bundle install'

###
#Generate rpsec files
###
generate 'rspec:install'

###
#Create necessary directories
###
run "rm README.rdoc"
# run "rm -rf test"
run 'mkdir spec/fabricators'
run 'mkdir spec/features'
run 'mkdir spec/models'
run 'mkdir spec/controllers'

###
#Add loading of application.yml file
###
inject_into_file 'config/application.rb', after: "Bundler.require(*Rails.groups)" do
"\n
CONFIG = YAML.load(File.read(File.expand_path('../application.yml', __FILE__)))
CONFIG.merge! CONFIG.fetch(Rails.env, {})
CONFIG.symbolize_keys!
"
end

###
#Create application.yml file
###
file 'config/application.yml', <<-CODE
# Add configuration values here, as shown below.
#
# pusher_app_id: "2954"
# pusher_key: 7381a978f7dd7f9a1117
# pusher_secret: abdc3b896a0ffb85d373
# stripe_api_key: sk_test_2J0l093xOyW72XUYJHE4Dv2r
# stripe_publishable_key: pk_test_ro9jV5SNwGb1yYlQfzG17LHK
#
# production:
#   stripe_api_key: sk_live_EeHnL644i6zo4Iyq4v1KdV9H
#   stripe_publishable_key: pk_live_9lcthxpSIHbGwmdO941O1XVU
version: 0.0.1

sendgrid_username: ''
sendgrid_password: ''

development:
  db_user: ''
  db_pass: ''
  action_mailer_host: 'http://localhost:3000'
  action_controller_host: 'http://localhost:3000'

test:
  db_user: ''
  db_pass: ''
  action_mailer_host: 'http://localhost:3000'
  action_controller_host: 'http://localhost:3000'


production:
  db_user: ''
  db_pass: ''
  secret_key_base: ''
  secret_token: ''
  action_mailer_host: 'http://localhost'
  action_controller_host: 'http://localhost'
CODE

###
#Setup config/environments/development.rb
###
inject_into_file 'config/environments/development.rb', after: "config.action_mailer.raise_delivery_errors = false" do
  "
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.perform_deliveries = false
  config.action_mailer.default_url_options = {host: CONFIG[:mailer_host]}
  config.action_controller.default_url_options = { host: CONFIG[:controller_host] }
  "
end

###
#Setup config/environments/test.rb
###
inject_into_file 'config/environments/test.rb', after: "config.action_mailer.delivery_method = :test" do
  "
  config.action_mailer.default_url_options = {host: CONFIG[:mailer_host]}
  config.action_controller.default_url_options = { host: CONFIG[:controller_host] }
  "
end

###
#Setup config/environments/production.rb
###
inject_into_file 'config/environments/production.rb', after: "config.active_record.dump_schema_after_migration = false" do
  "
  config.action_mailer.default_url_options = {host: CONFIG[:mailer_host]}
  config.action_controller.default_url_options = { host: CONFIG[:controller_host] }
  config.assets.compile = true
  "
end

###
#Install capistrano
####
run 'bundle exec cap install'
run 'mkdir config/deploy/templates'

###
#Enable cap requires
###
inject_into_file 'Capfile', before: '# Load custom tasks from `lib/capistrano/tasks` if you have any defined' do
"
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
"
end

###
#Add additional deploy code
###
inject_into_file 'config/deploy.rb', after: "namespace :deploy do" do
"
before :finishing, :restart do
    on roles(:app) do
      invoke 'unicorn:restart'
      invoke 'nginx:restart'
      #invoke 'delayed_jobs:restart #Uncomment if you are using delayed jobs
    end
  end
  
  task :upload_app_yml do
    on roles(:app) do
      info 'Uploading application.yml'
      upload!(\"\#{Dir.pwd}/config/application.yml\", \"\#{release_path}/config\")
    end
  end
  
  before :compile_assets, :upload_app_yml
  before :published, 'nginx:create_nginx_config'
  before :published, 'unicorn:create_unicorn_config'
  before :published,'unicorn:create_unicorn_init'
  #after :restart, 'monit:create_monit_conf' #requires monit be installed on the server
"
end

inject_into_file 'config/deploy.rb', before: "namespace :deploy do" do
 "
set :deploy_to, \"/var/www/\#{fetch(:application)}\"
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :rails_env, fetch(:stage)
set :bundle_binstubs, -> { release_path.join('bin') }
"
end

###
#Create nginx template for capistrano
###
file 'config/deploy/templates/nginx.conf.erb', <<-CODE
upstream <%= fetch(:application) %> {
    # Path to Unicorn SOCK file, as defined previously
    server unix:<%= current_path %>/tmp/sockets/unicorn.<%= fetch(:application) %>.sock fail_timeout=0;
}

server {
    listen 80 default_server;
    #listen 443 ssl;

    server_name localhost;
    #ssl_certificate /etc/nginx/ssl/nginx.crt;
    #ssl_certificate_key /etc/nginx/ssl/nginx.key;

    # Application root, as defined previously
    root /var/www/<%= fetch(:application) %>/public;

    try_files $uri/index.html $uri @<%= fetch(:application) %>;

    location @<%= fetch(:application) %> {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_redirect off;
        proxy_pass http://<%= fetch(:application) %>;

    }

    error_page 500 502 503 504 /500.html;
    client_max_body_size 4G;
    keepalive_timeout 10;
}
CODE

###
#Create unicorn init template for capistrano
###
file 'config/deploy/templates/unicorn_init.sh.erb', <<-CODE
#!/bin/sh
set -e
# Example init script, this can be used with nginx, too,
# since nginx and unicorn accept the same signals

# Feel free to change any of the following variables for your app:
TIMEOUT=${TIMEOUT-60}
APP_ROOT=/var/www/<%= fetch(:application) %>/current
PID=$APP_ROOT/tmp/pids/unicorn.pid
CMD="$APP_ROOT/bin/unicorn -D -c $APP_ROOT/config/unicorn.rb -E <%= fetch(:stage) %>"
action="$1"
set -u

old_pid="$PID.oldbin"

cd $APP_ROOT || exit 1

sig () {
        test -s "$PID" && kill -$1 `cat $PID`
}

oldsig () {
        test -s $old_pid && kill -$1 `cat $old_pid`
}

case $action in
start)
        sig 0 && echo >&2 "Already running" && exit 0
        su -c "$CMD" - deploy
        ;;
stop)
        sig QUIT && exit 0
        echo >&2 "Not running"
        ;;
force-stop)
        sig TERM && exit 0
        echo >&2 "Not running"
        ;;
restart|reload)
        sig HUP && echo reloaded OK && exit 0
        echo >&2 "Couldn't reload, starting '$CMD' instead"
        su -c "$CMD" - deploy
        ;;
upgrade)
        if sig USR2 && sleep 2 && sig 0 && oldsig QUIT
        then
                n=$TIMEOUT
                while test -s $old_pid && test $n -ge 0
                do
                        printf '.' && sleep 1 && n=$(( $n - 1 ))
                done
                echo

                if test $n -lt 0 && test -s $old_pid
                then
                        echo >&2 "$old_pid still exists after $TIMEOUT seconds"
                        exit 1
                fi
                exit 0
        fi
        echo >&2 "Couldn't upgrade, starting '$CMD' instead"
        su -c "$CMD" - deploy
        ;;
reopen-logs)
        sig USR1
        ;;
*)
        echo >&2 "Usage: $0 "
        exit 1
        ;;
esac
CODE

###
#Create unicorn config template for capistrano
###
file 'config/deploy/templates/unicorn.rb.erb', <<-CODE
# config/unicorn.rb
#
# Set the working application directory
# working_directory '/path/to/your/app'
working_directory "/var/www/<%= fetch(:application) %>/current"

# Unicorn PID file location
# pid '/path/to/pids/unicorn.pid'
pid "/var/www/<%= fetch(:application) %>/current/tmp/pids/unicorn.pid"

# Path to logs
# stderr_path '/path/to/log/unicorn.log'
# stdout_path '/path/to/log/unicorn.log'
stderr_path "/var/www/<%= fetch(:application) %>/current/log/unicorn.log"
stdout_path "/var/www/<%= fetch(:application) %>/current/log/unicorn.log"

# Unicorn socket
# listen '/tmp/unicorn.[application name].sock'
listen "<%= current_path %>/tmp/sockets/unicorn.<%= fetch(:application) %>.sock"

# Number of processes
# worker_processes 4
worker_processes 2

# Time-out
timeout 30
CODE

###
#Create nginx capistrano task
###

file 'lib/capistrano/tasks/nginx.rake', <<-CODE
# Capistrano file for setting up nginx during application deployment
set :home_path, File.expand_path("../../../../config/deploy", __FILE__)
set :nginx_conf_file, "\#{fetch(:home_path)}/nginx.conf"

namespace :nginx do
  desc 'restart nginx'
  task :restart do
    on roles(:app) do
      info 'Restarting nginx'
      execute :sudo, "service nginx restart"
    end
  end

  desc "create \#{fetch(:application)} nginx.conf"
  task :generate_nginx_conf do
    on roles(:app) do
      info "Generating \#{fetch(:application)} nginx.conf file"
      open(fetch(:nginx_conf_file), 'w') do |f|
        f.puts(ERB.new(File.read(fetch(:home_path) + "/templates/nginx.conf.erb")).result(binding))
      end
    end
  end

  desc "upload \#{fetch(:application)} nginx.conf"
  task :upload do
    on roles(:app) do
      upload!(fetch(:nginx_conf_file), "\#{current_path}/config")
    end
  end

  desc "delete local \#{fetch(:application)} nginx.conf"
  task :remove do
    on roles(:app) do
      info 'Removing local nginx.conf'
      FileUtils.rm(fetch(:nginx_conf_file))
    end
  end

  desc "create symlink for \#{fetch(:application)} nginx.conf"
  task :create_symlink do
    on roles(:app) do
      info 'Creating symlink on remote system'
      execute :sudo, "ln -s \#{current_path}/config/nginx.conf /etc/nginx/sites-enabled/\#{fetch(:application)}"
    end
  end
  
  desc "remove symlink for \#{fetch(:application)} nginx.conf"
  task :remove_symlink do
    on roles(:app) do
      info 'Removing symlink on remote system'
      execute :sudo, "rm -rf /etc/nginx/sites-enabled/\#{fetch(:application)}"
    end
  end

  desc "add nginx config to \#{fetch(:application)}"
  task :create_nginx_config do
    on roles(:app) do |host|
      info "Creating \#{fetch(:application)} nginx.conf"
      invoke 'nginx:generate_nginx_conf'
      invoke 'nginx:upload'
      invoke 'nginx:remove_symlink'
      invoke 'nginx:create_symlink'
      invoke 'nginx:remove'
    end
  end

end
CODE

###
#Create unicorn capistrano task
###
file 'lib/capistrano/tasks/unicorn.rake', <<-CODE
# Capistrano file for setting up unicorn during application deployment
set :home_path, File.expand_path("../../../../config/deploy", __FILE__)
set :unicorn_conf_file, "\#{fetch(:home_path)}/unicorn.rb"
set :unicorn_init_file, "\#{fetch(:home_path)}/unicorn_init.sh"
set :unicorn_binary, "\#{fetch(:home_path)}/../../bin/unicorn"
namespace :unicorn do

  desc "generate unicorn.conf for \#{fetch(:application)}"
  task :generate_unicorn_conf do
     on roles(:app) do
      info "generating \#{fetch(:application)} unicorn.conf file"
      open(fetch(:unicorn_conf_file), 'w') do |f|
        f.puts(ERB.new(File.read(fetch(:home_path) + "/templates/unicorn.rb.erb")).result(binding))
      end
    end
  end

  desc "generate unicorn_init.sh for \#{fetch(:application)}"
  task :generate_unicorn_init do
     on roles(:app) do
     info "generating \#{fetch(:application)} unicorn_init.sh file"
      open(fetch(:unicorn_init_file), 'w') do |f|
        f.puts(ERB.new(File.read(fetch(:home_path) + "/templates/unicorn_init.sh.erb")).result(binding))
      end
    end
  end

  desc "upload \#{fetch(:application)} unicorn.conf"
  task :upload_unicorn_conf do
    on roles(:app) do
      upload!(fetch(:unicorn_conf_file), "\#{current_path}/config")
    end
  end

  desc "upload \#{fetch(:application)} unicorn_init.sh"
  task :upload_unicorn_init do
    on roles(:app) do
      upload!(fetch(:unicorn_init_file), "\#{current_path}/config")
    end
  end
  
  desc "upload \#{fetch(:application)} bin/unicorn"
  task :upload_unicorn_binary do
    on roles(:app) do
      # bundle binstub unicorn must already be run
      upload!(fetch(:unicorn_binary), "\#{current_path}/bin")
    end
  end

  desc "delete local \#{fetch(:application)} unicorn.conf"
  task :remove_unicorn_conf do
    on roles(:app) do
      info 'Deleting local unicorn.conf'
      FileUtils.rm(fetch(:unicorn_conf_file))
    end
  end

  desc "delete local \#{fetch(:application)} unicorn.init.sh"
  task :remove_unicorn_init do
    on roles(:app) do
      info 'Deleting local unicorn_init.sh'
      FileUtils.rm(fetch(:unicorn_init_file))
    end
  end

  desc "create symlink for \#{fetch(:application)} unicorn_init.sh"
  task :create_symlink do
    on roles(:app) do
      info 'Symlinking unicorn_init.sh'
      execute :sudo, "chmod +x \#{current_path}/config/unicorn_init.sh"
      execute :sudo, "ln -s \#{current_path}/config/unicorn_init.sh /etc/init.d/unicorn-\#{fetch(:application)}"
    end
  end

  desc "remove symlink for \#{fetch(:application)} unicorn_init.sh"
  task :remove_symlink do
    on roles(:app) do
      info 'Removing unicorn_init.sh symlink'
      execute :sudo, "rm -rf /etc/init.d/unicorn-\#{fetch(:application)}"
    end
  end

  desc "add unicorn config to \#{fetch(:application)}"
  task :create_unicorn_config do
    on roles(:app) do |host|
      invoke 'unicorn:generate_unicorn_conf'
      invoke 'unicorn:upload_unicorn_conf'
      invoke 'unicorn:remove_unicorn_conf'
      # invoke 'unicorn:upload_unicorn_binary'
    end
  end
  
  desc "restart unicorn for \#{fetch(:application)}"
  task :restart do
    on roles(:app) do
      info 'Restarting unicorn'
      execute :sudo, "/etc/init.d/unicorn-\#{fetch(:application)} restart"
    end
  end
  
  # desc "Stop unicorn for \#{fetch(:application)}"
  # task :stop do
  #   on roles(:app) do
  #     info 'Stopping unicorn'
  #     execute :sudo, "kill \#{capture(current_path.join('tmp/pids/unicorn.pid'))}"
  #   end
  # end
  
  desc "add unicorn init config to \#{fetch(:application)}"
  task :create_unicorn_init do
    on roles(:app) do |host|
      invoke 'unicorn:generate_unicorn_init'
      invoke 'unicorn:upload_unicorn_init'
      invoke 'unicorn:remove_symlink'
      invoke 'unicorn:create_symlink'
      invoke 'unicorn:remove_unicorn_init'
    end
  end
end
CODE

file 'lib/capistrano/tasks/delayed_job.rake', <<-CODE
# Capistrano file for setting up delayed job during application deployment
namespace :delayed_job do

  def args
    fetch(:delayed_job_args, "")
  end

  def delayed_job_roles
    fetch(:delayed_job_server_role, :app)
  end

  desc 'Stop the delayed_job process'
  task :stop do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'bin/delayed_job', :stop
        end
      end
    end
  end

  desc 'Start the delayed_job process'
  task :start do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'bin/delayed_job', args, :start
        end
      end
    end
  end

  desc 'Restart the delayed_job process'
  task :restart do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, :exec, :'bin/delayed_job', args, :restart
        end
      end
    end
  end
end
CODE

file 'lib/capistrano/tasks/monit.rake', <<-CODE
# Capistrano file for setting up monit during application deployment
set :home_path, File.expand_path("../../../../config/deploy", __FILE__)
set :rails_config_dir, "/var/www/\#{fetch(:application)}/current/config"
namespace :monit do

  def daemons
    capture("ls -1 \#{current_path}/tmp/pids").split
  end

  desc 'creation of monit file for application'
  task :write_monit_conf do
    on roles(:app) do
      info "Creating monit config"
      open(fetch(:monit_conf_file), 'w') do |f|
        daemons.each do |daemon|
          f.puts(ERB.new(File.read(fetch(:home_path) + "/templates/monit.conf.erb"), nil, '-').result(binding))
        end
      end
    end
  end

  desc 'restart monit appliation'
  task :reload do
    on roles(:app) do
      info 'Reloading monit'
      execute 'monit reload'
    end
  end

  desc 'upload monit config to app'
  task :upload do
    on roles(:app) do
      upload!(fetch(:monit_conf_file), fetch(:rails_config_dir))
    end
  end

  desc 'remove temp file'
  task :remove do
    on roles(:app) do
      FileUtils.rm(fetch(:monit_conf_file))
    end
  end

  desc 'start creation of monit file for application'
  task :create_monit_conf do
    on roles(:app) do
      info "Daemons Found: \#{daemons.size}"
      if daemons.any?
        invoke 'monit:write_monit_conf'
        invoke 'monit:upload'
        invoke 'monit:remove'
        invoke 'monit:reload'
      end
    end
  end
end
CODE

###
#Create readme.md
###
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

###
#Create home controller
###
file 'app/controllers/home_controller.rb', <<-CODE
class HomeController < ApplicationController
end
CODE

###
#Create home index
###
file 'app/views/home/index.html.haml', <<-CODE
<h2>You are home!</h2>
CODE

###
#Create the home route
###
route "root to: 'home#index'"

###
#Create the ui controller
###
file 'app/controllers/ui_controller.rb', <<-CODE
class UiController < ApplicationController
   before_action do
    redirect_to :root if Rails.env.production?
  end
end
CODE

###
#Create ui route
###
route "get 'ui(/:action)', controller: 'ui'"

###
#Create ui index
###
file 'app/views/ui/index.html.haml', <<-CODE
%section.ui-index
  %ul
    - Dir.glob('app/views/ui/*.html.haml').sort.each do |file|
      - wireframe = File.basename(file,'.html.haml')
      -  unless wireframe == 'index' || wireframe.match(/^_/)
        %li= link_to wireframe.titleize, action: wireframe unless wireframe == 'index'
CODE

###
#Set color output for rspect
###
file '.rspec', <<-CODE
--color
CODE

###
#Add twitter initializer
###
file 'config/initializers/twitter.rb', <<-CODE
$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key        = CONFIG['CONSUMER_KEY']
  config.consumer_secret     = CONFIG['CONSUMER_SECRET']
  config.access_token        = CONFIG['ACCESS_TOKEN']
  config.access_token_secret = CONFIG['ACCESS_SECRET']
end

#Then you can call $twitter.update("whats up world!")
CODE

###
# Add sendgrid
###

inject_into_file 'config/application.rb', after: 'class Application < Rails::Application' do
  "
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = { :address   => 'smtp.sendgrid.net',
                                      :port      => 587,
                                      :domain    => "yourdomain.com",
                                      :user_name => CONFIG[:sendgrid_username],
                                      :password  => CONFIG[:sendgrid_password],
                                      :authentication => 'plain',
                                      :enable_starttls_auto => true }
end

###
#Add bootstrap
###
run "mv app/assets/stylesheets/application.css app/assets/stylesheets/application.css.sass"
inject_into_file "app/assets/stylesheets/application.css.sass", after: "*/" do
"
@import \"bootstrap-sprockets\"
@import \"bootstrap\"
"
end

inject_into_file "app/assets/javascripts/application.js", after: "//= require turbolinks" do
"
//= require bootstrap-sprockets
"
end

###
#Configure rails helper
###
inject_into_file "spec/rails_helper.rb", after: "require 'rspec/rails'" do
"
require 'simplecov'
SimpleCov.start
require 'pry'
require 'paperclip/matchers'

require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.ignore_localhost = true
end

#use Chromedriver
if ENV['CHROME']
  Capybara.register_driver :selenium do |app|
    Capybara::Selenium::Driver.new(app, :browser => :chrome)
  end
end
\n
"
end

inject_into_file "spec/rails_helper.rb", after: "config.use_transactional_fixtures = true" do
"config.use_transactional_fixtures = false"
end

inject_into_file "spec/rails_helper.rb", after: "config.infer_spec_type_from_file_location!" do
"
\n
  # => database cleaner configs
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, :js => true) do
    DatabaseCleaner.strategy = :truncation
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
"
end

###
#Create config/secrets.yml
###
file 'config/secrets.yml', <<-CODE
# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure the secrets in this file are kept private
# if you're sharing your code publicly.

development:
  secret_key_base: 48d21881b9dfd499fa3b1c275ceee5ef87b9d6277d9ab8c20c7336c4190d4708f0d0868c04d6239e6a0be4fdabdd4744a450f9c9499372e8e1c5f957b2ab7e09

test:
  secret_key_base: 068e6401de2c6c96072e78da40fed43d67f0c7ded7a32eae029fe1bb0f7ec7b147946f4beaabb8504868a81be3dbaf79cff6e630548d33be10deefc493266499

# Do not keep production secrets in the repository,
# instead read values from the environment.
production:
  secret_key_base: <%= CONFIG[:secret_key_base] %>
  secret_token: <%= CONFIG[:secret_token]%>
CODE

###
# Create app/views/layouts/application.html.haml
###
run 'rm app/views/layouts/application.html.erb'

file 'app/views/layouts/application.html.haml', <<-CODE
!!!
%head
  %title DigitalTombstone
  =stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track' => true
  =javascript_include_tag 'application', 'data-turbolinks-track' => true
  =csrf_meta_tags
%body
  .container
    =yield
CODE

###
# Update application helper
###
inject_into_file, after: 'module ApplicationHelper' do
  "
  # Long date format
  #
  # @param date [Date] the date object
  # @return day date month year - hour:minutes AM/PM
  def long_date(date)
    h date.strftime(\"%A %d %B %Y - %H:%M %p\") rescue ''
  end
  
  # Medium date format
  #
  # @param date [Date] the date object
  # @return month/date/year at hour:minutes AM/PM
  def medium_date(date)
    h date.strftime(\"%m/%d/%Y at %H:%M %p\") rescue ''
  end
  
  # Short date format
  #
  # @param date [Date] the date object
  # @return year-month-date
  def short_date(date)
    h date.strftime(\"%Y-%m-%d\") rescue ''
  end
  
  # US date format
  #
  # @param date [Date] the date object
  # @return year-month-date
  def us_date(date)
    date.strftime("%m/%d/%Y at %H:%M %p") rescue ''
  end
  "
end

###
#Create instructions file
###
file 'SETUP.txt', <<-CODE
Paperclip Setup For S3:
=======================
Development | Production Env File:
config.paperclip_defaults = {
  :storage => :s3,
  :s3_credentials => {
    :bucket => CONFIG['S3_BUCKET_NAME'],
    :access_key_id => CONFIG['S3_KEY'],
    :secret_access_key => CONFIG['S3_SECRET']
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
has_attached_file :document, path: "\#{Rails.env}/photos/:id/:basename.:extension", :styles => { :medium => "300x300>", :thumb => "100x100>" }

Add an rspec macro for deleting test files once test has run

def delete_files
  `rm -rf \#{Rails.root}/tmp/uploads`
end
---------------------------------------------------------------------------------

CODE
run 'git init'
run 'echo /coverage >> .gitignore'
run 'echo /config/application.yml >> .gitignore'
run 'git add --all'
run "git commit -m 'initial commit'"
