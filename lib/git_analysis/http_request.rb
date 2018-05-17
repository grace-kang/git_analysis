require 'http'

module GitAnalysis
  # makes requests to https://api.github.com/repos
  class HTTPRequest

    # given status code, raise errors if neccessary
    def self.raise_errors(code)
      raise GitAnalysis::ResponseError, 'Invalid Repository' if code == 404
      raise GitAnalysis::ResponseError, 'Bad Credentials' if code == 401
      raise GitAnalysis::ResponseError, 'API rate limit exceeded' if code == 403 or code == 429
      raise GitAnalysis::ResponseError, 'Unknown Error' if code != 200
    end

    # returns http response of repository
    def self.repo(owner, repo)
      message = "https://api.github.com/repos/#{owner}/#{repo}" 
      response = HTTP.auth("token #{ENV['CHANGELOG_GITHUB_TOKEN']}").get(message)
      self.raise_errors(response.code)
      response
    end

    # returns http response of prs
    def self.repo_prs(owner, repo, state, per_page, page)
      message = "https://api.github.com/repos/#{owner}/#{repo}/pulls?state=#{state}&per_page=#{per_page}&page=#{page}"
      response = HTTP.auth("token #{ENV['CHANGELOG_GITHUB_TOKEN']}").get(message)
      self.raise_errors(response.code)
      response
    end

    # returns http response of specific pr
    def self.pr(owner, repo, number)
      message = "https://api.github.com/repos/#{owner}/#{repo}/pulls/#{number}"
      response = HTTP.auth("token #{ENV['CHANGELOG_GITHUB_TOKEN']}").get(message)
      self.raise_errors(response.code)
      response
    end

    # get the files for a specific PR
    def self.pr_files(owner, repo, number)
      message = "https://api.github.com/repos/#{owner}/#{repo}/pulls/#{number}/files"
      response = HTTP.auth("token #{ENV['CHANGELOG_GITHUB_TOKEN']}").get(message)
      self.raise_errors(response.code)
      response
    end
  end
end