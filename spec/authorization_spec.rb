describe GitAnalysis::Authorization do
  let(:token) { ENV['TOKEN'] }
  let(:owner) { 'solidusio' }
  let(:repo) { 'solidus' }

  describe '#initialize' do
    it 'returns a new GitAnalysis::Authorization object' do
      request = GitAnalysis::Authorization.new(token, repo, owner)
      expect(request.class).to eq(GitAnalysis::Authorization)
    end
  end

  describe '#repo_info' do
    it 'queries the repository information on github' do
      VCR.use_cassette('repo_info') do
        request = GitAnalysis::Authorization.new(token, repo, owner)
        info = JSON.parse(request.repo_info)
        expect(info).to include('id')
      end
    end

    context 'repo doesnt exist' do
      it 'returns 404' do
        VCR.use_cassette('invalid_repo') do
          request = GitAnalysis::Authorization.new(token, 'idontexistawejrghjhjd', 'foo')
          code = request.repo_info.code
          expect(code).to eq(404)
        end
      end
    end

    context 'token is invalid' do
      it 'returns 401' do
        VCR.use_casette('token_invalid_repo') do
          request = GitAnalysis::Authorization.new('invalidtoken123', repo, owner)
          code = request.repo_info.code
          expect(code).to eq(401)
        end
      end
    end
  end  

  describe '#repo_info_code' do
    it 'returns 200' do
      VCR.use_cassette('repo_info') do
        request = GitAnalysis::Authorization.new(token, repo, owner)
        code = request.repo_info.code
        expect(code).to eq(200)
      end
    end


  end

  describe '#pull_request_count' do
   it 'returns 200' do
    VCR.use_cassette('pull_request_count') do
      request = GitAnalysis::Authorization.new(token, repo, owner)
      info = JSON.parse(request.pull_request_count('open', 1))
      expect(info[0]).to include('number')
    end
   end
  end

  describe '#pull_requests' do
    state = 'open'
    page = 1
    before do
      stub_request(:get, "https://api.github.com/repos/#{owner}/#{repo}/pulls?page=#{page}&per_page=100&state=#{state}").
      to_return(status: 200, headers: {})
    end

    it 'returns 200' do
      
    end
  end

  describe '#single_pull_request' do
    number = 1234
    before do
      stub_request(:get, "https://api.github.com/repos/#{owner}/#{repo}/pulls/#{number}").
      to_return(status: 200, headers: {})
    end

    it 'returns 200' do
      expect(request.single_pull_request(number).code).to eql(200)
    end
  end

  describe '#single_pull_request_code' do
    number = 1234
    before do
      stub_request(:get, "https://api.github.com/repos/#{owner}/#{repo}/pulls/#{number}").
      to_return(status: 200, headers: {})
    end

    it 'returns 200' do
      expect(request.single_pull_request_code(number)).to eql(200)
    end
  end

  describe '#pull_request_files' do
    number = 1234
    before do
      stub_request(:get, "https://api.github.com/repos/#{owner}/#{repo}/pulls/#{number}/files").
      to_return(status: 200, headers: {})
    end

    it 'returns 200' do
      expect(request.pull_request_files(number).code).to eql(200)
    end
  end

  describe '#contributors' do
    page = 1
    before do
      stub_request(:get, "https://api.github.com/repos/#{owner}/#{repo}/contributors?page=#{page}&per_page=100").
      to_return(status: 200, headers: {})
    end

    it 'returns 200' do
      expect(request.contributors(page).code).to eql(200)
    end
  end
end
