# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ActionController::RequestForgeryProtection

  protect_from_forgery with: :exception if proc { |c| c.request.format != 'application/json' }
  protect_from_forgery with: :null_session if proc { |c| c.request.format == 'application/json' }
end
