require 'git_analysis'

# check argument length
abort('Aborting: Incorrect number of arguments.') unless ARGV.length == 2

owner = ARGV[0]
repo = ARGV[1]

git_analyzer = GitAnalysis::Printer.new(owner, repo)
git_analyzer.print_basic_info
git_analyzer.print_num_prs
# git_analyzer.print_open_pr_sizes
# git_analyzer.print_contributors
