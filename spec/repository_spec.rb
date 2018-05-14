describe GitAnalysis::Repository do
  let(:token) { ENV['TOKEN'] }
  let(:owner) { 'solidusio' }
  let(:repo) { 'solidus' }
  
  describe '#initialize' do
    it 'is of class GitAnalysis::Repository' do
      VCR.use_cassette('repo_info') do
        object = GitAnalysis::Repository.new(owner, repo)
        expect(object.class).to eq(GitAnalysis::Repository)
      end
    end
  end

  describe '#id' do
    it 'returns the repo id' do
      VCR.use_cassette('repo_info') do
        object = GitAnalysis::Repository.new(owner, repo)
        id = object.id
        expect(id).to eql(30985840)
      end
    end
  end

  describe '#name' do
    it 'returns the repo name' do
      VCR.use_cassette('repo_info') do
        request = GitAnalysis::Authorization.new(ENV['TOKEN'], repo, owner)
        res = JSON.parse(request.repo_info.body)
        expect(res.keys).to include('name')
      end
    end
  end

  describe '#owner' do
    it 'returns the repo owner' do
      VCR.use_cassette('repo_info') do
        request = GitAnalysis::Authorization.new(ENV['TOKEN'], repo, owner)
        res = JSON.parse(request.repo_info.body)
        expect(res.keys).to include('owner')
        expect(res['owner'].keys).to include('login')
      end
    end
  end

  describe '#language' do
    it 'returns the repo language' do
      VCR.use_cassette('repo_info') do
        request = GitAnalysis::Authorization.new(ENV['TOKEN'], repo, owner)
        res = JSON.parse(request.repo_info.body)
        expect(res.keys).to include('language')
      end
    end
  end

  describe '#open_pr_count' do
    it 'returns pull request page' do
      VCR.use_cassette('pull_request_count') do
        request = GitAnalysis::Authorization.new(ENV['TOKEN'], repo, owner)
        res = JSON.parse(request.pull_request_count('open',1))
        expect(res.keys).to include('number')
      end
    end
  end

  describe '#closed_pr_count' do
    subject { object }

    it 'returns pull request page' do
      VCR.use_cassette('pull_request_count') do
        request = GitAnalysis::Authorization.new(ENV['TOKEN'], repo, owner)
        res = JSON.parse(request.pull_request_count('closed',1))
        expect(res.keys).to include('number')
      end
    end
  end
end