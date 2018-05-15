describe GitAnalysis::ResponseError do
  let(:message) { 'ResponseError message' }
  let(:error) { GitAnalysis::ResponseError.new(message) }

  describe '#initialize' do
    it 'is an instance of ResponseError' do
      expect(error.class).to eq(GitAnalysis::ResponseError)
      expect(error.message).to eq(message)
    end
  end
end