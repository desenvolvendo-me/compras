# makes bash exit immediately if any command fails
set -e

# makes bash print all of the commands before being executed
set -x

# bundle gems
(bundle check || bundle install) > /dev/null

# migrate database
bundle exec rake db:migrate db:test:load > /dev/null

# execute specs
bundle exec rspec spec/business
#bundle exec rspec spec/reports
bundle exec rspec spec/lib
bundle exec rspec spec/models
bundle exec rspec spec/controllers
bundle exec rspec spec/requests
