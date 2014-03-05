require 'dotenv/tasks'

task default: :dotenv do
  require './core_ext'
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

  GitHubUpsert.execute(GitHubClient, REPO, 'followers') do
    screen_names = TwitterClient.followers(count: 1000).to_a.map(&:screen_name)
    screen_names.destutter.join(GitHubUpsert::NEWLINE) # remove sequential duplicates and join with newlines
  end

  GitHubUpsert.execute(GitHubClient, REPO, 'following') do
    screen_names = TwitterClient.following(count: 1000).to_a.map(&:screen_name)
    screen_names.destutter.join(GitHubUpsert::NEWLINE) # remove sequential duplicates and join with newlines
  end
end
