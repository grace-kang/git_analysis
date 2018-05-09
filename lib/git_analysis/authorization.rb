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
        def get_repo
            message = 'https://api.github.com/repos/' + @owner + '/' + @repo
            HTTP.auth('token ' + @token).get(message)
        end

        # get status code of the repo GET request
        def get_repo_code
            message = 'https://api.github.com/repos/' + @owner + '/' + @repo
            HTTP.auth('token ' + @token).get(message).code
        end

        # get a specific PR given the state and the page number
        def get_PR(state, page)
            message = 'https://api.github.com/repos/' + @owner + '/' + @repo + '/pulls?state=' + state + '&page=' + page.to_s + '&per_page=1'
            HTTP.auth('token ' + @token).get(message)
        end

        # get status code of a repo's PR get request
        def get_PR_code(state, page)
            message = 'https://api.github.com/repos/' + @owner + '/' + @repo + '/pulls?state=' + state + '&page=' + page.to_s + '&per_page=100'
            HTTP.auth('token ' + @token).get(message).code
        end

        # get the files for a specific PR
        def get_PR_files(number)
            message = 'https://api.github.com/repos/' + @owner + '/' + @repo + '/pulls/' + number.to_s + '/files'
            HTTP.auth('token ' + @token).get(message)
        end    

        # get contributors for the repo
        def get_contributors(page)
            message = 'https://api.github.com/repos/' + @owner + '/' + @repo + '/contributors?page=' + page.to_s + '&per_page=100'
            HTTP.auth('token ' + @token).get(message)
        end
    end
end