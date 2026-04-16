module Employees
  class Updater
    def initialize(employee, params)
      @employee = employee
      @params   = params
    end

    def call
      if @employee.update(@params)
        ServiceResult.success(payload: @employee)
      else
        ServiceResult.failure(errors: @employee.errors.full_messages)
      end
    end
  end
end
