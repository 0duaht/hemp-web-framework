require "spec_helper"

describe "Application class" do
  it "responds to call" do
    expect(Hemp::Application.new).to respond_to :call
  end

  context "response from call method" do
    subject do
      Array.new(Hemp::Application.new.call({}))
    end

    it "responds with a 200 status" do
      expect(subject.first).to eql 200
    end

    it "responds with empty header hash" do
      expect(subject[1]).to be_empty
    end

    it "responds with an array containing Hello string" do
      expect(subject[2]).to eql ["Hello from Hemp!"]
    end
  end
end
