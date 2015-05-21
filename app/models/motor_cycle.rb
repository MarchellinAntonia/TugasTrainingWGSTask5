class MotorCycle < ActiveRecord::Base
belongs_to :employee, dependent: :delete
end
