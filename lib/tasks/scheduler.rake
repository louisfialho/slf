desc "This task is called by the Heroku scheduler add-on"
task :reset_sandbox_shelf => :environment do
  puts "Resetting sandbox..."
  Shelf.reset_sandbox
  puts "done."
end
