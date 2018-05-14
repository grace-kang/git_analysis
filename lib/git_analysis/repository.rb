module GitAnalysis
  # this object analyzes a repository given the owner and the repo name
  class Repository
    def initialize(owner, repo)
      # create Authorization object using token and repository info
      @request = Authorization.new(ENV['TOKEN'], repo, owner)

      check if repository exists and token is valid
      if @request.repo_info.code == 404
        raise RepositoryError.new("Page not found")
      elsif @request.repo_info.code == 401
        raise RepositoryError.new("Bad credentials")
      end
    end

    # return id of repository
    def id
      body = @request.repo_info
      info = JSON.parse(body)
      info['id']
    end

    # return name of repository
    def name
      body = @request.repo_info
      info = JSON.parse(body)
      info['name']
    end

    # return owner of repository
    def owner
      body = @request.repo_info
      info = JSON.parse(body)
      info['owner']['login']
    end

    # return language of repository
    def language
      body = @request.repo_info
      info = JSON.parse(body)
      info['language']
    end

    # return number of open pull requests
    def open_pr_count
      body = @request.pull_request_count('open', 1)
      info = JSON.parse(body)
      if !info.empty?
        headers = body.headers.inspect
        headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0]
               .split('&page=')[1].split('&')[0]
      else
        0
      end
    end

    # return number of closed pull requests
    def closed_pr_count
      body = @request.pull_request_count('closed', 1)
      info = JSON.parse(body)
      if !info.empty?
        headers = body.headers.inspect
        headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0]
               .split('&page=')[1].split('&')[0]
      else
        0
      end
    end

    # returns an array of open pull request numbers
    def open_pr_numbers
      page = 1
      pr_numbers = []
      loop do
        prs = JSON.parse(@request.pull_requests('open', page))
        break if prs.empty?
        prs.each { |x| pr_numbers.push(x['number']) }
        page += 1
      end
      pr_numbers
    end

    # returns a new PullRequest object with the given number
    def pr(number)
      PullRequest.new(@request, number)
    end
  end
end
