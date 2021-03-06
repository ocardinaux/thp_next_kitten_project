# frozen_string_literal: true

module CartCatsHelper
  def cat_data_for_seller(cat_id)
    cart_cats = CartCat.where(cat: cat_id)
    cats_data = []
    cart_cats.each do |cart_cat|
      cart = Cart.find(cart_cat.cart_id)
      next unless cart.status == true

      cat_data_for_seller = {}
      cat_data_for_seller[:user] = cart.user.profile.full_name_or_email
      cat_data_for_seller[:date] = cart.order_placed.strftime("%F")
      cat_data_for_seller[:quantity] = cart_cat.quantity
      cat_data_for_seller[:total_price] = cart_cat.total_cat_price
      cats_data << cat_data_for_seller
    end
    cats_data
  end
end
