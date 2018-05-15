describe GitAnalysis::Printer do
  let(:repo) { GitAnalysis::Repository.new(30985840, 'solidus', 'solidusio', 'Ruby') }
  let(:open_pr_count) { 123 }
  let(:closed_pr_count) { 1234 }
  let(:object) { GitAnalysis::Printer.new(repo, open_pr_count, closed_pr_count) }
  let(:pr_object) { GitAnalysis::PullRequest.new(123, 2, 36, 3, 6) }

  describe '#initialize' do
    it 'returns a new GitAnalysis::Printer object' do
      expect(object.class).to eq(GitAnalysis::Printer)
    end
  end

  describe '#print_basic_info' do
    it 'prints basic repository information' do
      expect { object.print_basic_info }.to output('ID: ' + 
        repo.id.to_s + + "\n" + 'Name: ' + repo.name + "\n" + 'Owner: ' + 
        repo.owner + "\n" + 'Language: ' + repo.language + "\n").to_stdout
    end
  end

  describe '#print_num_prs' do
    it 'prints the number of open and closed pull requests' do
      expect { object.print_num_prs }.to output('Open PRs:   ' + 
        object.open_pr_count.to_s + "\n" + 'Closed PRs: ' + 
        object.closed_pr_count.to_s + "\n").to_stdout
    end
  end

  describe '#print_pr_size' do
    it 'prints the size of the given pr' do
      expect { object.print_pr_size(pr_object) }.to output('PR ' +
        pr_object.number.to_s + "\n" + '  Files: ' + pr_object.file_count.to_s + 
        "\n" + '  Additions: ' + pr_object.additions.to_s + "\n" + '  Deletions: ' +
        pr_object.deletions.to_s + "\n" + '  Changes: ' + pr_object.changes.to_s + "\n").
        to_stdout
    end
  end
end