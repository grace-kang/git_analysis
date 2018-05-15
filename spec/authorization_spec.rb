describe GitAnalysis::Authorization do
  # let(:token) { ENV['TOKEN'] }
  let(:owner) { 'solidusio' }
  let(:repo) { 'solidus' }
  let(:auth) { GitAnalysis::Authorization.new(owner, repo) }
  let(:not_found) { 404 }
  let(:bad_cred) { 401 }
  let(:api_exc) { 429 }

  describe '#initialize' do
    it 'returns a new GitAnalysis::Authorization object' do
      expect(auth.class).to eq(GitAnalysis::Authorization)
    end
  end

  describe '#raise_errors' do
    context '404: page not found' do
      it 'returns RepositoryError' do
        expect{auth.raise_errors(not_found)}.to raise_error(GitAnalysis::RepositoryError)
      end
    end
      
    context '401: bad credentials' do
      it 'returns RepositoryError' do
        expect{auth.raise_errors(bad_cred)}.to raise_error(GitAnalysis::RepositoryError)
      end
    end

    context '429: api rate limit exceeded' do
      it 'returns RepositoryError' do
        expect{auth.raise_errors(api_exc)}.to raise_error(GitAnalysis::RepositoryError)
      end
    end
  end

  describe '#request_repo' do
    it 'returns 200' do
      VCR.use_cassette('request_repo') do
        expect(auth.request_repo.code).to eq(200)
      end
    end
  end

  describe '#create_repo' do
    it 'creates a GitAnalysis::Repository object' do
      VCR.use_cassette('repo_info') do
        object = auth.create_repo
        expect(object.class).to eq(GitAnalysis::Repository)
      end
    end
  end

  describe '#request_pr_list'do
    state = 'open'
    per_page = 100

    it 'returns 200' do
      VCR.use_cassette('request_pr_list_p1') do
        expect(auth.request_pr_list(state, per_page, 1).code).to eq(200)
      end
    end

    context 'request page 2' do
      it 'returns 200' do
        VCR.use_cassette('request_pr_list_p2') do
          expect(auth.request_pr_list(state, per_page, 2).code).to eq(200)
        end
      end
    end
  end

  describe '#request_pr' do
    # a closed pr number
    number = 2734

    it 'returns 200' do
      VCR.use_cassette('request_pr') do
        expect(auth.request_pr(number).code).to eq(200)
      end
    end
  end

  describe '#pr_number_list' do
    state = 'open'

    it 'returns an array of pr numbers' do
      VCR.use_cassette('request_pr_list_p2') do
        VCR.use_cassette('request_pr_list_p1') do
          expect(auth.pr_number_list(state).class).to eq(Array)
        end
      end
    end
  end

  describe '#request_pr_files' do
    # a closed pr number
    number = 2734

    it 'returns 200' do
      VCR.use_cassette('request_pr_files') do
        expect(auth.request_pr_files(number).code).to eql(200)
      end
    end
  end

  describe '#create_pr' do
    number = 2734

    it 'returns 200' do
      VCR.use_cassette('request_pr_files') do
        VCR.use_cassette('request_pr') do
          object = auth.create_pr(number)
          expect(object.class).to eq(GitAnalysis::PullRequest)
        end
      end
    end
  end
end
