module GitAnalysis
  # an error that is raised when an invalid response is given
  class ResponseError < StandardError
    attr_reader :message

    def initialize(message)
      @message = message
    end
  end
end
