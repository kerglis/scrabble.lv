require 'spec_helper'

describe Dictionary do
  let!(:dict) { Dictionary.new(:xx) }

  describe 'distinct a from ā, etc' do
    it do
      dict.add('āēīū')
      dict.add('aeiu')
      dict.add('ģķļņ')
      dict.add('gkln')

      expect(dict.check?('āēīū')).to be true
      expect(dict.check?('ģķļņ')).to be true
      expect(dict.check?('āēiu')).to be false
      expect(dict.check?('ģķln')).to be false
      expect(dict.valid_words_from_chars('āēīūxyz').count).to eq 1
    end
  end

  describe '#find_possible_words_from_chars' do
    it do
      expect(
        Dictionary.find_possible_words_from_chars('abcdefgi').count
      ).to eq(
        Dictionary.find_possible_words_from_chars('abcdefg').count
      )
    end
  end

  describe 'string functions' do
    describe '#insert_ch' do
      it do
        expect('abc'.insert_ch(0, 'x')).to eq 'xabc'
        expect('abc'.insert_ch(1, 'x')).to eq 'axbc'
        expect('abc'.insert_ch(4, 'x')).to eq 'abc'
      end
    end

    describe '#insert_ch!' do
      let!(:abc) { 'abc' }
      it do
        expect(abc.insert_ch!(4, 'x')).to be_nil
        expect(abc).to eq 'abc'
        expect(abc.insert_ch!(3, 'x')).to be true
        expect(abc).to eq 'abcx'
      end
    end

    describe '#insert_chars_at' do
      let!(:chars) { { 1 => 'x', 3 => 'y' } }

      it do
        expect('abc'.insert_chars_at(0, chars)).to eq 'axbyc'
        expect('abc'.insert_chars_at(1, chars)).to eq 'abxcy'
        expect('abc'.insert_chars_at(2, chars)).to eq 'abcx'
        expect('abc'.insert_chars_at(3, chars)).to eq 'abc'
      end
    end

    describe '#insert_chars_at!' do
      let!(:abc) { 'abc' }
      let!(:chars) { { 1 => 'x', 3 => 'y' } }

      it do
        expect(abc.insert_chars_at!(0, chars)).to be true
        expect(abc).to eq 'axbyc'
      end

      it do
        expect(abc.insert_chars_at!(3, chars)).to be_nil
        expect(abc).to eq 'abc'
      end
    end
  end

  describe '#apply_prepositions' do
    subject do
      Dictionary.apply_prepositions(word, chars: chars, from: 0, to: to).map do |x|
        x.split('@').first
      end
    end

    it { expect(Dictionary.apply_prepositions('abcd')).to eq 'abcd' }

    context 'abxcdy' do
      let(:word) { 'abcd' }
      let(:chars) { { 2 => 'x', 5 => 'y' } }
      let(:to) { 5 }
      it { is_expected.to eq ['abxcdy'] }
    end

    context 'abx, axb, xaby' do
      let(:word) { 'ab' }
      let(:chars) { { 2 => 'x', 5 => 'y' } }
      let(:to) { 5 }
      it { is_expected.to eq %w(abx axb xaby) }
    end

    context 'abxy' do
      let(:word) { 'ab' }
      let(:chars) { { 2 => 'x', 3 => 'y' } }
      let(:to) { 3 }
      it { is_expected.to eq ['abxy'] }
    end

    context 'xyab' do
      let(:word) { 'ab' }
      let(:chars) { { 0 => 'x', 1 => 'y' } }
      let(:to) { 3 }
      it { is_expected.to eq ['xyab'] }
    end

    context 'xaybzc, yazbc' do
      let(:word) { 'abc' }
      let(:chars) { { 0 => 'x', 2 => 'y', 4 => 'z' } }
      let(:to) { 6 }
      it { is_expected.to eq %w(xaybzc yazbc) }
    end
  end

  describe '#valid_words_from_chars' do
    it do
      dict.add('xay')
      dict.add('xaybz')
      dict.add('xey')
      dict.add('ybz')

      expect(
        dict.valid_words_from_chars(
          'abcdefi',
          chars: { 0 => 'x', 2 => 'y', 4 => 'z' },
          from: 0,
          to: 5
        ).count
      ).to eq 4
    end
  end
end
