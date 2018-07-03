require 'spec_helper'

describe Dictionary do
  let!(:dict) { Dictionary.new(:lv) }

  describe 'diacritical letters should have exact match' do
    let(:chars) { 'āēīūģķļ' }

    it do
      dict.add('āēīū')
      dict.add('aeiu')
      dict.add('ģķļ')
      dict.add('gkl')

      aggregate_failures do
        expect(dict.check?('āēīū')).to be true
        expect(dict.check?('ģķļ')).to be true
        expect(dict.check?('āeīu')).to be false
        expect(dict.check?('gķl')).to be false

        expect(dict.valid_words_from_chars(chars)).to include('āēīū', 'āķē', 'āķī', 'ūķī')
        expect(dict.valid_words_from_chars(chars)).to_not include('aeiu')
        expect(dict.valid_words_from_chars(chars)).to include('ģķļ')
        expect(dict.valid_words_from_chars(chars)).to_not include('gkl')
      end
    end
  end

  describe '#find_possible_words_from_chars' do
    it 'take only first 7 into account' do
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
        aggregate_failures do
          expect('abc'.insert_ch(0, 'x')).to eq 'xabc'
          expect('abc'.insert_ch(1, 'x')).to eq 'axbc'
          expect('abc'.insert_ch(4, 'x')).to eq 'abc'
        end
      end
    end

    describe '#insert_ch!' do
      let!(:abc) { 'abc' }
      it do
        aggregate_failures do
          expect(abc.insert_ch!(4, 'x')).to be_nil
          expect(abc).to eq 'abc'
          expect(abc.insert_ch!(3, 'x')).to be true
          expect(abc).to eq 'abcx'
        end
      end
    end

    describe '#insert_chars_at' do
      let!(:chars) { { 1 => 'x', 3 => 'y' } }

      it do
        aggregate_failures do
          expect('abc'.insert_chars_at(0, chars)).to eq 'axbyc'
          expect('abc'.insert_chars_at(1, chars)).to eq 'abxcy'
          expect('abc'.insert_chars_at(2, chars)).to eq 'abcx'
          expect('abc'.insert_chars_at(3, chars)).to eq 'abc'
        end
      end
    end

    describe '#insert_chars_at!' do
      let!(:abc) { 'abc' }
      let!(:chars) { { 1 => 'x', 3 => 'y' } }

      it do
        aggregate_failures do
          expect(abc.insert_chars_at!(0, chars)).to be true
          expect(abc).to eq 'axbyc'
        end
      end

      it do
        aggregate_failures do
          expect(abc.insert_chars_at!(3, chars)).to be_nil
          expect(abc).to eq 'abc'
        end
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
    it 'find valid words with existing chars on board' do
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
