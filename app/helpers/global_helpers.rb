module Merb
  module GlobalHelpers
    # helpers defined here available to all views.  
    
    def site_domain(escape = :dont_escape)
      # TODO: Should encode url to redirect back to in token_url
      domain = request.protocol + "://" + request.host + '/posts/new'
      case escape
      when :cgi_escape
        CGI.escape(domain)
      when :js_escape
        domain.gsub(/\//,'\\/')
      else
        domain  
      end
    end    
  end
end
