# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*attributes)
    attributes.each do |attribute|
      define_method((attribute.to_s + '=').to_sym) do |value|
        instance_variable_set(('@' + attribute.to_s).to_sym, value)
        instance_variable_get(('@' + attribute.to_s + '_history').to_sym) || instance_variable_set(
          ('@' + attribute.to_s + '_history').to_sym, []
        )
        instance_variable_get(('@' + attribute.to_s + '_history').to_sym) << value
      end
      define_method(attribute) do
        instance_variable_get(('@' + attribute.to_s).to_sym)
      end

      define_method((attribute.to_s + '_history').to_sym) do
        instance_variable_get(('@' + attribute.to_s + '_history').to_sym)
      end
    end
  end

  def strong_attr_accessor(attributes_with_class)
    attributes_with_class.each do |attribute, attribute_class|
      define_method((attribute.to_s + '=').to_sym) do |value|
        if value.instance_of?(attribute_class)
          instance_variable_set(('@' + attribute.to_s).to_sym, value)
        else
          raise ArgumentError
        end
      end
      define_method(attribute) do
        instance_variable_get(('@' + attribute.to_s).to_sym)
      end
    end
  end
end
