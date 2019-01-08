# encoding: utf-8
require 'base64'
require 'net/http'
require 'uri'
require 'json'

require 'fluent/plugin/filter'

module Fluent::Plugin
  class VaultDecodeFilter < Fluent::Plugin::Filter
    Fluent::Plugin.register_filter('vault_decode', self)

    config_param :keywords, :array, value_type: :string
    config_param :vaultaddr, :string
    config_param :vaulttoken, :string
    config_param :vaultcert, :string, :default => "/fluentd/etc/certs/cert.crt"
    config_param :vaultauditpath, :string, :default => "socket"

    def configure(conf)
	    super
	    @value_hashes = Hash.new

	    # Lets get the hashes
	    vaulturi = URI.parse( @vaultaddr )
    	    endpoint = "/v1/sys/audit-hash/#{@vaultauditpath}"
	    http = Net::HTTP.new(vaulturi.host, vaulturi.port)
	    req = Net::HTTP::Post.new(URI.join(@vaultaddr,endpoint), "X-Vault-Token" => @vaulttoken)
	    # Handle SSL
	    if @vaultaddr.include? "https"
		    http.use_ssl = true
		    http.ca_file = @vaultcert
		    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
		    OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:ssl_version] = :TLSv1_2
	    end

	    #iterate through the keywords and get the hash for each
	    @keywords.each { |plaintext_str|
		    req.body = "{ \"input\": \"#{plaintext_str}\" }"
		    res = http.request(req)
		    if res.code.to_i != 200
			    log.error "Error from Vault Server: #{res.body}"
		    else
			    json_response = JSON.parse(res.body)
			    hashed_msg = json_response["hash"]
			    @value_hashes[plaintext_str] = hashed_msg
		    end
	    }

    end

    def transform(record_in)
	record_in.each_pair do |k,v|
    		if v.is_a?(Hash)
      			transform(v)
    		else
			@value_hashes.each_pair do |word,hash|
				record_in[k] = word if hash == v
			end
    		end
  	end
    end


   def filter(tag,time,record)
	   transform(record)
   end
    
  end
end
