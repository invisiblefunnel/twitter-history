require 'digest/sha1'
require 'logger'
require 'memoizable'

class GitHubUpsert < Struct.new(:client, :repo_name, :filename, :content)
  include Memoizable
  NEWLINE = "\n".freeze

  def self.execute(*args, &block)
    new(*args, &block).execute
  end

  def initialize(client, repo_name, filename)
    # ensure content ends with a newline
    content = yield
    content << NEWLINE unless content.end_with?(NEWLINE)

    super(client, repo_name, filename, content)
  end

  def execute
    if exists?
      update! if changed?
    else
      add!
    end
  end

  private

  def update!
    logger.info(message)
    client.update_content(repo_name, filename, message, file[:sha], content)
  end

  def add!
    logger.info('Add ' + filename)
    client.add_content(repo_name, filename, message, content)
  end

  def exists?
    !!file
  end
  memoize :exists?

  def changed?
    file[:sha] != sha
  end
  memoize :changed?

  def file
    contents = client.repo(repo_name).rels[:contents].get.data
    contents.find { |file| file[:path] == filename }
  rescue Octokit::NotFound # repo is empty
    nil
  end
  memoize :file

  def sha
    # see http://git-scm.com/book/en/Git-Internals-Git-Objects#Object-Storage
    Digest::SHA1.hexdigest("blob #{content.size}\0" + content)
  end
  memoize :sha

  def message
    'Update ' + filename
  end
  memoize :message

  def logger
    Logger.new(STDOUT)
  end
  memoize :logger
end
