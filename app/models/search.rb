class Search < ApplicationRecord
  CATEGORIES = %w(all question user answer comment)

  def self.detect_with_query(category, query)
    return [] unless CATEGORIES.include?(category)

    query = ThinkingSphinx::Query.escape(query) unless query.nil?

    if category == 'all'
      ThinkingSphinx.search("#{query}*")
    else
      category.classify.constantize.search("#{query}*")
    end
  end
end
