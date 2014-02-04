require 'spec_helper'
describe "OmniAuth::Strategies::ShibbolethPassive" do
  let(:config) { {} }
  let(:every_request_config) { { idp_callback_frequency: :every_request } }
  let(:first_request_config) { { idp_callback_frequency: :first_request } }
  let(:every_5_minutes_config) { { idp_callback_frequency: -> { 5.minutes.ago } } }
  let(:invalid_config) { { idp_callback_frequency: :invalid_config } }
  let(:idp_session) { { } }
  subject(:strategy) do
    OmniAuth::Strategies::ShibbolethPassive.new(->(env) {}, config).tap do |s|
      s.instance_variable_set(:@env, 
        { 'rack.session' => { omniauth: { shibboleth: idp_session } } })
    end
  end

  context 'when configured with defaults' do
    describe '#valid_config?' do
      subject { strategy.valid_config? }
      it { should be_true }
    end
    describe '#options' do
      subject(:options) { strategy.options }
      it { should_not be_nil }
      it { should_not be_empty }
    end
    describe '#idp_callback_frequency' do
      subject { strategy.idp_callback_frequency }
      it { should_not be_nil }
      it { should_not be_empty }
      it { should eq(:every_request) }
    end
    describe '#set_idp_called_back' do
      let(:idp_session) { { idp_called_back: nil } }
      it "should set the IdP called back session variable to true" do
        strategy.set_idp_called_back
        expect(strategy.idp_called_back).to be_true
      end
    end
    describe '#unset_idp_called_back' do
      let(:idp_session) { { idp_called_back: true } }
      it "should set the IdP called back session variable to nil" do
        strategy.unset_idp_called_back
        expect(strategy.idp_called_back).to be_nil
      end
    end
    describe '#set_idp_called_back_time' do
      let(:idp_session) { { idp_called_back_time: nil } }
      it "should set the IdP called back time to now" do
        strategy.set_idp_called_back_time
        expect(strategy.idp_called_back_time).to be_a(Time)
        expect(strategy.idp_called_back_time).to be_within(0.1.second).of(Time.now)
      end
    end
  end

  context 'when configured to check the IdP on every request' do
    let(:config) { every_request_config }
    describe '#valid_config?' do
      subject { strategy.valid_config? }
      it { should be_true }
    end
    describe '#options' do
      subject(:options) { strategy.options }
      it { should_not be_nil }
      it { should_not be_empty }
    end
    describe '#idp_callback_frequency' do
      subject { strategy.idp_callback_frequency }
      it { should_not be_nil }
      it { should_not be_empty }
      it { should eq(:every_request) }
    end
    describe '#idp_callback?' do
      subject { strategy.idp_callback? }
      context 'when the IdP hasn\'t been called back to yet' do
        let(:idp_session) { { idp_called_back: nil } }
        it { should be_true }
      end
      context 'when the IdP has already been called back to' do
        let(:idp_session) { { idp_called_back: true } }
        it { should be_false }
      end
    end
  end

  context 'when configured to check the IdP on the first request' do
    let(:config) { first_request_config }
    describe '#valid_config?' do
      subject { strategy.valid_config? }
      it { should be_true }
    end
    describe '#options' do
      subject(:options) { strategy.options }
      it { should_not be_nil }
      it { should_not be_empty }
    end
    describe '#idp_callback_frequency' do
      subject { strategy.idp_callback_frequency }
      it { should_not be_nil }
      it { should_not be_empty }
      it { should eq(:first_request) }
    end
    describe '#idp_callback?' do
      subject { strategy.idp_callback? }
      context 'when the IdP hasn\'t been called back to yet' do
        let(:idp_session) { { idp_called_back: nil } }
        it { should be_true }
      end
      context 'when the IdP has already been called back to' do
        let(:idp_session) { { idp_called_back: true } }
        it { should be_false }
      end
    end
  end

  context 'when configured to check the IdP every 5 minutes' do
    let(:config) { every_5_minutes_config }
    describe '#valid_config?' do
      subject { strategy.valid_config? }
      it { should be_true }
    end
    describe '#options' do
      subject(:options) { strategy.options }
      it { should_not be_nil }
      it { should_not be_empty }
    end
    describe '#idp_callback_frequency' do
      subject { strategy.idp_callback_frequency }
      it { should_not be_nil }
      it { should respond_to(:call) }
      it { should_not raise_error }
      it("should be greater than 6 minutes ago") do
        expect(subject.call).to be > 6.minutes.ago
      end
    end
    describe '#idp_callback?' do
      subject { strategy.idp_callback? }
      context 'when the IdP hasn\'t been called back to yet' do
        let(:idp_session) { { idp_called_back_time: nil } }
        it { should be_true }
      end
      context 'when the IdP has been called back to less than 5 minutes ago' do
        let(:idp_session) { { idp_called_back_time: Time.now } }
        it { should be_false }
      end
      context 'when the IdP has been called back to more than 5 minutes ago' do
        let(:idp_session) { { idp_called_back_time: 6.minutes.ago } }
        it { should be_true }
      end
    end
  end

  context 'when configuration is invalid' do
    let(:config) { invalid_config }
    describe '#valid_config?' do
      subject { strategy.valid_config? }
      it { should be_false }
    end
    describe '#idp_callback?' do
      it("should raise an ArgumentError") { expect{ strategy.idp_callback? }.to raise_error(ArgumentError) }
    end
  end
end
