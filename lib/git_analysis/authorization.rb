require 'http'

module GitAnalysis
    class Authorization
        attr_reader :token
        attr_reader :repo
        attr_reader :owner

        def initialize(token, repo, owner)
            @token = token
            @repo = repo
            @owner = owner
        end

        # get a specific repo
        def get_repo
            message = 'https://api.github.com/repos/' + @owner + '/' + @repo
            body = HTTP.auth('token ' + @token).get(message).body
        end

        # get a specific PR given the state and the page number
        def get_PRs(state, page)
            message = 'https://api.github.com/repos/' + @owner + '/' + @repo + '/pulls?state=' + state + '&page=' + page.to_s + '&per_page=1'
            body = HTTP.auth('token ' + @token).get(message)
        end

        def get_PR_files(number)
            message = 'https://api.github.com/repos/' + @owner + '/' + @repo + '/pulls/' + number.to_s + '/files'
            body = HTTP.auth('token ' + @token).get(message)
        end    
    end
end