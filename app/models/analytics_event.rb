class AnalyticsEvent < ApplicationRecord
  belongs_to :user
  belongs_to :product
  belongs_to :category
  belongs_to :section
end
