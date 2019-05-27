class Question < ApplicationRecord
  has_many :answers, inverse_of: :question
  accepts_nested_attributes_for :answers, reject_if: :all_blank, allow_destroy: true
end
