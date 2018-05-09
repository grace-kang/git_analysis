require 'http'
require 'uri'
require_relative 'authorization'

module GitAnalysis
    class GitAnalyzer

        # initialize GitAnalyzer and create an Authorization object
        def initialize(repo_url)

            # check validity of given repository url
            unless repo_url =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
                abort("Aborting: Invalid URI")
            end

            uri = URI.parse(repo_url)

            unless uri.host =~ /github.com/
                abort("Aborting: not a github URL")
            end

            none, owner, repo = uri.path.split('/')

            if owner == nil or repo == nil
                abort('Aborting: invalid URL. Format: https://github.com/owner/repo')
            end

            # create Authorization object using token and repository info
            @request = Authorization.new(ENV['TOKEN'], repo, owner)

            # check if repository exists and token is valid
            if @request.get_repo_code == 404
                abort('Aborting: (404) Unable to find repository, please check URL.')
            elsif @request.get_repo_code == 401
                abort('Aborting: (401) Invalid token, please check ENV["TOKEN"].')
            end
        end

        # return id of repository
        def get_id
            body = @request.get_repo
            info = JSON.parse(body)
            info['id']
        end

        # return name of repository
        def get_name
            body = @request.get_repo
            info = JSON.parse(body)
            info['name']
        end

        # return owner of repository
        def get_owner
            body = @request.get_repo
            info = JSON.parse(body)
            info['owner']['login']
        end

        # return language of repository
        def get_language
            body = @request.get_repo
            info = JSON.parse(body)
            info['language']
        end

        # return number of open pull requests
        def get_open_pr_count
            open_pulls = 0.to_s
            body = @request.get_PR('open', 1)
            headers = body.headers.inspect
            info = JSON.parse(body)
            if info.size > 0
                open_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1].split('&')[0]
            end
            open_pulls.to_i
        end

        # return number of closed pull requests
        def get_closed_pr_count
            closed_pulls = 0.to_s
            body = @request.get_PR('closed', 1)
            headers = body.headers.inspect
            info = JSON.parse(body)
            if info.size > 0 
                closed_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1].split('&')[0]
            end
            total = 0
            closed_pulls.to_i
        end

        # return number of open and closed pull requests
        def get_total_pr_count
            self.get_open_pr_count + self.get_closed_pr_count
        end

        # print repo ID, name, owner, language
        def print_basic_info
            puts ''
            puts '_______________________ Repository Information _______________________'
            puts ''
            puts 'ID: ' + self.get_id.to_s
            puts 'Name: ' + self.get_name
            puts 'Owner: ' + self.get_owner
            puts 'Language: ' + self.get_language
            puts ''
            puts ''
        end
        
        # print the number of open, closed, and total pull requests
        def print_num_prs
            puts '______________________ Number of Pull Requests ______________________'
            puts ''
            puts 'Open:   ' + self.get_open_pr_count.to_s
        
            puts 'Closed: ' + self.get_closed_pr_count.to_s

            puts 'Total:  ' + self.get_total_pr_count.to_s
            puts ''
            puts ''
        end
        
        # for each PR, print the size
        def print_pr_sizes
            puts '_________________________ Pull Request Sizes _________________________'
            puts ''
            page = 1
            loop do
                body = @request.get_PR('open', page)
                info = JSON.parse(body)
                break if info.size == 0
                items = info.size
                cur = 0
                while cur < items do
                    num = info[cur]['number']
                    user = info[cur]['user']['login']
                    puts ''
                    puts '-------------------- Number: ' + num.to_s + ' --------------------'
                    puts 'User: ' + user
                    # get PR files
                    body = @request.get_PR_files(num)
                    info = JSON.parse(body)
                    file_count = 0
                    additions = 0
                    deletions = 0
                    changes = 0
                    info.each { |x|
                        file_count += 1
                        additions += x['additions']
                        deletions += x['deletions']
                        changes += x['changes']
                    }
                    puts '    Number of Files: ' + file_count.to_s
                    puts '    Additions: ' + additions.to_s
                    puts '    Deletions: ' + deletions.to_s
                    puts '    Changes: ' + changes.to_s
                    cur += 1
                end
                page += 1
            end
        end

        # for each contributor, print contributions and percentage ot total contributions
        def print_contributors
            puts '___________________________ Contributions ___________________________'
            puts ''
            page = 1
            total_contrib = 0

            loop do
                body = @request.get_contributors(page)
                info = JSON.parse(body)
                break if info.size == 0
                num = info.size
                cur = 0
                while cur < num do
                    total_contrib += info[cur]['contributions']
                    cur += 1
                end
                page += 1
            end

            page = 1
            loop do
                body = @request.get_contributors(page)
                info = JSON.parse(body)
                break if info.size == 0
                num = info.size
                cur = 0
                while cur < num do
                    user = info[cur]['login']
                    contrib = info[cur]['contributions']
                    percent = (contrib.to_f / total_contrib)*100
                    puts user + ': ' + contrib.to_s + ' (' + percent.to_i.to_s + '%)'
                    cur += 1
                end
                page += 1
            end
        end
    end
end