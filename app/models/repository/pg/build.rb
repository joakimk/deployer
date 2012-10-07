require 'repository/pg/base'

module Repository
  class PG::Build < PG::Base
    entity_klass Entity::Build

    def find_known_by(attributes)
      record_klass.where(
        project:  attributes[:project],
        step:     attributes[:step],
        revision: attributes[:revision]
      ).first
    end

    private

    def record_klass
      Record
    end

    class Record < ActiveRecord::Base
      attr_accessible :project, :step, :revision, :status
      self.table_name = :builds
    end
  end
end
