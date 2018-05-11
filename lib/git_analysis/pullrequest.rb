module GitAnalysis
  # this class contains methods that retrieve a specific PR's information
  class PullRequest
    def initialize(authorization_instance, number)
      code = authorization_instance.single_pull_request_code(number)
      abort('Aborting: Cannot find specified pull request') if code != 200

      @request = authorization_instance
      @number = number
    end

    # returns the pull request owner
    def owner
      response = @request.single_pull_request(@number)
      info = JSON.parse(response)
      info['user']['login']
    end

    def add_to_size(size, file)
      size['additions'] += file['additions']
      size['deletions'] += file['deletions']
      size['changes'] += file['changes']
      size
    end

    # returns hash = {'file_count', 'additions', 'deletions', 'changes'}
    def size
      response = @request.pull_request_files(@number)
      info = JSON.parse(response)
      size = {}
      size['file_count'] = info.size
      size['additions'] = 0
      size['deletions'] = 0
      size['changes'] = 0
      info.each { |x| size = add_to_size(size, x) }
      size
    end
  end
end