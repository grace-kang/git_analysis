require 'git_analysis'

# check argument length
abort('Aborting: Incorrect number of arguments.') unless ARGV.length == 2

owner = ARGV[0]
repo = ARGV[1]

auth = GitAnalysis::Authorization.new(owner, repo)
repo = auth.create_repo
pr = auth.create_pr(2734)
open_pr_count = auth.pr_number_list('open').count
closed_pr_count = auth.pr_number_list('closed').count

printer = GitAnalysis::Printer.new(repo, open_pr_count, closed_pr_count)
printer.print_basic_info
printer.print_num_prs
printer.print_pr_size(pr)
