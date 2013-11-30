class SignupsController < ApplicationController
  def new
    @signup_form = SignUpForm.new
  end

  def create
    @signup_form = SignUpForm.new(params)
    if @signup_form.save
      redirect_to home_path
    else
      render :new
    end
  end
end
