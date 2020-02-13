namespace :discord_bot do
  desc "Starts discord bot"
  task start: :environment do
    DiscordBot::Bot.new.start
  end
end
