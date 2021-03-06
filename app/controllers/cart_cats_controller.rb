# frozen_string_literal: true

class CartCatsController < ApplicationController
  def new
    @cart_cat = CartCat.new(params)
    @current_cart = current_cart
  end

  def create
    if user_signed_in?
      # use this condition instead of before_action
      # so that we can redirect to some other page with
      # message instead of simple login
      if current_cart.cart_cats.find_by(cat_id: params[:id])
        @cart_cat = current_cart.cart_cats.find_by(cat_id: params[:id])
        @cart_cat.increment_quantity
      else
        @cart_cat = CartCat.new(cart_id: current_cart.id, cat_id: params[:id], price: params[:price])
      end
      if @cart_cat.save
        flash[:success] = "#{@cart_cat.cat.title} ajouté à votre panier."
        redirect_to cats_path
      else
        flash[:warning] = "Une erreur est survenue: cat could not be saved to cart."
      end
    else
      # TODO: CTRL change this to more user friendly redirection?
      flash[:warning] = "Vous devez être connecté pour voir votre panier"
      redirect_to new_user_registration_path
    end
  end

  def destroy
    @cart_cat = CartCat.find(params[:id])
    @cart_cat.destroy
    redirect_to cart_path(current_user.current_cart)
  end

  def index_current_cart(cart_id); end

  delegate :current_cart, to: :current_user

  private

  def cart_cat_params
    params.require(:cart_cat).permit(:cat_id, :quantity, :price)
  end
end
