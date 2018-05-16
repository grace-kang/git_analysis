require 'http'
require_relative 'http_request'

module GitAnalysis
  # creates and handles Repository and PullRequest objects
  class ObjectHandler
    attr_reader :owner
    attr_reader :repo

    def initialize(owner, repo)
      @repo = repo
      @owner = owner
    end

    # create an instance of GitAnalysis::Repository
    def create_repo
      info = JSON.parse(HTTPRequest.repo(@owner, @repo))
      GitAnalysis::Repository.new(info['id'], info['name'], info['owner']['login'], info['language'])
    end

    # return an array of pr numbers given state
    def pr_number_list(state)
      page = 1
      pr_numbers = []
      loop do
        prs = JSON.parse(HTTPRequest.repo_prs(@owner, @repo, state, 100, page))
        break if prs.empty?
        prs.each { |x| pr_numbers.push(x['number']) }
        page += 1
      end
      pr_numbers
    end

    # returns a new instance of GitAnalysis::PullRequest
    def create_pr(number)
      response = JSON.parse(HTTPRequest.pr(@owner, @repo, number))
      owner = response['user']['login']
      files = JSON.parse(HTTPRequest.pr_files(@owner, @repo, number))

      file_count = files.size
      additions = 0
      deletions = 0
      changes = 0

      files.each do |file|
        additions += file['additions'].to_i
        deletions += file['deletions'].to_i
        changes += file['changes'].to_i
      end

      GitAnalysis::PullRequest.new(number, owner, file_count, additions, deletions, changes)
    end
  end
end
