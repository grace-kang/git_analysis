module GitAnalysis
    class Analyzer
        attr_reader :repo
        attr_reader :owner

        def initialize(repo, owner)
            @repo = repo
            @owner = owner
        end

        def print_basic_info
            body = HTTP.get('https://api.github.com/repos/' + Analyzer.owner + '/' + Analyzer.repo).body
        
            info = JSON.parse(body)
        
            if info.has_key?("id") == false
                abort("error 2: invalid repository URL")
            end
        
            puts ""
            puts 'ID: ' + info["id"].to_s
            puts 'Name: ' + info["name"]
            puts 'Owner: ' + info["owner"]["login"]
            puts 'Language: ' + info["language"]
        end
        
        def print_PRs
            puts ''
            open_pulls = 0
            body = HTTP.get('https://api.github.com/repos/' + Analyzer.owner + '/' + Analyzer.repo + '/pulls?per_page=1')
            headers = body.headers.inspect
            open_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1]
            puts 'Number of Pull Requests'
            puts '    Open: ' + open_pulls
        
            closed_pulls = 0
            body = HTTP.get('https://api.github.com/repos/' + Analyzer.owner + '/' + Analyzer.repo + '/pulls?state=closed&per_page=1')
            headers = body.headers.inspect
            closed_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1]
            puts '    Closed: ' + closed_pulls
            total_pulls = (open_pulls.to_i + closed_pulls.to_i).to_s
            puts '    Total: ' + total_pulls
        end
    end
end