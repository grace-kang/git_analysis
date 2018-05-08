require 'git_analyzer'

RSpec.describe GitAnalysis::Analyzer do
  it "has a version number" do
    expect(GitAnalysis::VERSION).not_to be nil
  end

  it "does something useful" do
    expect(false).to eq(true)
  end
end
