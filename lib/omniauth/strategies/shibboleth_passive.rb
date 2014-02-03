require 'omniauth-shibboleth'

module OmniAuth
  module Strategies
    class ShibbolethPassive < Shibboleth
      # Set defaults for options
      option :idp_callback_frequency, :every_request

      def callback?
        raise "Implement #callback? !"
      end
    end
  end
end
