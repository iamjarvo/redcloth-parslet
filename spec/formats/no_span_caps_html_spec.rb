require File.dirname(__FILE__) + '/../spec_helper'

describe "no_span_caps_html" do
  examples_from_yaml do |doc|
    RedClothParslet.new(doc['in'], [:no_span_caps]).to_html(:sort_attributes)
  end
end
