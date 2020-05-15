class DetailOrder < ApplicationRecord
  belongs_to :order
  belongs_to :product
  scope :find_by_order_id, ->(id){where order_id: id}
end
