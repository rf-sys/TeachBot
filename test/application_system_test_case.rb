require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :poltergeist

  # set default page size
  setup do
    page.driver.resize(1920, 1080)
  end
end
