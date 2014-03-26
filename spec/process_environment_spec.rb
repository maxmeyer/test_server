# encoding: utf-8
require 'spec_helper'

describe ProcessEnvironment do
  context '#initialize' do
    it 'accepts an environment' do
      env = double('ENV')
      allow(env).to receive(:to_hash).and_return({})

      expect {
        ProcessEnvironment.new(env)
      }.not_to raise_error
    end
  end

  context '#fetch' do
    it 'fetches environment variable' do
      env = double('ENV')
      allow(env).to receive(:to_hash).and_return({variable: 'value'})

      env = ProcessEnvironment.new(env)
      expect(env.fetch(:variable)).to eq('value')
    end

    it 'returns an empty string if variable cannot be found' do
      env = double('ENV')
      allow(env).to receive(:to_hash).and_return({})

      env = ProcessEnvironment.new(env)
      expect(env.fetch(:variable)).to eq('')
    end
  end

  context '#write' do
    it 'writes to environment' do
      env = double('ENV')
      allow(env).to receive(:to_hash).and_return({})
      expect(env).to receive(:[]=).with('variable', 'value')

      env = ProcessEnvironment.new(env)
      env.write(:variable, 'value')
    end
  end
end
