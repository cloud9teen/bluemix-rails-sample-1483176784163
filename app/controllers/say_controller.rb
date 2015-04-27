require 'json'

# Controller and action definition for uri say/hello
# See routing configuration in config/routes.rb
class SayController < ApplicationController
  def hello    
    # get Ruby version and Rails version
    @ruby_version = RUBY_VERSION
    @rails_version = Rails::VERSION::STRING
    @vcap_services = ENV['VCAP_SERVICES']
    
    RestClient.proxy = nil
    json = JSON.parse(RestClient.get("http://ip.jsontest.com"))
    @non_static_result = json["ip"]
    #@non_static_result = "2.2.2.2"
    credentials = proxyURL = ''
    if !ENV['VCAP_SERVICES'].blank?
      JSON.parse(ENV['VCAP_SERVICES']).each do |k,v|
        if !k.scan("statica").blank?
          credentials = v.first.select {|k1,v1| k1 == "credentials"}["credentials"]
          proxyURL = credentials["STATICA_URL"]
        end
      end
    end
    if proxyURL.blank?
        proxyURL = ENV["STATICA_URL"]
    end
    RestClient.proxy = proxyURL
    static_json = JSON.parse(RestClient.get("http://ip.jsontest.com"))
    @static_result = static_json["ip"]  
    #@static_result = "1.1.1.1"    
  end

end