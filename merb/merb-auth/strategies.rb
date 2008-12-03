# This file is specifically for you to define your strategies 
#
# You should declare you strategies directly and/or use 
# Merb::Authentication.activate!(:label_of_strategy)
#
# To load and set the order of strategy processing

Merb::Slices::config[:"merb-auth-slice-password"][:no_default_strategies] = true
Merb::Slices::config[:merb_auth_slice_password][:layout] = :application

# Register the strategies so that plugins and apps may utilize them
basic_path = File.expand_path(File.dirname(__FILE__))

Merb::Authentication.register(:rpx_password_form, basic_path / "password_form_rpx.rb")
Merb::Authentication.activate!(:rpx_password_form)
Merb::Authentication.activate!(:default_basic_auth)