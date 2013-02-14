module TwitterOauth
	

	# initialize the oauth consumer, and also access token if user_token and user_secret provided
	# this will get the request token url and return it.
    def self.request_url
		@consumer = OAuth::Consumer.new("fYuL73SIEuhw6kgNvs2hA", "49ujIlgckdjJGbuKV8IafH9rKuvO6PlSCuxEVspd4", {:site=> "http://twitter.com"} )
		return @request_token= @consumer.get_request_token(:oauth_callback => "http://127.0.0.1:3000/data_provider_users/twitter_oauth")

    end	

    def self.get_access_token
    	debugger
    end
	
end