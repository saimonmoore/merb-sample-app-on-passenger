require 'merb-auth-more/strategies/basic/password_form'
# This strategy uses either a login and password parameter to authenticate the user 
# or it authenticates via rpxnow.
#
# Overwrite the :password_param, and :login_param
# to return the name of the field (on the form) that you're using the 
# login with.  These can be strings or symbols
#
# == Required
#
# === Methods
# <User>.authenticate(login_param, password_param)
#
class Merb::Authentication
  module Strategies
    module Basic
      class FormWithRpx < Form
        
        def self.rpx_token_param
          (Merb::Plugins.config[:"merb-auth"][:rpx_token_param] || :token).to_s.to_sym
        end

        def run!
          rpx_token = request.params[rpx_token_param]
          if rpx_token
            self.handle_rpx_call(rpx_token)
          elsif request.params[login_param] && request.params[password_param]
            user = user_class.authenticate(request.params[login_param], request.params[password_param])
            if !user
              request.session.authentication.errors.clear!
              request.session.authentication.errors.add(login_param, password_form_error_message)
            end
            user
          end
        end # run!
        
        def password_form_error_message
          "#{login_param.to_s.capitalize} or #{password_param.to_s.capitalize} were incorrect"
        end
        
        def rpx_error_message
          "Your provider was unable to authenticate you. You can try again or sign in with the login form."
        end
        
        def rpx_token_param
          @rpx_token_param ||= Base.rpx_token_param
        end
        
        private
        
          def handle_rpx_call(token)
            rpx_data = RPXClient.new(Merb::Config[:rpx_api_key], token) if token && !token.empty?
            rpx_data ||= {}
            status = rpx_data['stat']
            if status && status == 'ok'
              # Successfully authenticated. Find or create the user and return it.
              user = user_class.find_or_create_by_identity_url(rpx_data['profile']['identifier'])
              unless user.first_name
                user.first_name = rpx_data['profile']['displayName'] || rpx_data['profile']['preferredUsername']
                user.save
              end
            else
              request.session.authentication.errors.clear!
              request.session.authentication.errors.add(:general, rpx_error_message)
              if logger
                logger.error "[RPXNow] Unable to authenticate with supplied token: Remote answered: #{rpx_data['err']} (#{rpx_data.inspect})"
              end
            end
            
            # {
            #   "profile": {
            #     "preferredUsername": "brian",
            #     "displayName": "brian",
            #     "url": "http:\/\/brian.myopenid.com\/",
            #     "identifier": "http:\/\/brian.myopenid.com\/"
            #   },
            #   "stat": "ok"
            # }            
          end
        
      end # FormWithRpx
    end # Basic
  end # Strategies
end # Authentication