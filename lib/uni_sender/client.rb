require 'net/http'
require 'json'

module UniSender
  class Client
  private
    attr_reader :api_key, :locale

    def initialize(api_key, opts = {})
      @api_key = api_key
      @locale = opts.fetch(:locale, :en)
    end

    def translate_params(params)
      params.inject({}) do |iparams, (k, v)|
        if k == :field_names
          v.each_with_index do |name, index|
            iparams["field_names[#{index}]"] = name
          end
        elsif k == :data
          v.each_with_index do |row, index|
            row.each_with_index do |data, data_index|
              iparams["data[#{index}][#{data_index}]"] = data
            end if row
          end
        else
          case v
          when String
            iparams[k.to_s] = v
          when Array
            iparams[k.to_s] = v.map(&:to_s).join(',')
          when Hash
            v.each do |key, value|
              if value.is_a? Hash
                value.each do |v_key, v_value|
                  iparams["#{k}[#{key}][#{v_key}]"] = v_value.to_s
                end
              else
                iparams["#{k}[#{key}]"] = value.to_s
              end
            end
          else
            iparams[k.to_s] = v.to_s
          end
        end
        iparams
      end
    end

    def method_missing(method_name, *args, &block)
      _params = args.first.is_a?(Hash) ? args.first : {}
      api_method = camelize_lower(method_name.to_s)
      res = default_request(api_method, _params)
      # Define method after it was called the first time.
      eigenclass = class << self; self; end
      eigenclass.__send__(:define_method, method_name) do |params = {}|
        default_request(api_method, params)
      end
      res
    end

    def default_request(action, params)
      params = translate_params(params).delete_if { |_, v| v.empty? }
      params.merge!({ 'api_key' => api_key, 'format' => 'json' })
      response = Net::HTTP.post_form(URI("https://api.unisender.com/#{locale}/api/#{action}"), params)
      raise NoMethodError.new("Unknown API method #{action}") if response.code == '404'
      JSON.parse(response.body)
    end

    def camelize_lower(string)
      string.gsub(/_\w/) { |s| s[1].upcase }
    end
  end
end
