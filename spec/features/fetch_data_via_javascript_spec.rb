# encoding: utf-8
require 'spec_helper'

describe 'Fetch data via javascript', :js do
  context '/xhr/string/' do
    it 'submits requests to url' do

      visit '/xhr/string/'

      within '#form' do
        fill_in 'url', :with => '§ASDF$$'
      end

      click_button '#submit'
      click_on('Search')
    end

  end
end
