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

        def get_repo
            message = 'https://api.github.com/repos/' + @owner + '/' + @repo
            body = HTTP.auth('token ' + @token).get(message).body
        end

        def get_prs(state)
            body = HTTP.get('https://api.github.com/repos/' + @owner + '/' + @repo + '/pulls?state=' + state + '&per_page=1')
        end
    end
end