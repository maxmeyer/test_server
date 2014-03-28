# encoding: utf-8
module TestServer
  module Encoders
    class Base64Strict < Encoder
      def encode(string)
        ::Base64.strict_encode64(string)
      end

      def decode(string)
        ::Base64.strict_decode64(string)
      end
    end
  end
end
