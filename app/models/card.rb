class Card < ActiveRecord::Base
  belongs_to :list
  has_many :movements, dependent: :destroy
  has_many :tasks, dependent: :destroy
  # Destroys associated tasks & movements when card is destroyed
  # Can also use delete, which ignores callbacks (deletes from the database directly)

  validates :list_id, presence: true, numericality: { only_integer: true }
  validates :title, presence: true, length: { minimum: 3 }

  def recalculate_priority
    case self.list.position_id
    when 0
      self.update(priority: 1) # Interested
    when 1
      self.update(priority: 2) # Find Advocate - In progress
    when 2
      self.update(priority: 1) # Apply - Done
    when 3
      self.update(priority: 2) # Apply - In progress
    when 4
      self.update(priority: 1) # Apply - Done
    when 5
      self.update(priority: 3) # Interview
    end
    # Will need to extend this later if we want more lists.
  end

  def set_next_task
    # pending
  end

  # schema attributes
  # :list_id,
  # :organization_name,
  # :organization_summary,
  # :position_applied_for,
  # :position_description,
  # :advocate,
  # :tech_stack,
  # :recent_articles,
  # :glassdoor_rating,
  # :title,
  # :description
  # "points",               default: 1
  # "priority",             default: 1
  # "next_task"
  # "archived",             default: false
end
