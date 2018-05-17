require 'octokit'

module GitAnalysis
  # uses github's api, Octokit
  # has same functionality as 
  class NewHandler
    attr_reader :owner
    attr_reader :repo
    attr_reader :client
    attr_reader :octo_repo

    def initialize(owner, repo)
      @repo = repo
      @owner = owner
      @client = Octokit::Client.new(:access_token => ENV['CHANGELOG_GITHUB_TOKEN'])

      url = "https://github.com/#{owner}/#{repo}"
      @octo_repo = Octokit::Repository.from_url(url)
    end

    def create_repo
      lang_hash = @client.languages(@octo_repo)
      language, val = lang_hash.first
      GitAnalysis::Repository.new(@octo_repo.id, @octo_repo.name, @octo_repo.owner, language)
    end

    def pr_number_list(state)
      pr_list = @client.pull_requests(@octo_repo, :state => state)
    end

    def create_pr(number)
      pr = @client.pull_request(@octo_repo, number)
      puts pr.number
      puts pr.user.login
      puts pr.files
    end
  end
end

