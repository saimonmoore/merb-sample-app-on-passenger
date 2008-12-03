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
        
        def self.find_or_create_by_identity_url(identity_url)
          @u = first(:identity_url => identity_url)
          @u ||= self.class.new(:identity_url => identity_url)
          @u.save(:rpx)
        end
      end # DMClassMethods      
    end # RpxUser
  end # Mixins
end # Merb::Authentication
