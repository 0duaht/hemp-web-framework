require "spec_helper"

describe "Application class" do
  it "responds to call" do
    expect(Hemp::Application.new).to respond_to :call
  end
end
