require 'git_analysis'

# check argument length
abort('Aborting: Incorrect number of arguments.') unless ARGV.length == 2

owner = ARGV[0]
repo = ARGV[1]

handler = GitAnalysis::ObjectHandler.new(owner, repo)
repo = handler.create_repo
pr = handler.create_pr(2734)
open_pr_count = handler.pr_number_list('open').count
closed_pr_count = handler.pr_number_list('closed').count

printer = GitAnalysis::Printer.new(repo, open_pr_count, closed_pr_count)
printer.basic_info
printer.num_prs
printer.pr_size(pr)
