RSpec.describe Axt do
  describe '.ast' do
    context 'one line parsing' do
      subject { Axt.ast('answer = 42') }
      it { expect(subject.expression).to eq('answer = 42') }
      it { expect(subject.name).to eq(:answer) }
      it { expect(subject.type).to eq(:lasgn) }
      it { expect(subject.children.last.expression).to eq('42') }
    end
    context 'multiline parsing' do
      subject { Axt.ast(<<~RUBY) }
        def answer
           { result: 42 }
        end
      RUBY
      it { expect(subject.children[1].children[-1].expression).to eq(<<~RUBY) }
        { result: 42 }
      RUBY
      it { expect(subject.name).to eq(:answer) }
      it { expect(subject.children[1].children[-1].name.name.name).to eq(:result) }
    end
  end
end
