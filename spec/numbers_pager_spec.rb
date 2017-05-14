require 'rails_helper'

RSpec.describe NumbersPager do
  describe '#call' do 
    let(:any_replace_array) { [1, 2, 3, 4, 5] }
    describe 'when page is missing' do
      let(:params) { { per_page: "5" } }
      let(:generator) { double('fizzbuzz_generator') }
      subject { NumbersPager.new({ params: params  , generator: generator }) }
      it 'defaults page to 1' do
        generator.should_receive(:numbers).with(1, 5).and_return(any_replace_array)
        subject.call
      end
    end
    describe 'when page is nil' do
      let(:params) { { page: nil, per_page: "5" } }
      let(:generator) { double('fizzbuzz_generator') }
      subject { NumbersPager.new({ params: params  , generator: generator }) }
      it 'defaults page to 1' do
        generator.should_receive(:numbers).with(1, 5).and_return(any_replace_array)
        subject.call
      end
    end
    describe 'when page is 0' do
      let(:params) { { page: "0", per_page: "5" } }
      let(:generator) { double('fizzbuzz_generator') }
      subject { NumbersPager.new({ params: params  , generator: generator }) }
      it 'defaults page to 1' do
        generator.should_receive(:numbers).with(1, 5).and_return(any_replace_array)
        subject.call
      end
    end
    describe 'when per_page is missing' do
      let(:params) { { page: "1" } }
      let(:generator) { double('fizzbuzz_generator') }
      subject { NumbersPager.new({ params: params  , generator: generator }) }
      it 'defaults per_page to 100' do
        generator.should_receive(:numbers).with(1, 100).and_return(any_replace_array)
        subject.call
      end
    end
    describe 'when per_page is nil' do
      let(:params) { { page: "1", per_page: nil } }
      let(:generator) { double('fizzbuzz_generator') }
      subject { NumbersPager.new({ params: params  , generator: generator }) }
      it 'defaults per_page to 100' do
        generator.should_receive(:numbers).with(1, 100).and_return(any_replace_array)
        subject.call
      end
    end
    describe 'when per_page is 0' do
      let(:params) { { page: "1", per_page: "0" } }
      let(:generator) { double('fizzbuzz_generator') }
      subject { NumbersPager.new({ params: params  , generator: generator }) }
      it 'defaults per_page to 100' do
        generator.should_receive(:numbers).with(1, 100).and_return(any_replace_array)
        subject.call
      end
    end
    describe 'when per_page is 21' do
      context 'and page requested is greater than available' do
        let(:params) { { page: "50000000000000", per_page: "21" } }
        let(:generator) { double('fizzbuzz_generator') }
        subject { NumbersPager.new({ params: params  , generator: generator }) }
        it 'page is set to 47_619_047_620' do
          generator.should_receive(:numbers).with(47_619_047_620, 21).and_return([1, 2, 3, 4, 5])
          subject.call
        end
      end
    end
  end
end
