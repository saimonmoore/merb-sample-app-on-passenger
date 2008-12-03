require 'merb-auth-more/strategies/basic/password_form'
# This strategy uses either a login and password parameter to authenticate the user 
# or it authenticates via rpxnow.
#
#
# == Required
#
# === Methods
# <User>.authenticate_via_rpx!(rpx_token_param)
#
class Merb::Authentication
  module Strategies
    module Basic
      class FormWithRpx < Form
        
        def self.rpx_token_param
          # (Merb::Plugins.config[:"merb-auth"][:rpx_token_param] || :token).to_s.to_sym
          (Merb::Config[:rpx_token_param] || :token).to_s.to_sym
        end

        def run!
          rpx_token = request.params[rpx_token_param]
          user = nil
          if rpx_token
            user = handle_rpx_call(rpx_token)
            user
          elsif request.params[login_param] && request.params[password_param]
            user = user_class.authenticate(request.params[login_param], request.params[password_param])
            if !user
              request.session.authentication.errors.clear!
              request.session.authentication.errors.add(login_param, password_form_error_message)
            end
            user
          end
        end # run!
        
        def rpx_error_message
          "Your provider was unable to authenticate you. You can try again or sign in with the login form."
        end
        
        def rpx_token_param
          @rpx_token_param ||= self.class.rpx_token_param
        end
        
        private
        
          def handle_rpx_call(rpx_token)
            user = nil
            user_class.authenticate_via_rpx!(Merb::Config[:rpx_api_key], rpx_token) do |user_or_data|
              case user_or_data
                when user_class
                  user = user_or_data
                else
                  rpx_data = user_or_data
                  request.session.authentication.errors.clear!
                  request.session.authentication.errors.add(:general, rpx_error_message)
                  if logger
                    logger.error "[RPXNow] Unable to authenticate with supplied token: Reason: #{rpx_data['err']} (#{rpx_data.inspect})"
                  end
              end
            end
            user     
          end
        
      end # FormWithRpx
    end # Basic
  end # Strategies
end # Authentication