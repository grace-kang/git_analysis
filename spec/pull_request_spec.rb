describe GitAnalysis::PullRequest do
  let(:number) { 2734 }
  let(:file_count) { 1 }
  let(:additions) { 1 }
  let(:deletions) { 0 }
  let(:changes) { 1 }

  describe '#initialize' do
    it 'returns a new GitAnalysis::PullRequest object' do
      object = GitAnalysis::PullRequest.new(number, file_count, additions, deletions, changes)
      expect(object.class).to eq(GitAnalysis::PullRequest)
    end
  end
end