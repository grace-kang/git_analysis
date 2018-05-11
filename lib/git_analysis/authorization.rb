require 'http'

module GitAnalysis
  # uses the given token to make HTTP get requests to https://api.github.com/repos
  class Authorization
    attr_reader :token
    attr_reader :repo
    attr_reader :owner

    def initialize(token, repo, owner)
      @token = token
      @repo = repo
      @owner = owner
    end

    # get the repo
    def repo_info
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo
      HTTP.auth('token ' + @token).get(message)
    end

    # get status code of the repo GET request
    def repo_info_code
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo
      HTTP.auth('token ' + @token).get(message).code
    end

    # get pull requests 1 per page
    def pull_request_count(state, page)
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo +
                '/pulls?state=' + state + '&page=' + page.to_s + '&per_page=1'
      HTTP.auth('token ' + @token).get(message)
    end

    # get pull requests 100 per page
    def pull_requests(state, page)
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo +
                '/pulls?state=' + state + '&page=' + page.to_s + '&per_page=100'
      HTTP.auth('token ' + @token).get(message)
    end

    # get a single PR
    def single_pull_request(number)
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo +
                '/pulls/' + number.to_s
      HTTP.auth('token ' + @token).get(message)
    end

    # get status code of a single PR request
    def single_pull_request_code(number)
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo +
                  '/pulls/' + number.to_s
      HTTP.auth('token ' + @token).get(message).code
    end

    # get the files for a specific PR
    def pull_request_files(number)
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo +
                '/pulls/' + number.to_s + '/files'
      HTTP.auth('token ' + @token).get(message)
    end

    # get contributors for the repo
    def contributors(page)
      message = 'https://api.github.com/repos/' + @owner + '/' + @repo +
                '/contributors?page=' + page.to_s + '&per_page=100'
      HTTP.auth('token ' + @token).get(message)
    end
  end
end
