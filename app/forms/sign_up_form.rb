class SignUpForm
  include ActiveModel::Model

  attr_reader :user
  attr_reader :items

  validate :at_least_one_item_should_be_presence
  def at_least_one_item_should_be_presence
    if @items.empty?
      errors.add(:items, 'at least one should be present')
    end
  end

  def initialize(params = {})
    @user = User.new(user_params(params))
    @items = build_items(items_params(params))
  end

  def save
    valid? && persist
  end

  def valid?
    super
    @user.valid?
    @items.each(&:valid?)
    errors.empty? && @user.errors.empty? && @items.all?{ |item| item.errors.empty? }
  end

  def error_full_messages
    messages_list = errors.full_messages
    messages_list += @user.errors.full_messages

    @items.each do |item|
      messages_list += item.errors.full_messages
    end

    messages_list
  end

  private
  def persist
    ActiveRecord::Base.transaction do
      company = Company.create!
      order = company.orders.create!

      @user.company = company
      @user.save!

      @items.each do |item|
        item.order = order
        item.save!
        # authorize_and_save(item)
      end

      AdminMailer.delay.notify(order.id)

      return true
    end
  end

  # pseudo code
  def authorize_and_save(object)
    if current_ability.can?(:create, object)
      object.save!
    else
      errors.add(:security, "not authorized for")
      raise ActiveRecord::Rollback
    end
  end

  def build_items(items_attributes)
    items_attributes.map do |attributes|
      Item.new(attributes)
    end
  end

  def user_params(params)
    params.fetch(:user, {}).slice(:email).to_hash
  end

  def items_params(params)
    # input
    # {
    #   items => {
    #     "1"=>{
    #       "title"=>"Some Title"
    #     }
    #   }
    # }
    #
    # output
    # [
    #   { "title" => "Some Title" }
    # ]
    params.fetch(:user, {}).fetch(:items, {}).values.map do |item_hash|
      item_hash.slice(:title).to_hash
    end
  end

end
