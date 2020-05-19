# Model of Subscription
# models/subscription.rb
#
# Author::    Nouman Tayyab  (mailto:nouman@weareavp.com)
class Subscription < ApplicationRecord
  attr_accessor :plan_type
  belongs_to :organization
  belongs_to :plan
  enum status: { inactive: 0, active: 1 }
  accepts_nested_attributes_for :organization
end
