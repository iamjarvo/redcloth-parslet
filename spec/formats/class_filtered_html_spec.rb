require File.dirname(__FILE__) + '/../spec_helper'

describe "class_filtered_html" do
  examples_from_yaml do |doc|
    RedClothParslet.new(doc['in'], [:filter_classes]).to_html(:sort_attributes)
  end
end
