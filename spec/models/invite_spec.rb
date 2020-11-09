require 'rails_helper'

RSpec.describe Invite, type: :model do
 
  describe "state transition method check" do
    
    invite = Invite.new

    context "pending to other transitions" do
      it "should return true for pending to any transition " do
        expect(invite.send(:state_transition_check, 'pending', 'accepted')).to  be(true)
        expect(invite.send(:state_transition_check, 'pending', 'rejected')).to  be(true)
      end

      it "should return false for pending to nil transition " do
        expect(invite.send(:state_transition_check, 'pending', nil)).to  be(false)
      end
    end

    context "accepted to other transitions" do
      it "should return true for accepted to rejected, accpeted transition " do
        expect(invite.send(:state_transition_check, 'accepted', 'rejected')).to  be(true)
        expect(invite.send(:state_transition_check, 'accepted', 'accepted')).to  be(true)
      end

      it "should return false for accepted to pending or nil transition " do
        expect(invite.send(:state_transition_check, 'accpeted', nil)).to  be(false)
        expect(invite.send(:state_transition_check, 'accpeted', 'pending')).to  be(false)
      end
    end

    context "rejected to other transitions" do
      it "should return true for rejected to accepted, rejected transition " do
        expect(invite.send(:state_transition_check, 'rejected', 'accepted')).to  be(true)
        expect(invite.send(:state_transition_check, 'rejected', 'rejected')).to  be(true)
      end

      it "should return false for rejected to nil transition " do
        expect(invite.send(:state_transition_check, 'rejected', nil)).to  be(false)
        expect(invite.send(:state_transition_check, 'rejected', 'pending')).to  be(false)
      end
    end
  end
end
