require 'dotenv/tasks'

task default: :dotenv do
  require './github_upsert'
  require 'logger'
  require 'octokit'
  require 'twitter'

  TwitterClient = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
    config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
    config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
    config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
  end

  GitHubClient = Octokit::Client.new(access_token: ENV.fetch('GITHUB_ACCESS_TOKEN'))

  REPO = ENV.fetch('HISTORY_REPO')

  Logger.new(STDOUT).info('Checking for diffs')

  followers = TwitterClient.followers(count: 1000).to_a.map(&:screen_name)
  GitHubUpsert.execute GitHubClient, REPO, 'followers', followers.join("\n")

  following = TwitterClient.following(count: 1000).to_a.map(&:screen_name)
  GitHubUpsert.execute GitHubClient, REPO, 'following', following.join("\n")
end
