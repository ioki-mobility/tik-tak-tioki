# frozen_string_literal: true

RSpec::Matchers.define :be_a_product_decision do |expected|
  match do |actual|
    actual.metadata.has_key?(:product_decision) && actual.metadata[:product_decision] == true
  end
end
