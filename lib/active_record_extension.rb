module ActiveRecordExtension
  extend ActiveSupport::Concern

  def has_url?
    if self.url
      routes = Rails.application.routes.routes.collect { |r| r.defaults[:controller] }.uniq
      routes.include?(self.class.name.downcase.pluralize)
    else
      false
    end
  end

  def url
    nil
  end
end

ActiveRecord::Base.send(:include, ActiveRecordExtension)
