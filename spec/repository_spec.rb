describe GitAnalysis::Repository do
  let(:id) { 30985840 }
  let(:repo) { 'solidus' }
  let(:owner) { 'solidusio' }
  let(:language) { 'Ruby' }
  
  describe '#initialize' do
    it 'is of class GitAnalysis::Repository' do
      object = GitAnalysis::Repository.new(id, repo, owner, language)
      expect(object.class).to eq(GitAnalysis::Repository)
    end
 end
end