require 'http'
require_relative 'authorization'

module GitAnalysis
    class Analyzer
        def initialize(token, repo, owner)
            @request = Authorization.new(token, repo, owner)
        end

        def print_basic_info
            body = @request.get_repo
            info = JSON.parse(body)
            if info.has_key?("id") == false
                abort("error 2: invalid repository URL")
            end

            puts ""
            puts 'ID: ' + info["id"].to_s
            puts 'Name: ' + info["name"]
            puts 'Owner: ' + info["owner"]["login"]
            puts 'Language: ' + info["language"]
            puts ''
        end
        
        def print_PRs
            open_pulls = 0
            body = @request.get_prs('open')
            headers = body.headers.inspect
            open_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1]
            puts 'Number of Pull Requests'
            puts '    Open:   ' + open_pulls
        
            closed_pulls = 0
            body = @request.get_prs('closed')
            headers = body.headers.inspect
            closed_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1]
            puts '    Closed: ' + closed_pulls
            total_pulls = (open_pulls.to_i + closed_pulls.to_i).to_s
            puts '    Total:  ' + total_pulls
            puts ''
        end
    end
end