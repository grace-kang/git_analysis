module GitAnalysis
  # this class contains methods that retrieve a specific PR's information
  class PullRequest
      attr_reader :number
      attr_reader :file_count
      attr_reader :additions
      attr_reader :deletions
      attr_reader :changes

    def initialize(number, file_count, additions, deletions, changes)
      @number = number
      @file_count = file_count
      @additions = additions
      @deletions = deletions
      @changes = changes
    end
  end
end