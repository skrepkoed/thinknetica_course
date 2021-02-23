# frozen_string_literal: true

module Validation
  def self.included(base)
    base.include InstanceMethods
    base.extend ClassMethods
  end

  module ClassMethods
    def validations
      @@validations ||= []
    end

    private

    def validate(attribute, validation, args = nil)
      if args
        define_method((validation.to_s + '_' + attribute.to_s).to_sym) do
          send(validation, instance_variable_get(('@' + attribute.to_s).to_sym), args)
        end
      else
        define_method((validation.to_s + '_' + attribute.to_s).to_sym) do
          send(validation, instance_variable_get(('@' + attribute.to_s).to_sym))
        end
      end
      validations << (validation.to_s + '_' + attribute.to_s).to_sym
    end
  end

  module InstanceMethods
    include ExceptionsModule::TrainExceptions
    include ExceptionsModule::RailwayExceptions

    private

    def format(string, format)
      raise InvalidTrainNumberError if string !~ format
    end

    def presence(attribute)
      raise InsufficientEntity unless attribute
    end

    def attribute_type(attribute, attr_type)
      raise ArgumentError if attribute.class != attr_type
    end

    def validate!
      self.class.validations.each { |validation| send(validation) }
    end

    def valid?
      validate!
    rescue RuntimeError
      false
    else
      true
    end
  end
end
