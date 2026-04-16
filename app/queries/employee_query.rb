class EmployeeQuery
  def initialize(params = {})
    @params = params
    @scope  = Employee.active.includes(:department, :job_title)
  end

  def call
    filter_by_country
    filter_by_department
    filter_by_search
    sort
    @scope
  end

  private

  def filter_by_country
    return unless @params[:country].present?
    @scope = @scope.where(country: @params[:country])
  end

  def filter_by_department
    return unless @params[:department_id].present?
    @scope = @scope.where(department_id: @params[:department_id])
  end

  def filter_by_search
    return unless @params[:search].present?
    @scope = @scope.where(
      "employees.full_name ILIKE :q OR employees.email ILIKE :q",
      q: "%#{@params[:search]}%"
    )
  end

  def sort
    allowed = %w[full_name salary hired_on]
    column    = allowed.include?(@params[:sort]) ? @params[:sort] : "full_name"
    direction = @params[:direction] == "desc" ? "desc" : "asc"
    @scope    = @scope.order("#{column} #{direction}")
  end
end
