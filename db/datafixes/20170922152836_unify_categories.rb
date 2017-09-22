class Datafixes::UnifyCategories < Datafix
  def self.up
    Organization.all.each do |organization|
      duplicated_categories_names.each do |category_name|
        categories = Category.where(name: category_name).order(:id)
        Interest.where(category: categories).each { |interest| interest.update_attributes(category: categories.first) }
        categories.where.not(id: categories.first).delete_all
      end
    end
  end

  private

  def self.duplicated_categories_names
    Category.where(organization: Organization.first).select(:name).having('COUNT(categories.name) > 1').group(:name).pluck(:name)
  end
end
