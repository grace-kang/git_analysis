describe GitAnalysis::Repository do
  let(:owner) { 'solidusio' }
  let(:repo) { 'solidus' }
  let(:id) { 30985840 }
  let(:language) { 'Ruby' }
  let(:open_prs) { 50 }
  subject { GitAnalysis::Repository.new(owner, repo) }
  
  describe '#initialize' do
    it { is_expected.to be_a GitAnalysis::Repository }
  end

  describe '#get_id' do
    it 'returns the repo id' do
      expect(subject.get_id).to eq(id)
    end
  end

  describe '#get_name' do
    it 'returns the repo name' do
      expect(subject.get_name).to eq(repo)
    end
  end

  describe '#get_owner' do
    it 'returns the repo owner' do
      expect(subject.get_owner).to eq(owner)
    end
  end

  describe '#get_language' do
    it 'returns the repo language' do
      expect(subject.get_language).to eq(language)
    end
  end

  describe '#get_open_pr_count' do
    it 'returns open pr count' do
      expect(subject.get_open_pr_count).to eq(open_prs)
    end
  end
end