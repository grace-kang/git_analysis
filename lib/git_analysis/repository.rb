module GitAnalysis
  # this object analyzes a repository given the owner and the repo name
  class Repository
    attr_reader :id
    attr_reader :name
    attr_reader :owner
    attr_reader :language

    def initialize(id, name, owner, language)
      @id = id
      @name = name
      @owner = owner
      @language = language
    end
  end
end
