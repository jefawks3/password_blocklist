# frozen_string_literal: true

# Validator class for password blocklist validations
#
# @example Validates that the password attribute is not in the blocklist.
# If an empty value is passed for the attribute, the validation is ignored.
#
#   class User < ApplicationRecord
#     validates :password, presence: true, password_blocklist: true,
#       if: (user) -> { user.new_record? || user.password_changed? }
#   end
#
# @example Validates that the password attribute is not is a specified blocklist.
# If an empty value is passed for the attribute, the validation is ignored.
#
#   class User < ApplicationRecord
#     validates :password, presence: true, password_blocklist: { list_size: :xl },
#       if: (user) -> { user.new_record? || user.password_changed? }
#   end
#
class PasswordBlocklistValidator < ActiveModel::EachValidator
  # Validates the +value+ against the password blocklist.
  #
  # The validation will be skipped and return no errors if the +value+ is blank.
  #
  # @param record [ActiveModel::Validations] The object being validated.
  # @param attribute [Symbol] The password attribute name on the record that is being validated.
  # @param value [String] The value of the password attribute on the record that is being validated.
  def validate_each(record, attribute, value)
    record.errors.add(attribute, message) if value.present? && blocked?(value)
  end

  private

  def blocked?(value)
    PasswordBlocklist.blocklisted?(value, options[:list_size])
  end

  def message
    options[:message] || :password_blocked
  end
end
