require 'http'
require_relative 'authorization'

module GitAnalysis
    class Analyzer

        # initialize Analyzer and create an Authorization object
        def initialize(token, repo, owner)
            @request = Authorization.new(token, repo, owner)

            if @request.get_repo_code == 404
                abort('Aborting: Unable to find repository, please check URL.')
            elsif @request.get_repo_code == 401
                abort('Aborting: Invalid token, please check ENV["TOKEN"].')
            end
        end

        def get_id
            body = @request.get_repo
            info = JSON.parse(body)
            info['id']
        end

        def get_name
            body = @request.get_repo
            info = JSON.parse(body)
            info['name']
        end

        def get_owner
            body = @request.get_repo
            info = JSON.parse(body)
            info['login']
        end

        def get_language
            body = @request.get_repo
            info = JSON.parse(body)
            info['language']
        end

        def get_open_pr_count
            open_pulls = 0.to_s
            body = @request.get_PR('open', 1)
            headers = body.headers.inspect
            info = JSON.parse(body)
            if info.size > 0
                open_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1].split('&')[0]
            end
            open_pulls
        end

        def get_closed_pr_count
            closed_pulls = 0.to_s
            body = @request.get_PR('closed', 1)
            headers = body.headers.inspect
            info = JSON.parse(body)
            if info.size > 0 
                closed_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1].split('&')[0]
            end
            closed_pulls
        end

        def get_total_pr_count
            self.get_open_pr_count + self.get_closed_pr_count
        end

        # print repo ID, name, owner, language
        def print_basic_info
            body = @request.get_repo
            info = JSON.parse(body)
            puts ''
            puts '_______________________ Repository Information _______________________'
            puts ''
            puts 'ID: ' + info["id"].to_s
            puts 'Name: ' + info["name"]
            puts 'Owner: ' + info["owner"]["login"]
            puts 'Language: ' + info["language"]
            puts ''
            puts ''
        end
        
        # print the number of open, closed, and total pull requests
        def print_num_prs
            open_pulls = 0.to_s
            body = @request.get_PR('open', 1)
            headers = body.headers.inspect
            info = JSON.parse(body)
            if info.size > 0
                open_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1].split('&')[0]
            end
            puts '______________________ Number of Pull Requests ______________________'
            puts ''
            puts '    Open:   ' + open_pulls
        
            closed_pulls = 0.to_s
            body = @request.get_PR('closed', 1)
            headers = body.headers.inspect
            info = JSON.parse(body)
            if info.size > 0 
                closed_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1].split('&')[0]
            end
            puts '    Closed: ' + closed_pulls
            total_pulls = (open_pulls.to_i + closed_pulls.to_i).to_s
            puts '    Total:  ' + total_pulls
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
                num = info[0]['number']
                puts ''
                puts '-------------------- Number: ' + num.to_s + ' --------------------'
                # get PR files
                body = @request.get_PR_files(num)
                info = JSON.parse(body)
                info.each { |x|
                    puts ''
                    puts '    Filename: ' + x['filename'].to_s
                    puts '        Additions: ' + x['additions'].to_s
                    puts '        Deletions: ' + x['deletions'].to_s
                    puts '        Changes: ' + x['changes'].to_s
                }
                page += 1
            end
        end
    end
end