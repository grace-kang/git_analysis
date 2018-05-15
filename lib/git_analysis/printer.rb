module GitAnalysis
  # prints information about the repository
  class Printer
    attr_reader :repo
    attr_reader :open_pr_count
    attr_reader :closed_pr_count

    def initialize(repo_object, open_pr_count, closed_pr_count)
      @repo = repo_object
      @open_pr_count = open_pr_count
      @closed_pr_count = closed_pr_count
    end

    # print repo ID, name, owner, language
    def print_basic_info
      puts 'ID: ' + @repo.id.to_s
      puts 'Name: ' + @repo.name
      puts 'Owner: ' + @repo.owner
      puts 'Language: ' + @repo.language
    end

    # print the number of open, closed, and total pull requests
    def print_num_prs
      puts 'Open PRs:   ' + open_pr_count.to_s
      puts 'Closed PRs: ' + closed_pr_count.to_s
    end

    # for each PR, print the size
    def print_pr_size(pr_object)
      puts 'PR ' + pr_object.number.to_s
      puts '  Files: ' + pr_object.file_count.to_s
      puts '  Additions: ' + pr_object.additions.to_s
      puts '  Deletions: ' + pr_object.deletions.to_s
      puts '  Changes: ' + pr_object.changes.to_s
    end
  end
end