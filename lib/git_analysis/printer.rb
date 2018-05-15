module GitAnalysis
  # prints information about the repository
  class Printer
    attr_reader :auth

    def initialize(owner, repo)
      @auth = GitAnalysis::Authorization.new(owner, repo)
    end

    # print repo ID, name, owner, language
    def print_basic_info
      repo = @auth.create_repo
      puts ''
      puts '___________________________ Repository Information ___________________________'
      puts ''
      puts 'ID: ' + repo.id.to_s
      puts 'Name: ' + repo.name
      puts 'Owner: ' + repo.owner
      puts 'Language: ' + repo.language
      puts ''
    end

    # print the number of open, closed, and total pull requests
    def print_num_prs
      open_prs = @auth.pr_number_list('open')
      closed_prs = @auth.pr_number_list('closed')
      puts '___________________________ Number of Pull Requests ___________________________'
      puts ''
      puts 'Open PRs:   ' + open_prs.count.to_s
      puts 'Closed PRs: ' + closed_prs.count.to_s
      puts ''
    end

    # for each PR, print the size
    def print_open_pr_sizes
      puts '___________________________ Open Pull Request Sizes ___________________________'
      puts ''
      pr_numbers = @auth.pr_number_list('open')
      pr_numbers.each do |x|
        pr = @auth.create_pr(x)
        puts 'PR ' + pr.number.to_s
        puts '  Files: ' + pr.file_count.to_s
        puts '  Additions: ' + pr.additions.to_s
        puts '  Deletions: ' + pr.deletions.to_s
        puts '  Changes: ' + pr.changes.to_s
        puts ''
      end
    end

    #TODO: fix this or get rid of it


    # for each contributor, print contributions and percentage ot total contributions
  #   def print_contributors
  #     puts '___________________________ Contributions ___________________________'
  #     puts ''
  #     page = 1
  #     total_contrib = 0

  #     loop do
  #       body = @request.contributors(page)
  #       info = JSON.parse(body)
  #       break if info.size == 0
  #       num = info.size
  #       cur = 0
  #       while cur < num do
  #         total_contrib += info[cur]['contributions']
  #         cur += 1
  #       end
  #       page += 1
  #     end
  #     page = 1
  #     loop do
  #       body = @request.get_contributors(page)
  #       info = JSON.parse(body)
  #       break if info.size == 0
  #       num = info.size
  #       cur = 0
  #       while cur < num do
  #         user = info[cur]['login']
  #         contrib = info[cur]['contributions']
  #         percent = (contrib.to_f / total_contrib)*100
  #         puts user + ': ' + contrib.to_s + ' (' + percent.to_i.to_s + '%)'
  #         cur += 1
  #       end
  #       page += 1
  #     end
  #   end
  end
end