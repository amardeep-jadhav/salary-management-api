class SalaryInsightsQuery
  def initialize(params = {})
    @params  = params
    @country = params[:country]
  end

  def salary_by_country
    scope = Employee.active
    scope = scope.where(country: @country) if @country.present?
    scope
      .joins(:job_title)
      .select(
        "employees.country",
        "MIN(employees.salary) as min_salary",
        "MAX(employees.salary) as max_salary",
        "ROUND(AVG(employees.salary), 2) as avg_salary",
        "COUNT(employees.id) as headcount"
      )
      .group("employees.country")
      .order("avg_salary DESC")
      .map do |r|
        {
          country:     r.country,
          min_salary:  r.min_salary,
          max_salary:  r.max_salary,
          avg_salary:  r.avg_salary,
          headcount:   r.headcount
        }
      end
  end

  def salary_by_job_title
    scope = Employee.active
    scope = scope.where(country: @country) if @country.present?
    scope
      .joins(:job_title)
      .select(
        "job_titles.name as job_title_name",
        "job_titles.level as job_title_level",
        "ROUND(AVG(employees.salary), 2) as avg_salary",
        "COUNT(employees.id) as headcount"
      )
      .group("job_titles.name, job_titles.level")
      .order("avg_salary DESC")
      .map do |r|
        {
          job_title:  r.job_title_name,
          level:      r.job_title_level,
          avg_salary: r.avg_salary,
          headcount:  r.headcount
        }
      end
  end

  def headcount_by_department
    Employee.active
      .joins(:department)
      .select(
        "departments.name as department_name",
        "COUNT(employees.id) as headcount"
      )
      .group("departments.name")
      .order("headcount DESC")
      .map do |r|
        {
          department: r.department_name,
          headcount:  r.headcount
        }
      end
  end

  def salary_distribution
    salaries = Employee.active.pluck(:salary).map(&:to_f)
    bands = {
      "0-30k"    => 0,
      "30k-60k"  => 0,
      "60k-100k" => 0,
      "100k+"    => 0
    }
    salaries.each do |s|
      if s < 30_000
        bands["0-30k"] += 1
      elsif s < 60_000
        bands["30k-60k"] += 1
      elsif s < 100_000
        bands["60k-100k"] += 1
      else
        bands["100k+"] += 1
      end
    end
    bands.map { |range, count| { range: range, count: count } }
  end

  def top_paid_roles
    Employee.active
      .joins(:job_title)
      .select(
        "job_titles.name as job_title_name",
        "ROUND(AVG(employees.salary), 2) as avg_salary"
      )
      .group("job_titles.name")
      .order("avg_salary DESC")
      .limit(5)
      .map do |r|
        {
          job_title:  r.job_title_name,
          avg_salary: r.avg_salary
        }
      end
  end

  def recent_hires
    Employee.active
      .where(hired_on: 90.days.ago..)
      .includes(:department, :job_title)
      .order(hired_on: :desc)
      .map do |e|
        {
          full_name:  e.full_name,
          job_title:  e.job_title.name,
          department: e.department.name,
          country:    e.country,
          hired_on:   e.hired_on
        }
      end
  end
end
