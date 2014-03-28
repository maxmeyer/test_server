# encoding: utf-8
module TestServer
  class Encoder
    include Comparable

    def name
      self.class.to_s.demodulize.underscore.to_sym
    end

    def encode(string)
      fail NotImplementedError, JSON.dump(method: 'encode')
    end

    def decode(string)
      fail NotImplementedError, JSON.dump(method: 'decode')
    end

    def name?(n)
      name == n
    end

    def eql?(other)
      name? other.name
    end

    def hash
      Digest::SHA1.hexdigest name.to_s
    end

    def <=>(other)
      name <=> other.name
    end

    def find_by_name(name)
    rescue NameError
      raise 
    end
  end
end
