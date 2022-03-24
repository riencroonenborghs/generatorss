class ApplicationController < ActionController::Base
  def mobile?
    browser.device.mobile?
  end
  helper_method :mobile?
end
