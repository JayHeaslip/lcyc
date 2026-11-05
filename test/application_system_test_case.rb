require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome

  setup do
    page.driver.browser.manage.window.resize_to(1400, 1400)
  end
end
