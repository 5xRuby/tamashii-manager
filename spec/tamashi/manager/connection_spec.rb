require 'spec_helper'

require 'tamashi/manager/connection'
require 'tamashi/manager/client'

RSpec.describe Tamashi::Manager::Connection do
  let(:client) { double(Tamashi::Manager::Client) }

  it "can add client" do
    subject.add(client)
    expect(subject.size).to be 1
  end

  it "can remove client" do
    subject.add(client)
    expect(subject.size).to be 1

    subject.delete(client)
    expect(subject.size).to be 0
  end

  describe ".instance" do
    it { expect(described_class.instance).to be_instance_of(Tamashi::Manager::Connection) }
  end

  describe ".available?" do
    before do
      expect(described_class).to receive(:instance).and_return(subject).at_least(:once)
    end

    context "has client" do
      before { described_class.register(client) }
      it { expect(described_class.available?).to be true }
    end

    context "has no client" do
      before { described_class.unregister(client) }
      it { expect(described_class.available?).to be false }
    end
  end
end
