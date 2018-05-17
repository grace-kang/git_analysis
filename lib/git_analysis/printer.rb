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
    def basic_info
      "ID: #{@repo.id}\nName: #{@repo.name}\nOwner: #{@repo.owner}\nLanguage: #{@repo.language}\n"
    end

    # print the number of open and closed pull requests
    def num_prs
      "Open PRs:    #{open_pr_count}\nClosed PRs:  #{closed_pr_count}\n"
    end

    # for each PR, print the size
    def pr_size(pr_object)
      "PR #{pr_object.number}\n  Files: #{pr_object.file_count}\n  Additions: #{pr_object.additions}\n  Deletions: #{pr_object.deletions}\n  Changes: #{pr_object.changes}\n"
    end
  end
end
