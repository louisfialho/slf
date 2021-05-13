desc "This task is called by the Heroku scheduler add-on"
task :reset_sandbox_shelf => :environment do
  puts "Resetting sandbox..."
  Shelf.reset_sandbox
  puts "done."
end

# desc "This task is called by the Heroku scheduler add-on"
# task :bot_heartbeat => :environment do
#   # run heroku ps scale et prendre resultat
#   shell_dir_listing = `heroku ps bot`
#   # si la reponse crashed
#   # put le bot down
#   # run une version du bot qui puts les comments.
#   # kill ce script
#   # put le bot up up
# end

