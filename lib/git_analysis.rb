#!/usr/bin/ruby
require "octokit"
require 'git_analysis/analyzer'

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

