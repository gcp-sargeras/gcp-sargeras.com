# frozen_string_literal: true

class Token < ApplicationRecord
  validates :app, uniqueness: true
  before_save :generate_token

  def generate_token
    self.token ||= SecureRandom.urlsafe_base64
  end
end
