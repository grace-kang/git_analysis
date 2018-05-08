#!/usr/bin/ruby
require "octokit"

def print_basic_info(owner, repo)
    body = HTTP.get('https://api.github.com/repos/' + owner + '/' + repo).body

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

def print_PRs(owner, repo)
    puts ''
    open_pulls = 0
    body = HTTP.get('https://api.github.com/repos/' + owner + '/' + repo + '/pulls?per_page=1')
    headers = body.headers.inspect
    open_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1]
    puts 'Number of Pull Requests'
    puts '    Open: ' + open_pulls

    closed_pulls = 0
    body = HTTP.get('https://api.github.com/repos/' + owner + '/' + repo + '/pulls?state=closed&per_page=1')
    headers = body.headers.inspect
    closed_pulls = headers.split('rel=\"next\"')[1].split('>; rel=\"last\"')[0].split("&page=")[1]
    puts '    Closed: ' + closed_pulls
    total_pulls = (open_pulls.to_i + closed_pulls.to_i).to_s
    puts '    Total: ' + total_pulls
end

# check argument length
if ARGV.length != 1 
    abort("incorrect number of arguments.")
end

# initialize Octokit::Repository object from URL
url = ARGV[0]
begin
    repo = Octokit::Repository.from_url(url)
rescue Octokit::InvalidRepository => e
    abort("error 1: invalid repository URL")
end

owner = repo.owner
repo = repo.name.split('.')[0]

print_basic_info(owner, repo)
print_PRs(owner, repo)

