class Merb::Authentication
  module Mixins
    module RpxUser
      module DMClassMethods
        def self.extended(base)
          base.class_eval do
            
            property :identity_url,           String
            
            validates_present :identity_url, :when => [:rpx]
            
          end # base.class_eval
          
        end # self.extended
        
        def find_or_create_by_identity_url(identity_url)
          user = first(:identity_url => identity_url)
          user ||= self.new(:identity_url => identity_url)
          user.save(:rpx)
          user
        end
      end # DMClassMethods      
    end # RpxUser
  end # Mixins
end # Merb::Authentication
