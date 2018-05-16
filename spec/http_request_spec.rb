describe GitAnalysis::HTTPRequest do
  let(:owner) { 'solidusio' }
  let(:repo) { 'solidus' }
  let(:not_found) { 404 }
  let(:bad_cred) { 401 }
  let(:api_exc) { 403 }

  describe '.raise_errors' do
    context '404: page not found' do
      it 'returns RepositoryError' do
        expect { GitAnalysis::HTTPRequest.raise_errors(not_found) }.to raise_error(GitAnalysis::ResponseError)
      end
    end

    context '401: bad credentials' do
      it 'returns RepositoryError' do
        expect { GitAnalysis::HTTPRequest.raise_errors(bad_cred) }.to raise_error(GitAnalysis::ResponseError)
      end
    end

    context '429: api rate limit exceeded' do
      it 'returns RepositoryError' do
        expect { GitAnalysis::HTTPRequest.raise_errors(api_exc) }.to raise_error(GitAnalysis::ResponseError)
      end
    end
  end

  describe '.repo' do
    it 'returns 200' do
      VCR.use_cassette('repo') do
        expect(GitAnalysis::HTTPRequest.repo(owner, repo).code).to eq(200)
      end
    end
  end

  describe '.repo_prs' do
    state = 'open'
    per_page = 100

    it 'returns 200' do
      VCR.use_cassette('repo_prs_p1') do
        expect(GitAnalysis::HTTPRequest.repo_prs(owner, repo, state, per_page, 1).code).to eq(200)
      end
    end

    context 'request page 2' do
      it 'returns 200' do
        VCR.use_cassette('repo_prs_p2') do
          expect(GitAnalysis::HTTPRequest.repo_prs(owner, repo, state, per_page, 2).code).to eq(200)
        end
      end
    end
  end

  describe '.pr' do
    # a closed pr number
    number = 2734

    it 'returns 200' do
      VCR.use_cassette('pr') do
        expect(GitAnalysis::HTTPRequest.pr(owner, repo, number).code).to eq(200)
      end
    end
  end

  describe '.pr_files' do
    # a closed pr number
    number = 2734

    it 'returns 200' do
      VCR.use_cassette('pr_files') do
        expect(GitAnalysis::HTTPRequest.pr_files(owner, repo, number).code).to eql(200)
      end
    end
  end
end
