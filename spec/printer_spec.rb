describe GitAnalysis::Printer do
  let(:repo) { GitAnalysis::Repository.new(30985840, 'solidus', 'solidusio', 'Ruby') }
  let(:open_pr_count) { 123 }
  let(:closed_pr_count) { 1234 }
  let(:object) { GitAnalysis::Printer.new(repo, open_pr_count, closed_pr_count) }
  let(:pr_object) { GitAnalysis::PullRequest.new(123, 'user', 2, 36, 3, 6) }

  describe '#initialize' do
    it 'returns a new GitAnalysis::Printer object' do
      expect(object.class).to eq(GitAnalysis::Printer)
    end
  end

  describe '#basic_info' do
    it 'prints basic repository information' do
      expect(object.basic_info).to include("ID: #{repo.id}")
    end
  end

  describe '#num_prs' do
    it 'prints the number of open and closed pull requests' do
      expect(object.num_prs).to include("Open PRs: #{open_pr_count}")
    end
  end

  describe '#pr_size' do
    it 'prints the size of the given pr' do
      expect(object.pr_size(pr_object)).to include("PR #{pr_object.number}")
    end
  end
end
