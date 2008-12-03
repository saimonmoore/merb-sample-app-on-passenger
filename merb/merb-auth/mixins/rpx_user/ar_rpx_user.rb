class Merb::Authentication
  module Mixins
    module RpxUser
      module ARClassMethods
        
        def self.extended(base)
                  
        end # self.extended
        # No need to implement ::find_or_create_by_identity_url as it's dynamic in AR
        
      end # ARClassMethods
    end # RpxUser
  end # Mixins
end # Merb::Authentication 
