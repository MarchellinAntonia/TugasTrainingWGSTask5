class Employee < ActiveRecord::Base
has_one :motor_cycle, dependent: :destroy
end
