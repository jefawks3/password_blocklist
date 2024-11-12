# frozen_string_literal: true

require 'spec_helper'

class Model
  include ActiveModel::Validations

  attr_accessor :password
end

def create_model(password)
  Model.new.tap { |model| model.password = password }
end

RSpec.describe PasswordBlocklistValidator do
  after do
    Model.clear_validators!
  end

  context 'when blocked' do
    it 'marks the model as invalid' do
      Model.validates :password, password_blocklist: true
      model = create_model('password')
      expect(model).not_to be_valid
    end

    it 'marks the password as password_blocked' do
      Model.validates :password, password_blocklist: true
      model = create_model('password')
      model.valid?
      expect(model.errors).to be_added(:password, :password_blocked)
    end

    it 'shows the error "is blocked"' do
      Model.validates :password, password_blocklist: true
      model = create_model('password')
      model.valid?
      expect(model.errors[:password].first).to eq('is blocked')
    end

    it 'allows the list_size to be set via options' do
      allow(PasswordBlocklist).to receive(:blocklisted?).and_call_original
      Model.validates :password, password_blocklist: { list_size: :lg }
      model = create_model('password')
      model.valid?
      expect(PasswordBlocklist).to have_received(:blocklisted?).with('password', :lg)
    end
  end

  context "when model's password is not present" do
    it 'is valid with `nil` password' do
      Model.validates :password, password_blocklist: true
      model = create_model(nil)
      expect(model).to be_valid
    end

    it 'is valid with `blank` password' do
      Model.validates :password, password_blocklist: true
      model = create_model('')
      expect(model).to be_valid
    end
  end
end
