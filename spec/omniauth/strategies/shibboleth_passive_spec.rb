require 'spec_helper'
describe "OmniAuth::Strategies::ShibbolethPassive" do
  let(:config) { {} }
  let(:every_request_config) { { idp_callback_frequency: :every_request } }
  let(:first_request_config) { { idp_callback_frequency: :first_request } }
  let(:every_5_minutes_config) { { idp_callback_frequency: -> { 5.minutes.ago } } }
  subject(:strategy) { OmniAuth::Strategies::ShibbolethPassive.new(nil, config) }

  describe '#options' do
    subject(:options) { strategy.options }
    context 'when configured with defaults' do
      it { should_not be_nil }
      it { should_not be_empty }
      describe '#idp_callback_frequency' do
        subject(:idp_callback_frequency) { options.idp_callback_frequency }
        it { should_not be_nil }
        it { should_not be_empty }
        it { should eq(:every_request) }
      end
    end

    context 'when configured to check the IdP on every request' do
      let(:config) { every_request_config }
      it { should_not be_nil }
      it { should_not be_empty }
      describe '#idp_callback_frequency' do
        subject(:idp_callback_frequency) { options.idp_callback_frequency }
        it { should_not be_nil }
        it { should_not be_empty }
        it { should eq(:every_request) }
      end
    end

    context 'when configured to check the IdP on the first request' do
      let(:config) { first_request_config }
      it { should_not be_nil }
      it { should_not be_empty }
      describe '#idp_callback_frequency' do
        subject(:idp_callback_frequency) { options.idp_callback_frequency }
        it { should_not be_nil }
        it { should_not be_empty }
        it { should eq(:first_request) }
      end
    end

    context 'when configured to check the IdP every 5 minutes' do
      let(:config) { every_5_minutes_config }
      it { should_not be_nil }
      it { should_not be_empty }
      describe '#idp_callback_frequency' do
        subject { options.idp_callback_frequency }
        it { should_not be_nil }
        it { should respond_to(:call) }
        it { should_not raise_error }
        it("should less than Time.now") do
          expect(subject.call).to be < Time.now
        end
      end
    end
  end

  describe '#callback?' do
    subject { strategy.callback? }
    context 'when configured to check the IdP on every request' do
      let(:config) { every_request_config }
      it { should_not be_true }
    end
    context 'when configured to check the IdP on the first request' do
      let(:config) { first_request_config }
      it { should_not be_true }
    end
    context 'when configured to check the IdP every 5 minutes' do
      let(:config) { every_5_minutes_config }
      it { should_not be_true }
    end
  end
end
