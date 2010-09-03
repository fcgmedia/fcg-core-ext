module FCG
  module CoreExt
    module Utils
      def time_string(date)
        date.strftime("%I:%M%p").sub(/^0/,'')
      end

      def date_string(date)
        f = "%b %d"
        unless date.year == Time.now.year
          f << " %y"
        end
        date.strftime f
      end
  
      def success_response(*args) # objekt is an object
        ajax_response *args
      end
  
      def failure_response(objekt)
        if objekt.respond_to?(:errors)
          ajax_response({:errors => objekt.errors})
        else
          ajax_response objekt
        end
      end
  
      def ajax_response(objekt)
        objekt.merge!(:server_time => Time.now.utc.to_s(:rfc822))
        render :json => objekt
      end
  
      def log(msg)
        Rails.logger.debug  "### #{msg}"
      end
  
      def parse_time(date_time)
        d = Time.parse date_time.to_s
        DateTime.new(d.year, d.mon, d.day, d.hour, d.min)
      end

    	def generate_challenge( len=32, extra=[] )
    		len = 32 if len > 32
        chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a + extra # + ['#','.','%','@','*','_']
        str = ""
        1.upto(len) { |i| str << chars[rand(chars.size-1)] }
        str
    	end
	
      def ping_a_url(url)
        `curl -s0 #{url}`
      end
  
    	def clear_cookies(c)
    	  cookies[c] = { :value => nil, :domain => ".#{request.domain}", :path => '/', :expires => Time.at(-1000) }
    	end
	
    	def clear_all_cookies
    	  cookies.each do |key, value|
    	    clear_cookies(key)
    	  end
    	end
	
    	def retryable(options = {}, &block)
        sleep_time = 1.0 # second
        opts = { :tries => 1, :on => Exception, :delay => false }.merge(options)
        retry_exception, retries = opts[:on], opts[:tries]
        begin
          return yield
        rescue retry_exception
          sleep sleep_time *= 1.25 if opts[:delay]
          retry if (retries -= 1) > 0
        end
        yield
      end
  
    	#creates javascript_include and stylesheet_include
      def asset_include(assets=["js", "css"])
        assets.each do |el|
          case el
            when "js"
              tag = "javascript_include_tag"
            when "css"
              tag = "stylesheet_link_tag"
            else
              raise "Bad Asset Type. Must be CSS or JS."
          end
          eval <<-EOL
          def #{el}_include(files)
            return if files.nil?
            buffer = []
            files.each do |f|
              buffer << #{tag}(f)
            end
            buffer.join("\n")
          end
          EOL
        end
      end
    end
  end
end