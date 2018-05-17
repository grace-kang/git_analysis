require 'octokit'

module GitAnalysis
  # uses github's api, Octokit
  # has same functionality as GitAnalysis::ObjectHandler
  class NewHandler
    attr_reader :owner
    attr_reader :repo
    attr_reader :client
    attr_reader :octo_repo

    def initialize(owner, repo)
      @repo = repo
      @owner = owner
      @client = Octokit::Client.new(:access_token => ENV['CHANGELOG_GITHUB_TOKEN'])
      @octo_repo = @client.repository("#{owner}/#{repo}")
    end

    def create_repo
      language = @octo_repo.language
      GitAnalysis::Repository.new(@octo_repo.id, @octo_repo.name, @octo_repo.owner.login, language)
    end

    def pr_number_list(state)
      page = 1
      pr_numbers = []
      loop do
        prs = @client.pull_requests(@octo_repo.id, :state => state, :per_page => 100, :page => page)
        break if prs.empty?
        prs.each { |x| pr_numbers.push(x['number']) }
        page += 1
      end
      pr_numbers
    end

    def create_pr(number)
      pr = @client.pull_request(@octo_repo.id, number)
      owner = pr.user.login
      files = @client.pull_request_files(@octo_repo.id, number)

      file_count = files.count
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

