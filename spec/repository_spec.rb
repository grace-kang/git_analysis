describe GitAnalysis::Repository do
  let(:id) { 30985840 }
  let(:repo) { 'solidus' }
  let(:owner) { 'solidusio' }
  let(:language) { 'Ruby' }
  
  describe '#initialize' do
    it 'returns a new GitAnalysis::Repository object' do
      object = GitAnalysis::Repository.new(id, repo, owner, language)
      expect(object.class).to eq(GitAnalysis::Repository)
    end
 end
end