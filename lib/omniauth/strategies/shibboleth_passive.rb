require 'omniauth-shibboleth'

module OmniAuth
  module Strategies
    class ShibbolethPassive < Shibboleth
      # Set defaults for options
      option :idp_callback_frequency, :every_request

      def valid_config?
        case idp_callback_frequency
        when :every_request, :first_request, Proc
          true
        else
          false
        end
      end

      def idp_callback?
        raise ArgumentError.new("Invalid configuration") unless valid_config?
        case idp_callback_frequency
        when :every_request, :first_request
          idp_called_back != true
        when Proc
          expiration = idp_callback_frequency.call
          (!idp_called_back_time.is_a?(Time) || idp_called_back_time < expiration)
        end
      end

      def set_idp_called_back
        session[:omniauth][:shibboleth][:idp_called_back] = true
      end

      def unset_idp_called_back
        session[:omniauth][:shibboleth][:idp_called_back] = nil
      end

      def set_idp_called_back_time
        session[:omniauth][:shibboleth][:idp_called_back_time] = Time.now
      end

      def idp_called_back
        session[:omniauth][:shibboleth][:idp_called_back]
      end

      def idp_called_back_time
        session[:omniauth][:shibboleth][:idp_called_back_time]
      end

      def idp_callback_frequency
        @idp_callback_frequency ||= options.idp_callback_frequency
      end
    end
  end
end
