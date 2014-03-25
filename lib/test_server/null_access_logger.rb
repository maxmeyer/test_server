# encoding: utf-8
module TestServer
  class NullAccessLogger
    def write(*args, &block); end
  end
end
