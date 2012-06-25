require "uni_sender/version"
require 'uni_sender/camelize'
require 'net/http'
require 'json'

module UniSender

  class Client

    attr_accessor :api_key, :client_ip, :locale

    def initialize(api_key, params={})
      self.api_key = api_key
      params.each do |key, value|
        if defined?("#{key}=")
          self.send("#{key}=", value)
        end
      end
    end

    def locale
      @locale || 'en'
    end

    private

    def translate_params(params)
      params.inject({}) do |iparams, couple|
        iparams[couple.first] = case couple.last
        when String
          URI.encode(couple.last)
        when Array
          couple.last.map{|item| URI.encode(item.to_s)}.join(',')
        when Hash
          couple.last.each do |key, value|
            if value.is_a? Hash
              value.each do |v_key, v_value|
                iparams["#{couple.first}[#{key}][#{v_key}]"] = URI.encode(v_value.to_s)
              end
            else
              iparams["#{couple.first}[#{key}]"] = URI.encode(value.to_s)
            end
          end
          nil
        else
          couple.last
        end
        iparams
      end
    end

    def method_missing(undefined_action, *args, &block)
      params = (args.first.is_a?(Hash) ? args.first : {} )
      default_request(undefined_action.to_s.camelize(false), params)
    end

    def default_request(action, params={})
      params = translate_params(params) if defined?('translate_params')
      params.merge!({'api_key' => api_key, 'format' => 'json'})
      query = make_query(params)
      url = URI("http://api.unisender.com/#{locale}/api/#{action}")
      JSON.parse(Net::HTTP.post_form(url, query).body)
    end

    def make_query(params)
      params.delete_if{|k,v| v.to_s.empty?}
    end

  end

end
