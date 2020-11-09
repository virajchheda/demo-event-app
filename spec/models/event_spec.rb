require 'rails_helper'

RSpec.describe Event, type: :model do
  
  subject { 
    described_class.new(name: "test", description: "test", event_at: DateTime.now + 10.minutes, duration: 10)
  }

  it "is valid with valid  attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).to_not be_valid
  end

  it "is not valid without a description" do
    subject.description = nil
    expect(subject).to_not be_valid
  end
  
  it "is not valid without a event_at or past date" do
    subject.event_at = nil
    expect(subject).to_not be_valid

    subject.event_at = DateTime.now - 10.minutes
    expect(subject).to_not be_valid
  end
  
  it "is not valid without a duration or 0" do
    subject.duration = nil 
    expect(subject).to_not be_valid

    subject.duration = 0 
    expect(subject).to_not be_valid
  end
end
