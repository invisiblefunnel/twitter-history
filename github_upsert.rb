require 'digest/sha1'
require 'logger'
require 'memoizable'

class GitHubUpsert < Struct.new(:client, :repo_name, :filename, :content)
  include Memoizable

  def self.execute(*args, &block)
    new(*args, &block).execute
  end

  def initialize(client, repo_name, filename)
    super(client, repo_name, filename, yield)
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

  memoize def exists?
    !!file
  end

  memoize def changed?
    file[:sha] != sha
  end

  memoize def file
    contents = client.repo(repo_name).rels[:contents].get.data
    contents.find { |file| file[:path] == filename }
  rescue Octokit::NotFound # repo is empty
    nil
  end

  memoize def sha
    # Hacks ahead! For some reason the sha GitHub has for the existing file
    # is different as a result of the Base64 encode/decode process. This is
    # a temporary workaround to get the correct answer to #changed?.
    tmp = Base64.decode64(Base64.encode64(content))
    # see http://git-scm.com/book/en/Git-Internals-Git-Objects#Object-Storage
    Digest::SHA1.hexdigest("blob #{tmp.size}\0" + tmp)
  end

  memoize def message
    'Update ' + filename
  end

  memoize def logger
    Logger.new(STDOUT)
  end
end
