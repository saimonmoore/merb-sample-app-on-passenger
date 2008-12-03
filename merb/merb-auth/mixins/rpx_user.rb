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

        def authenticate_via_rpx!(api_key, token, &block)
          unless (api_key && !api_key.empty?) && (token && !token.empty?)
            msg = "[RPX] Missing api_key and/or token!!!" 
            logger.error(msg) if logger
            raise RpxException.new(nil, {"err" => { "msg" => msg}, "stat" => "fail"}), msg
          end

          rpx_client = RpxClient.new(api_key)
          rpx_data = rpx_client.auth_info(token) if token && !token.empty?
          logger.info "[RPX] Successfully authenticated via rpx: #{rpx_data.inspect}"
          # Successfully authenticated. Find or create the user and return it.
          user = self.find_or_create_by_identity_url(rpx_data['identifier'])
          unless user.first_name
            user.first_name = rpx_data['displayName'] || rpx_data['preferredUsername'] || nil
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
