require 'dotenv/tasks'

task default: :dotenv do
  require './csv_transform'
  require './github_upsert'
  require 'logger'
  require 'octokit'
  require 'twitter'

  repo = ENV.fetch('HISTORY_REPO')
  github = Octokit::Client.new(access_token: ENV.fetch('GITHUB_ACCESS_TOKEN'))
  twitter = Twitter::REST::Client.new do |config|
    config.consumer_key        = ENV.fetch('TWITTER_CONSUMER_KEY')
    config.consumer_secret     = ENV.fetch('TWITTER_CONSUMER_SECRET')
    config.access_token        = ENV.fetch('TWITTER_ACCESS_TOKEN')
    config.access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
  end

  to_csv = CSVTransform.new(:id, :screen_name, :name, :statuses_count,
                            :friends_count, :followers_count, :listed_count)

  Logger.new(STDOUT).info('Checking for diffs')

  GitHubUpsert.execute(github, repo, 'followers.csv') do
    to_csv.(twitter.followers(count: 1000).to_a.uniq(&:id))
  end

  GitHubUpsert.execute(github, repo, 'following.csv') do
    to_csv.(twitter.following(count: 1000).to_a.uniq(&:id))
  end
end
