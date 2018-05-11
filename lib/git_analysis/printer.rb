module GitAnalysis
  # prints information about the repository
  class Printer
    def initialize(owner, repo)
      @repo = GitAnalysis::Repository.new(owner, repo)
    end

    # print repo ID, name, owner, language
    def print_basic_info
      puts ''
      puts 'ID: ' + @repo.id.to_s
      puts 'Name: ' + @repo.name
      puts 'Owner: ' + @repo.owner
      puts 'Language: ' + @repo.language
      puts ''
    end
  
    # print the number of open, closed, and total pull requests
    def print_num_prs
      puts ''
      puts 'Open PRs:   ' + @repo.open_pr_count.to_s
      puts 'Closed PRs: ' + @repo.closed_pr_count.to_s
      puts ''
    end
  
    # for each PR, print the size
    def print_open_pr_sizes
      puts ''
      pr_numbers = @repo.open_pr_numbers
      pr_numbers.each { |x|
        pr = @repo.pr(x)
        size = pr.size
        puts 'PR ' + x.to_s
        puts '  Files: ' + size['file_count'].to_s
        puts '  Additions: ' + size['additions'].to_s
        puts '  Deletions: ' + size['deletions'].to_s
        puts '  Changes: ' + size['changes'].to_s
        puts ''
      }
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