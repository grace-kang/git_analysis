require_relative 'lib/git_analysis/analyzer'
require 'octokit'

# check argument length
if ARGV.length != 1 
    abort("Aborting: Incorrect number of arguments.")
end

# initialize Octokit::Repository object from URL
url = ARGV[0]
begin
    repo = Octokit::Repository.from_url(url)
rescue Octokit::InvalidRepository => e
    abort("Aborting: Invalid repository URL")
end

owner = repo.owner
repo = repo.name.split('.')[0]

git_analyzer = GitAnalysis::Analyzer.new(ENV['TOKEN'], repo, owner)
git_analyzer.print_basic_info
git_analyzer.print_num_PRs
git_analyzer.print_PR_sizes
