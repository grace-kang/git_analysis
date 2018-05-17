describe GitAnalysis::ObjectHandler do
  let(:owner) { 'solidusio' }
  let(:repo) { 'solidus' }
  let(:handler) { GitAnalysis::ObjectHandler.new(owner, repo) }

  describe '#initialize' do
    it 'returns a new GitAnalysis::ObjectHandler object' do
      expect(handler.class).to eq(GitAnalysis::ObjectHandler)
    end
  end

  describe '#create_repo' do
    it 'returns a new GitAnalysis::Repository object' do
      VCR.use_cassette('repo') do
        object = handler.create_repo
        expect(object.class).to eq(GitAnalysis::Repository)
      end
    end
  end

  describe '#pr_number_list' do
    state = 'open'

    it 'returns an array of pr numbers' do
      VCR.use_cassette('repo_prs_p2') do
        VCR.use_cassette('repo_prs_p1') do
          expect(handler.pr_number_list(state).class).to eq(Array)
        end
      end
    end
  end

  describe '#create_pr' do
    number = 2734

    it 'returns a new GitAnalysis::PullRequest object' do
      VCR.use_cassette('pr_files') do
        VCR.use_cassette('pr') do
          object = handler.create_pr(number)
          expect(object.class).to eq(GitAnalysis::PullRequest)
        end
      end
    end
  end
end