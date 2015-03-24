class Task < ActiveRecord::Base
  belongs_to :problem
  belongs_to :job
  belongs_to :student
  belongs_to :user

  counter_culture :student,
    :column_name => Proc.new {|model| !model.accepted? ? 'tasks_left_count' : nil },
    :column_names => { ["NOT tasks.status = ?", 3] => 'tasks_left_count' } # accepted status equals 3

  has_many :submissions, dependent: :destroy
  has_many :notes, through: :submissions

  enum status: [ :not_submitted, :waiting, :accepted_partially, :accepted ]

  accepts_nested_attributes_for :submissions, :reject_if => :all_blank, :allow_destroy => true

  def name
    if problem.name || (not problem.name.blank?)
      name = problem.name
    else
      name = "#{problem.homework.number}.#{problem.number}"
    end

    name = "Тест, " + name if problem.homework.test?

    name
  end
end


