module GitAnalysis
  # this class contains methods that retrieve a specific PR's information
  class PullRequest
    def initialize(authorization_instance, number)
      @request = authorization_instance
      @number = number
      
      if @request.single_pull_request_code(number) != 200
        abort('Aborting: Cannot find specified pull request')
      end
    end

    # returns the pull request owner
    def owner
      response = @request.single_pull_request(@number)
      info = JSON.parse(response)
      info['user']['login']
    end

    # returns hash = {'file_count', 'additions', 'deletions', 'changes'}
    def size
      response = @request.pull_request_files(@number)
      info = JSON.parse(response)
      size = Hash.new
      size['file_count'] = info.size
      size['additions'] = 0
      size['deletions'] = 0
      size['changes'] = 0
      info.each { |x|
        size['additions'] += x['additions']
        size['deletions'] += x['deletions']
        size['changes'] += x['changes']
      }
      size
    end
  end
end
  