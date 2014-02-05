require 'omniauth-shibboleth'

module OmniAuth
  module Strategies
    class ShibbolethPassive < Shibboleth
      option :name, :shibboleth_passive

      # Override callback phase to not fail
      # where there isn't a Shibboleth session
      def callback_phase
        if shibboleth_session? || shibboleth_idp_called?
          unset_shibboleth_idp_called_param
          (shibboleth_session?) ? super : silent_fail
        else
          set_shibboleth_idp_called_param
          redirect(shibboleth_idp_url)
        end
      end

      def silent_fail
        OmniAuth.config.on_failure.call(env)
      end

      def shibboleth_idp_url
        "/Shibboleth.sso/Login?isPassive=true&target=#{URI.escape(callback_url)}"
      end

      def shibboleth_session?
        (request_param(options.shib_session_id_field.to_s) || 
          request_param(options.shib_application_id_field.to_s))
      end

      def shibboleth_idp_called?
        shibboleth_idp_called_param == true
      end

      def set_shibboleth_idp_called_param
        session[:shibboleth_idp_called] = true
      end

      def unset_shibboleth_idp_called_param
        session[:shibboleth_idp_called] = nil
      end

      def shibboleth_idp_called_param
        session[:shibboleth_idp_called]
      end
    end
  end
end
