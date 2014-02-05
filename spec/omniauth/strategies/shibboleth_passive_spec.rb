require 'spec_helper'
describe "OmniAuth::Strategies::ShibbolethPassive" do
  let(:config) { {} }
  let(:every_request_config) { { passive_idp_callback_frequency: :every_request } }
  let(:first_request_config) { { passive_idp_callback_frequency: :first_request } }
  let(:every_5_minutes_config) { { passive_idp_callback_frequency: -> { 5.minutes.ago } } }
  let(:invalid_config) { { passive_idp_callback_frequency: :invalid_config } }
  let(:shibboleth_idp_called) { nil }
  let(:shib_session_id_field) { strategy.options.shib_session_id_field.to_s }
  let(:shib_application_id_field) { strategy.options.shib_application_id_field.to_s }
  let(:shib_session_id) { nil }
  let(:shib_application_id) { nil }
  before do
    strategy.env[shib_session_id_field] = shib_session_id
    strategy.env[shib_application_id_field] = shib_application_id
  end
  subject(:strategy) do
    OmniAuth::Strategies::ShibbolethPassive.new(->(env) {}, config).tap do |s|
      s.instance_variable_set(:@env, { 'rack.session' => { shibboleth_idp_called: shibboleth_idp_called } })
      allow(s).to receive(:fail!).and_return(true)
    end
  end
  describe '#shibboleth_idp_called_param' do
    subject { strategy.shibboleth_idp_called_param }
    context "when Shibboleth hasn't been called" do
      it { should be_nil }
    end
    context "when Shibboleth hasn been called" do
      let(:shibboleth_idp_called) { true }
      it { should_not be_nil }
      it { should be_true }
    end
  end
  describe '#set_shibboleth_idp_called_param' do
    it "should set the IdP called back session variable to true" do
      strategy.set_shibboleth_idp_called_param
      expect(strategy.shibboleth_idp_called_param).not_to be_nil
      expect(strategy.shibboleth_idp_called_param).to be_true
    end
  end
  describe '#unset_shibboleth_idp_called_param' do
    let(:shibboleth_idp_called) { true }
    it "should set the IdP called back session variable to nil" do
      strategy.unset_shibboleth_idp_called_param
      expect(strategy.shibboleth_idp_called_param).to be_nil
    end
  end
  describe '#shibboleth_session?' do
    subject { strategy.shibboleth_session? }
    context 'when there isn\'t a Shibboleth session' do
      it { should be_false }
    end
    context 'when there is a Shibboleth session id' do
      let(:shib_session_id) { "1234567890" }
      it { should be_true }
    end
    context 'when there is a Shibboleth application id' do
      let(:shib_application_id) { "1234567890" }
      it { should be_true }
    end
    context 'when there is a Shibboleth session id and a Shibboleth application id' do
      let(:shib_session_id) { "1234567890" }
      let(:shib_application_id) { "1234567890" }
      it { should be_true }
    end
  end
  describe '#shibboleth_idp_url' do
    subject { strategy.shibboleth_idp_url }
    it { should eq("/Shibboleth.sso/Login?isPassive=true&target=/auth/shibbolethpassive/callback") }
  end
  describe '#shibboleth_idp_called?' do
    subject { strategy.shibboleth_idp_called? }
    context 'when the IdP hasn\'t been called back to yet' do
      before { allow(strategy).to receive(:shibboleth_idp_called_param).and_return(nil) }
      it { should be_false}
    end
    context 'when the IdP has already been called back to' do
      before { allow(strategy).to receive(:shibboleth_idp_called_param).and_return(true) }
      it { should be_true }
    end
  end
  describe '#callback_phase' do
    let(:shibbleth_session) { false }
    let(:shibboleth_idp_called) { false }
    before { allow(strategy).to receive(:shibboleth_session?).and_return(shibbleth_session) }
    before { allow(strategy).to receive(:shibboleth_idp_called?).and_return(shibboleth_idp_called) }
    before { allow(strategy).to receive(:set_shibboleth_idp_called_param).and_return(true) }
    before { allow(strategy).to receive(:unset_shibboleth_idp_called_param).and_return(true) }
    before { allow(strategy).to receive(:silent_fail).and_return(true) }
    before { strategy.callback_phase }
    context 'when there is a shibboleth session' do
      let(:shib_session_id) { "1234567890" }
      let(:shibbleth_session) { true }
      it { should_not have_received(:fail!) }
      it { should_not have_received(:set_shibboleth_idp_called_param) }
      it { should have_received(:unset_shibboleth_idp_called_param) }
      it { should_not have_received(:silent_fail) }
    end
    context 'when there isn\'t a shibboleth session' do
      context 'when the IdP hasn\'t been called back to yet' do
        it { should_not have_received(:fail!) }
        it { should have_received(:set_shibboleth_idp_called_param) }
        it { should_not have_received(:unset_shibboleth_idp_called_param) }
        it { should_not have_received(:silent_fail) }
      end
      context 'when the IdP has already been called back' do
        let(:shibboleth_idp_called) { true }
        it { should_not have_received(:fail!) }
        it { should_not have_received(:set_shibboleth_idp_called_param) }
        it { should have_received(:unset_shibboleth_idp_called_param) }
        it { should have_received(:silent_fail) }
      end
    end
  end
  describe '#silent_fail' do
    it "should not raise an error" do
      expect { strategy.silent_fail }.not_to raise_error
  end
    
  end
end