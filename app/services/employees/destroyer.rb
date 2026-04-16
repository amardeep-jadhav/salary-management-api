module Employees
  class Destroyer
    def initialize(employee)
      @employee = employee
    end

    def call
      if @employee.update(active: false)
        ServiceResult.success(payload: @employee)
      else
        ServiceResult.failure(errors: @employee.errors.full_messages)
      end
    end
  end
end
