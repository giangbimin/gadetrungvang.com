module Base
  require 'csv'
  extend ActiveSupport::Concern

  def initialize(users, campaign_name, text_content)
    @users = users
    @campaign_name = campaign_name
    @text_content = text_content
  end

  class_methods do
    def perform(*args, &block)
      @instance ||= new
      @instance.perform!(*args, &block)
    end
  end
end
