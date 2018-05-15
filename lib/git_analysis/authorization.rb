require 'http'

module GitAnalysis
  # uses the given token to make HTTP get requests to https://api.github.com/repos
  class Authorization
    attr_reader :token
    attr_reader :repo
    attr_reader :owner

    def initialize(owner, repo)
      @token = ENV['TOKEN']
      @repo = repo
      @owner = owner
    end

    # returns http response of repository
    def request_repo
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo
      HTTP.auth('token ' + @token).get(message)
    end

    # create an instance of GitAnalysis::Repository
    def create_repo
      info = JSON.parse(request_repo)
      GitAnalysis::Repository.new(info['id'], info['name'], info['owner']['login'], info['language'])
    end

    # returns http response of prs
    def request_pr_list(state, per_page, page)
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo +
                '/pulls?state=' + state + '&page=' + page.to_s + '&per_page=' + per_page.to_s
      HTTP.auth('token ' + @token).get(message)
    end

    # returns http response of specific pr
    def request_pr(number)
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo +
                '/pulls/' + number.to_s
      HTTP.auth('token ' + @token).get(message)
    end

    # return an array of pr numbers given state
    def pr_number_list(state)
      page = 1
      pr_numbers = []
      loop do
        prs = JSON.parse(request_pr_list(state, 100, page))
        break if prs.empty?
        prs.each { |x| pr_numbers.push(x['number']) }
        page += 1
      end
      pr_numbers 
    end

    # get the files for a specific PR
    def request_pr_files(number)
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo +
                '/pulls/' + number.to_s + '/files'
      HTTP.auth('token ' + @token).get(message)
    end

    # returns a new instance of GitAnalysis::PullRequest
    def create_pr(number)
      response = JSON.parse(request_pr(number))
      owner = response['user']['login']
    files = JSON.parse(request_pr_files(number))

      file_count = files.size
      additions = 0
      deletions = 0
      changes = 0

      files.each do |file|
        additions += file['additions'].to_i
        deletions += file['deletions'].to_i
        changes += file['changes'].to_i
      end

      GitAnalysis::PullRequest.new(number, file_count, additions, deletions, changes)
    end
  end
end
