require 'git_analysis'

# check argument length
abort('Aborting: Incorrect number of arguments.') unless ARGV.length == 2

owner = ARGV[0]
repo = ARGV[1]

handler = GitAnalysis::NewHandler.new(owner, repo)
repo = handler.create_repo
pr = handler.create_pr(2734)
open_pr_count = handler.pr_number_list('open').count
closed_pr_count = handler.pr_number_list('closed').count

printer = GitAnalysis::Printer.new(repo, open_pr_count, closed_pr_count)
puts printer.basic_info
puts printer.num_prs
puts printer.pr_size(pr)
