class AddSubscriptionsCountToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :subscriptions_count, :integer, default: 0
  end
end
