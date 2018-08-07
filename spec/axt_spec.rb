RSpec.describe Axt do
  let(:example1) { Axt::Parser.new('answer = 42') }
  let(:example2) { Axt::Parser.new(code) }
  let(:code) { "def answer\n42\nend" }
  describe 'Parser#selector' do
    context 'one line parsing' do
      subject { example1.selector }

      it { is_expected.to be_respond_to(:expression) }
      it { expect(subject.expression).to eq('answer = 42') }
      it { expect(subject.name).to eq('answer') }
      it { expect(subject.node_type).to eq('dasgn_curr') }
      it { expect(subject.children.last.expression).to eq('42') }
    end

    context 'multiple lines parsing' do
      subject { example2.selector }

      it { expect(subject.expression).to eq(code) }
      it { expect(subject.name).to eq('def answer') }
      it { expect(subject.node_type).to eq('defn') }
      it { expect(subject.children.last.children.last.expression).to eq('42') }
    end
  end

  describe '#to_sexp' do
    context 'one line parsing' do
      subject { example1.to_sexp }
      it { is_expected.to eq(<<~SEXP.chomp) }
       (dasgn_curr answer
       (lit 42))
      SEXP
    end

    context 'multiline parsing' do
      subject { example2.to_sexp }
      specify do
        is_expected.to eq(<<~SEXP.chomp)
          (defn def answer
          (scope def answer
           (args )
           (lit 42)))
          SEXP
      end
    end
  end

end
