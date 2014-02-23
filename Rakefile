task :default do
  require 'dotenv';Dotenv.load
  require './github_upsert'
  require 'octokit'
  require 'twitter'

  Logger.new(STDOUT).info('Checking for diffs')

  TwitterClient = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
    config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
    config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
    config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
  end

  GitHubClient = Octokit::Client.new(access_token: ENV.fetch('GITHUB_ACCESS_TOKEN'))

  repo = ENV.fetch('HISTORY_REPO')
  followers = TwitterClient.followers(count: 1000).to_a.map(&:screen_name)
  following = TwitterClient.following(count: 1000).to_a.map(&:screen_name)

  GitHubUpsert.execute GitHubClient, repo, 'followers', followers.join("\n")
  GitHubUpsert.execute GitHubClient, repo, 'following', following.join("\n")
end
