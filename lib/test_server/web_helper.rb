# encoding: utf-8
module TestServer
  module WebHelper
    def base_url
      mutex = Mutex.new

      mutex.synchronize do
        @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"
      end
    end

    def h(text)
      Rack::Utils.escape_html(text)
    end

    def t(*args)
      I18n.t(*args)
    end

    def generate_string(count, string = "Plain Data\n")
      string * count
    end
  
    def generate_random_string(count)
      o = [('a'..'z'), ('A'..'Z'), (1..9), %w{° ^ ! " § $ % & / ( ) = ? * + ~ ` ´ ' # > < | @ ł € ¶ ŧ ← ↓ → ŋ đ ð ſ ð đ ŋ ħ “ „ ¢ « | » « ¢ „ “ ” µ · … – ĸ ¹ ² ³ ¼ ½ ¬ \{ [ ] \}}].map { |i| i.to_a }.flatten

      (0...count).map { o[rand(o.length)] }.join
    end

    def generate_eicar
      [ 'X', '5', 'O', '!', 'P', '%', '@', 'A', 'P', '[', '4', "\\", 'P',
        'Z', 'X', '5', '4', '(', 'P', '^', ')', '7', 'C', 'C', ')', '7',
        '}', '$', 'E', 'I', 'C', 'A', 'R', '-', 'S', 'T', 'A', 'N', 'D',
        'A', 'R', 'D', '-', 'A', 'N', 'T', 'I', 'V', 'I', 'R', 'U', 'S',
        '-', 'T', 'E', 'S', 'T', '-', 'F', 'I', 'L', 'E', '!', '$', 'H',
        '+', 'H', '*' ]
    end

    def configure_caching(params)
      options = []

      if params.key? 'expires'
        options << :must_revalidate
        options << :no_cache
        options << { max_age: params[:expires] }
      else
        options << :must_revalidate              if params.key? 'must_revalidate'
        options << :no_cache                     if params.key? 'no_cache'
        options << { max_age: params[:max_age] } if params.key? 'max_age'
      end

      cache_control(*options)
    end

    def encode(&block)
      encoders = []
      encoders << Encoders::Base64.new
      encoders << Encoders::Base64Strict.new
      encoders << Encoders::Gzip.new

      encoders_to_run = params.keys.map(&:to_sym) & encoders.collect { |e| e.name }

      if encoders_to_run.blank?
        real_encoders = [Encoders::Null.new]
      else
        real_encoders = encoders_to_run.collect { |er| encoders.find { |e| e.name? er } }.compact
      end

      real_encoders.reduce(block.call) do |memo, e| 
        e.encode(memo)
      end
    end
  end
end
