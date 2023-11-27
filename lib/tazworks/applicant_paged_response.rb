# frozen_string_literal: true

module Tazworks
  # Handles pagination for Applicant responses such as GET All Applicants
  class ApplicantPagedResponse < PagedResponse
    def self.base_class
      Applicant
    end

    def applicants
      response_to_models
    end

    def map_individual_object_ids(ids, attributes)
      ids[:applicantGuid] = attributes[:applicantGuid]
      ids
    end
  end
end
