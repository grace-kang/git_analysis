require_relative 'lib/git_analysis/gitanalyzer'
require 'octokit'

# check argument length
if ARGV.length != 1 
    abort("Aborting: Incorrect number of arguments.")
end

# initialize Octokit::Repository object from URL
url = ARGV[0]

git_analyzer = GitAnalysis::GitAnalyzer.new(url)
git_analyzer.print_basic_info
git_analyzer.print_num_prs
git_analyzer.print_pr_sizes
