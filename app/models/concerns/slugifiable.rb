module Slugifiable

  module InstanceMethods

    def slug
      name.downcase.split.join("-")
    end

  end

  module ClassMethods

    def find_by_slug(slug)
      self.all.detect {|topic| topic.slug == slug}
    end

  end
end
