require File.join(File.expand_path(File.dirname(__FILE__)), ".." ,"rpx_client")

class Merb::Authentication
  module Mixins
    # This mixin provides authentication via rpxnow for a user.
    # 
    # Added properties:
    #  :indentity_url, String
    #
    # To use it simply require it and include it into your user class.
    #
    # class User
    #   include Merb::Authentication::Mixins::RpxUser
    #
    # end
    #
    module RpxUser
      
      def self.included(base)
        base.class_eval do
          
          include Merb::Authentication::Mixins::RpxUser::InstanceMethods
          extend  Merb::Authentication::Mixins::RpxUser::ClassMethods
          
          path = File.expand_path(File.dirname(__FILE__)) / "rpx_user"
          if defined?(DataMapper) && DataMapper::Resource > self
            require path / "dm_rpx_user"
            extend(Merb::Authentication::Mixins::RpxUser::DMClassMethods)
          elsif defined?(ActiveRecord) && ancestors.include?(ActiveRecord::Base)
            require path / "ar_rpx_user"
            extend(Merb::Authentication::Mixins::RpxUser::ARClassMethods)
          elsif defined?(Sequel) && ancestors.include?(Sequel::Model)
            require path / "sq_rpx_user"
            extend(Merb::Authentication::Mixins::RpxUser::SQClassMethods)
          elsif defined?(RelaxDB) && ancestors.include?(RelaxDB::Document)
            require path / "relaxdb_rpx_user"
            extend(Merb::Authentication::Mixins::RpxUser::RDBClassMethods)
          end
          
        end # base.class_eval
      end # self.included
      
      
      module ClassMethods

        # TODO: As is this assumes one openid per user
        # This means that existing users with multiple accounts (.e.g. a local account +  a google account)
        # will have multiple local accounts (one for each account they log in with).
        # We can map multiple accounts to the same user by sending a map request to rpx, which will return the primary key mapped to the openid account.
        # This means that a single user can have multiple openids.
        # This means that once successfully authenticated via rpx, we need to redirect them to a page
        # where we ask them if they already have an account on the site and wether they wish to map it to this openid.
        # If so, we don't create another user but ask them to authenticate via login/password or another existing openid, then map them and sign them in.
        # If not (i.e. new on the site), we create a new user, map it to their openid.
        def authenticate_via_rpx!(api_key, token, &block)
          unless (api_key && !api_key.empty?) && (token && !token.empty?)
            msg = "[RPX] Missing api_key and/or token!!!" 
            Merb.logger.error(msg) if Merb.logger
            raise RpxException.new(nil, {"err" => { "msg" => msg}, "stat" => "fail"}), msg
          end

          rpx_client = RpxClient.new(api_key)
          rpx_data = rpx_client.auth_info(token) if token && !token.empty?
          Merb.logger.info "[RPX] Successfully authenticated via rpx: #{rpx_data.inspect}" if Merb.logger
          # Successfully authenticated. Find or create the user and return it.
          user = self.find_or_create_by_identity_url(rpx_data['identifier'])
          unless user.first_name
            user.first_name = rpx_data['displayName'] || rpx_data['preferredUsername'] || nil
            # TODO: If we don't have at least the name, we should redirect them to the signup form so that they can fill in their name
            user.save(:rpx)
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
          
          block.call(user)
        rescue RpxException => rpxe
          block.call(rpxe.error_data ? rpxe.error_data : {"err" => { "msg" => rpxe.http_response}, "stat" => "fail"})
        end
        
      end    
      
      module InstanceMethods
        
      end # InstanceMethods
      
    end # RpxUser
  end # Mixins
end # Merb::Authentication
