require "bridgetown"

Bridgetown.load_tasks

# Run rake without specifying any command to execute a deploy build by default.
task default: :deploy

#
# Standard set of tasks, which you can customize if you wish:
#
desc "Build the Bridgetown site for deployment"
task :deploy => [:clean, "frontend:build"] do
  Bridgetown::Commands::Build.start
end

desc "Build the site in a test environment"
task :test do
  ENV["BRIDGETOWN_ENV"] = "test"
  Bridgetown::Commands::Build.start
end

require "minitest/test_task"
Minitest::TestTask.create(:test) do |t| # add on to the test task
  t.warning = false
end

desc "Runs the clean command"
task :clean do
  Bridgetown::Commands::Clean.start
end

namespace :frontend do
  desc "Build the frontend with esbuild for deployment"
  task :build do
    sh "npm run esbuild"
  end

  desc "Watch the frontend with esbuild during development"
  task :dev do
    sh "npm run esbuild-dev"
  rescue Interrupt
  end
end

#
# Add your own Rake tasks here! You can use `environment` as a prerequisite
# in order to write automations or other commands requiring a loaded site.
#
# task :my_task => :environment do
#   puts site.root_dir
#   automation do
#     say_status :rake, "I'm a Rake tast =) #{site.config.url}"
#   end
# end

namespace :cy do
  desc "Open Cypress test runner"
  task :open do
    system "npm run cypress open"
  end

  desc "Run Cypress tests headless"
  task :run do
    system "npm run cypress run"
  end

  desc "Start server and open Cypress test runner"
  task :test do
    ENV["BRIDGETOWN_ENV"] = "test"
    server_pid = fork { Bridgetown::Commands::Start.start }
    Rake::Task["cy:open"].execute
    Process.kill "SIGTERM", server_pid
    sleep 1 # give processes time to clean up
    puts
  end

  namespace :test do
    desc "Start server and run Cypress tests headless"
    task :ci do
      ENV["BRIDGETOWN_ENV"] = "test"
      server_pid = fork { Bridgetown::Commands::Start.start }
      Rake::Task["cy:run"].execute
      Process.kill "SIGTERM", server_pid
      sleep 1 # give processes time to clean up
      puts
    end
  end
end
