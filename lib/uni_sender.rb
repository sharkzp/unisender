require "uni_sender/version"
require 'uni_sender/support'
require 'net/http'
require 'json'

module UniSender

  class Client
    using UniSender::Support

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
      if params[:field_names]
        params[:field_names].each_with_index do |name, index|
          params["field_names[#{index}]"] = name
        end
        params.delete(:field_names)
      end
      if params[:data]
        params[:data].each_with_index do |row, index|
          row.each_with_index do |data, data_index|
            params["data[#{index}][#{data_index}]"] = data
          end if row
        end
        params.delete(:data)
      end
      params.inject({}) do |iparams, couple|
        iparams[couple.first.to_s] = case couple.last
        when String
          couple.last
        when Array
          couple.last.map{|item| item.to_s}.join(',')
        when Hash
          couple.last.each do |key, value|
            if value.is_a? Hash
              value.each do |v_key, v_value|
                iparams["#{couple.first}[#{key}][#{v_key}]"] = v_value.to_s
              end
            else
              iparams["#{couple.first}[#{key}]"] = value.to_s
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
