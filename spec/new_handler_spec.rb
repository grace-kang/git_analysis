describe GitAnalysis::NewHandler do
  let(:owner) { 'solidusio' }
  let(:repo) { 'solidus' }
  let(:handler) { GitAnalysis::NewHandler.new(owner, repo) }
  let(:client) { Octokit::Client.new(:access_token => ENV['CHANGELOG_GITHUB_TOKEN']) }
  let(:octo_repo) { client.repository("#{owner}/#{repo}") }

  describe '#initialize' do
    it 'returns a new GitAnalysis::ObjectHandler object' do
      VCR.use_cassette('octo_repo') do
        expect(handler.class).to eq(GitAnalysis::NewHandler)
      end
    end
  end

  describe '#create_repo' do
    it 'returns a new GitAnalysis::Repository object' do
      VCR.use_cassette('octo_repo') do
        expect(handler.create_repo.class).to eq(GitAnalysis::Repository)
      end
    end
  end

  describe '#pr_number_list' do
    state = 'open'

    it 'gets lists of prs - page 1' do
      VCR.use_cassette('octo_repo_prs_p1') do
        prs = client.pull_requests(octo_repo.id, :state => state, :per_page => 100, :page => 1)
        expect(prs.class).to eq(Array)
      end
    end

    it 'gets list of prs - page 2' do
      VCR.use_cassette('octo_repo_prs_p2') do
        prs = client.pull_requests(octo_repo.id, :state => state, :per_page => 100, :page => 2)
        expect(prs.class).to eq(Array)
      end
    end

    it 'returns an array of pr numbers' do
      VCR.use_cassette('octo_repo_prs_p2') do
        VCR.use_cassette('octo_repo_prs_p1') do
          expect(handler.pr_number_list(state).class).to eq(Array)
        end
      end
    end
  end

  describe '#create_pr' do
    number = 2734

    it 'gets a single pr' do
      VCR.use_cassette('octo_pr') do
        pr = client.pull_request(octo_repo.id, number)
        expect(pr.number).to eq(number)
      end
    end

    it 'gets pr files' do
      VCR.use_cassette('octo_pr_files') do
        files = client.pull_request_files(octo_repo.id, number)
        expect(files.class).to eq(Array)
      end
    end

    it 'returns a new GitAnalysis::PullRequest object' do
      VCR.use_cassette('octo_pr_files') do
        VCR.use_cassette('octo_pr') do
          expect(handler.create_pr(number).class).to eq(GitAnalysis::PullRequest)
        end
      end
    end
  end
end
