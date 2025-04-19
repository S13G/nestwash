# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  enum :role, { customer: "customer", driver: "driver", service_provider: "service_provider" }

  validates :email_address, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :role, inclusion: { in: roles.keys }
end
