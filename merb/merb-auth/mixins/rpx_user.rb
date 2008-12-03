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
        
        def authenticate_via_rpx!(token, &block)
          rpx_data = RpxClient.new(Merb::Config[:rpx_api_key], token) if token && !token.empty?
          rpx_data ||= {}
          status = rpx_data['stat']
          if status && status == 'ok'
            # Successfully authenticated. Find or create the user and return it.
            user = self.find_or_create_by_identity_url(rpx_data['profile']['identifier'])
            unless user.first_name
              user.first_name = rpx_data['profile']['displayName'] || rpx_data['profile']['preferredUsername']
              user.save
            end
            block.call(user)
          else
            block.call(rpx_data)
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
        
      end    
      
      module InstanceMethods
        
      end # InstanceMethods
      
    end # RpxUser
  end # Mixins
end # Merb::Authentication
