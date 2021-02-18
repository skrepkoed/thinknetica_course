# frozen_string_literal: true

module InsufficientException
  def singleton_exception(exception, attribute)
    attribute.define_singleton_method(:empty_entity?) do
      empty? ? (raise exception) : false
    end
  end
end
