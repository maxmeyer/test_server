RSpec::Matchers.define :be_a_multiple_of do |expected|
  match do |actual|
    actual % expected == 0
  end

  failure_message_for_should do |actual|
    "expected that #{actual} would be a precise multiple of #{expected}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual} would not be a precise multiple of #{expected}"
  end

  description do
    "be a precise multiple of #{expected}"
  end
end
