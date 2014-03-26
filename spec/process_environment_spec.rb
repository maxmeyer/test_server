# encoding: utf-8
require 'spec_helper'

describe ProcessEnvironment do
  context '#initialize' do
    it 'accepts an environment' do
      expect {
        ProcessEnvironment.new(ENV.to_hash)
      }.not_to raise_error
    end
  end

  context '#fetch' do
    it 'fetches environment variable' do
      env = ProcessEnvironment.new(variable: 'value')
      expect(env.fetch(:variable)).to eq('value')
    end

    it 'returns an empty string if variable cannot be found' do
      env = ProcessEnvironment.new({})
      expect(env.fetch(:variable)).to eq('')
    end
  end
end
